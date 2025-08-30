use sqlx::{sqlite::SqlitePool, Row};
use tracing::{info, error};
use anyhow::Result;

#[derive(Clone)]
pub struct Database {
    pool: SqlitePool,
}

impl Database {
    pub async fn new(database_url: &str) -> Result<Self> {
        info!("Connecting to database: {}", database_url);
        let pool = SqlitePool::connect(database_url).await?;
        Ok(Database { pool })
    }

    pub fn pool(&self) -> &SqlitePool {
        &self.pool
    }

    pub async fn migrate(&self) -> Result<()> {
        info!("Running database migrations...");

        // Create users table
        sqlx::query(
            r#"
            CREATE TABLE IF NOT EXISTS users (
                id TEXT PRIMARY KEY,
                username TEXT NOT NULL UNIQUE,
                email TEXT NOT NULL UNIQUE,
                password_hash TEXT,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
            "#,
        )
        .execute(&self.pool)
        .await?;

        // Create user_preferences table
        sqlx::query(
            r#"
            CREATE TABLE IF NOT EXISTS user_preferences (
                user_id TEXT PRIMARY KEY,
                theme_is_dark_mode BOOLEAN DEFAULT FALSE,
                theme_primary_color TEXT DEFAULT '#F7E1D7',
                theme_accent_color TEXT DEFAULT '#3AB795',
                theme_text_scale REAL DEFAULT 1.0,
                theme_use_system_theme BOOLEAN DEFAULT FALSE,
                notifications_enabled BOOLEAN DEFAULT TRUE,
                notifications_menu_updates BOOLEAN DEFAULT TRUE,
                notifications_poll_notifications BOOLEAN DEFAULT TRUE,
                notifications_feedback_responses BOOLEAN DEFAULT TRUE,
                notifications_promotions BOOLEAN DEFAULT FALSE,
                notifications_quiet_hours_start TEXT DEFAULT '22:00',
                notifications_quiet_hours_end TEXT DEFAULT '07:00',
                accessibility_haptic_feedback BOOLEAN DEFAULT TRUE,
                accessibility_sound_effects BOOLEAN DEFAULT TRUE,
                accessibility_reduce_animations BOOLEAN DEFAULT FALSE,
                accessibility_high_contrast BOOLEAN DEFAULT FALSE,
                accessibility_animation_speed REAL DEFAULT 1.0,
                accessibility_screen_reader BOOLEAN DEFAULT FALSE,
                food_disliked_foods TEXT DEFAULT '[]', -- JSON array
                food_favorite_categories TEXT DEFAULT '[]', -- JSON array
                food_spice_preference INTEGER DEFAULT 2,
                is_first_time BOOLEAN DEFAULT TRUE,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
            )
            "#,
        )
        .execute(&self.pool)
        .await?;

        // Create menu_items table
        sqlx::query(
            r#"
            CREATE TABLE IF NOT EXISTS menu_items (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                description TEXT,
                category TEXT NOT NULL DEFAULT 'lunch',
                calories INTEGER DEFAULT 0,
                price REAL DEFAULT 0.0,
                is_available BOOLEAN DEFAULT TRUE,
                icon_name TEXT DEFAULT 'restaurant',
                background_color TEXT DEFAULT '#E3F2FD',
                icon_color TEXT DEFAULT '#1976D2',
                tags TEXT DEFAULT '[]', -- JSON array
                rating REAL DEFAULT 0.0,
                review_count INTEGER DEFAULT 0,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
            "#,
        )
        .execute(&self.pool)
        .await?;

        // Create daily_menus table
        sqlx::query(
            r#"
            CREATE TABLE IF NOT EXISTS daily_menus (
                id TEXT PRIMARY KEY,
                date DATE NOT NULL UNIQUE,
                is_published BOOLEAN DEFAULT FALSE,
                special_note TEXT,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
            "#,
        )
        .execute(&self.pool)
        .await?;

        // Create menu_item_assignments table (many-to-many relationship)
        sqlx::query(
            r#"
            CREATE TABLE IF NOT EXISTS menu_item_assignments (
                id TEXT PRIMARY KEY,
                daily_menu_id TEXT NOT NULL,
                menu_item_id TEXT NOT NULL,
                meal_type TEXT NOT NULL, -- breakfast, lunch, dinner, snacks
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (daily_menu_id) REFERENCES daily_menus (id) ON DELETE CASCADE,
                FOREIGN KEY (menu_item_id) REFERENCES menu_items (id) ON DELETE CASCADE,
                UNIQUE(daily_menu_id, menu_item_id, meal_type)
            )
            "#,
        )
        .execute(&self.pool)
        .await?;

        // Create polls table
        sqlx::query(
            r#"
            CREATE TABLE IF NOT EXISTS polls (
                id TEXT PRIMARY KEY,
                title TEXT NOT NULL,
                description TEXT,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                starts_at DATETIME,
                ends_at DATETIME,
                is_active BOOLEAN DEFAULT TRUE,
                is_published BOOLEAN DEFAULT FALSE,
                total_votes INTEGER DEFAULT 0,
                created_by TEXT,
                metadata TEXT DEFAULT '{}', -- JSON object
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE SET NULL
            )
            "#,
        )
        .execute(&self.pool)
        .await?;

        // Create poll_options table
        sqlx::query(
            r#"
            CREATE TABLE IF NOT EXISTS poll_options (
                id TEXT PRIMARY KEY,
                poll_id TEXT NOT NULL,
                name TEXT NOT NULL,
                description TEXT,
                votes INTEGER DEFAULT 0,
                percentage REAL DEFAULT 0.0,
                icon_name TEXT DEFAULT 'restaurant',
                background_color TEXT DEFAULT '#E3F2FD',
                icon_color TEXT DEFAULT '#1976D2',
                is_leading BOOLEAN DEFAULT FALSE,
                dietary_tags TEXT DEFAULT '[]', -- JSON array
                display_order INTEGER DEFAULT 0,
                is_active BOOLEAN DEFAULT TRUE,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (poll_id) REFERENCES polls (id) ON DELETE CASCADE
            )
            "#,
        )
        .execute(&self.pool)
        .await?;

        // Create user_votes table
        sqlx::query(
            r#"
            CREATE TABLE IF NOT EXISTS user_votes (
                id TEXT PRIMARY KEY,
                poll_id TEXT NOT NULL,
                option_id TEXT NOT NULL,
                user_id TEXT,
                ip_address TEXT,
                metadata TEXT DEFAULT '{}', -- JSON object
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (poll_id) REFERENCES polls (id) ON DELETE CASCADE,
                FOREIGN KEY (option_id) REFERENCES poll_options (id) ON DELETE CASCADE,
                FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL,
                UNIQUE(poll_id, user_id), -- One vote per user per poll
                UNIQUE(poll_id, ip_address) -- One vote per IP per poll (for anonymous users)
            )
            "#,
        )
        .execute(&self.pool)
        .await?;

        // Create feedback table
        sqlx::query(
            r#"
            CREATE TABLE IF NOT EXISTS feedback (
                id TEXT PRIMARY KEY,
                title TEXT NOT NULL,
                content TEXT NOT NULL,
                category TEXT NOT NULL DEFAULT 'food_quality',
                rating INTEGER DEFAULT 0,
                author TEXT,
                is_anonymous BOOLEAN DEFAULT FALSE,
                status TEXT DEFAULT 'pending', -- pending, in_progress, resolved, closed
                response TEXT,
                responded_at DATETIME,
                likes INTEGER DEFAULT 0,
                liked_by TEXT DEFAULT '[]', -- JSON array of user IDs
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (author) REFERENCES users (id) ON DELETE SET NULL
            )
            "#,
        )
        .execute(&self.pool)
        .await?;

        // Create feedback_replies table
        sqlx::query(
            r#"
            CREATE TABLE IF NOT EXISTS feedback_replies (
                id TEXT PRIMARY KEY,
                feedback_id TEXT NOT NULL,
                author TEXT,
                content TEXT NOT NULL,
                is_staff_reply BOOLEAN DEFAULT FALSE,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (feedback_id) REFERENCES feedback (id) ON DELETE CASCADE,
                FOREIGN KEY (author) REFERENCES users (id) ON DELETE SET NULL
            )
            "#,
        )
        .execute(&self.pool)
        .await?;

        // Create favorite_items table
        sqlx::query(
            r#"
            CREATE TABLE IF NOT EXISTS favorite_items (
                id TEXT PRIMARY KEY,
                user_id TEXT NOT NULL,
                menu_item_id TEXT NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
                FOREIGN KEY (menu_item_id) REFERENCES menu_items (id) ON DELETE CASCADE,
                UNIQUE(user_id, menu_item_id)
            )
            "#,
        )
        .execute(&self.pool)
        .await?;

        // Create indexes for better performance
        sqlx::query("CREATE INDEX IF NOT EXISTS idx_daily_menus_date ON daily_menus(date)")
            .execute(&self.pool).await?;
        sqlx::query("CREATE INDEX IF NOT EXISTS idx_menu_items_category ON menu_items(category)")
            .execute(&self.pool).await?;
        sqlx::query("CREATE INDEX IF NOT EXISTS idx_polls_active ON polls(is_active, is_published)")
            .execute(&self.pool).await?;
        sqlx::query("CREATE INDEX IF NOT EXISTS idx_feedback_category ON feedback(category)")
            .execute(&self.pool).await?;
        sqlx::query("CREATE INDEX IF NOT EXISTS idx_feedback_status ON feedback(status)")
            .execute(&self.pool).await?;

        info!("Database migrations completed successfully");
        Ok(())
    }

    pub async fn seed_data(&self) -> Result<()> {
        info!("Seeding database with sample data...");

        // Check if we already have data
        let count: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM menu_items")
            .fetch_one(&self.pool)
            .await?;

        if count > 0 {
            info!("Database already contains data, skipping seed");
            return Ok(());
        }

        // Seed sample menu items
        let menu_items = vec![
            ("item_1", "Chicken Biryani", "Fragrant basmati rice with tender chicken", "lunch", 450, 12.50),
            ("item_2", "Vegetable Curry", "Mixed vegetables in aromatic spices", "lunch", 320, 8.00),
            ("item_3", "Fresh Fruit Salad", "Seasonal fruits with honey dressing", "snacks", 150, 5.00),
            ("item_4", "Masala Dosa", "Crispy crepe with spiced potato filling", "breakfast", 280, 6.50),
            ("item_5", "Paneer Butter Masala", "Cottage cheese in rich tomato gravy", "dinner", 380, 11.00),
        ];

        for (id, name, description, category, calories, price) in menu_items {
            sqlx::query(
                r#"
                INSERT OR IGNORE INTO menu_items 
                (id, name, description, category, calories, price, is_available)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                "#,
            )
            .bind(id)
            .bind(name)
            .bind(description)
            .bind(category)
            .bind(calories)
            .bind(price)
            .bind(true)
            .execute(&self.pool)
            .await?;
        }

        // Seed a sample poll
        let poll_id = "poll_sample_1";
        sqlx::query(
            r#"
            INSERT OR IGNORE INTO polls 
            (id, title, description, is_active, is_published, total_votes)
            VALUES (?, ?, ?, ?, ?, ?)
            "#,
        )
        .bind(poll_id)
        .bind("Vote for Next Week's Special")
        .bind("Help us decide what special dish to feature next week!")
        .bind(true)
        .bind(true)
        .bind(0)
        .execute(&self.pool)
        .await?;

        let poll_options = vec![
            ("option_1", "Pav Bhaji", "Spiced vegetable curry with bread rolls"),
            ("option_2", "Chole Bhature", "Chickpea curry with fried bread"),
            ("option_3", "South Indian Thali", "Complete meal with rice, sambar, and sides"),
        ];

        for (i, (option_id, name, description)) in poll_options.iter().enumerate() {
            sqlx::query(
                r#"
                INSERT OR IGNORE INTO poll_options 
                (id, poll_id, name, description, display_order)
                VALUES (?, ?, ?, ?, ?)
                "#,
            )
            .bind(format!("{}_{}",poll_id, option_id))
            .bind(poll_id)
            .bind(name)
            .bind(description)
            .bind(i as i32)
            .execute(&self.pool)
            .await?;
        }

        info!("Database seeded successfully");
        Ok(())
    }
}