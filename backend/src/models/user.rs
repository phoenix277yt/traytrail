use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc};
use sqlx::FromRow;

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct User {
    pub id: String,
    pub username: String,
    pub email: String,
    pub password_hash: Option<String>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UserResponse {
    pub id: String,
    pub username: String,
    pub email: String,
    pub created_at: DateTime<Utc>,
}

impl From<User> for UserResponse {
    fn from(user: User) -> Self {
        Self {
            id: user.id,
            username: user.username,
            email: user.email,
            created_at: user.created_at,
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct UserPreferencesDb {
    pub user_id: String,
    // Theme preferences
    pub theme_is_dark_mode: bool,
    pub theme_primary_color: String,
    pub theme_accent_color: String,
    pub theme_text_scale: f64,
    pub theme_use_system_theme: bool,
    // Notification preferences
    pub notifications_enabled: bool,
    pub notifications_menu_updates: bool,
    pub notifications_poll_notifications: bool,
    pub notifications_feedback_responses: bool,
    pub notifications_promotions: bool,
    pub notifications_quiet_hours_start: String,
    pub notifications_quiet_hours_end: String,
    // Accessibility preferences
    pub accessibility_haptic_feedback: bool,
    pub accessibility_sound_effects: bool,
    pub accessibility_reduce_animations: bool,
    pub accessibility_high_contrast: bool,
    pub accessibility_animation_speed: f64,
    pub accessibility_screen_reader: bool,
    // Food preferences
    pub food_disliked_foods: String, // JSON array
    pub food_favorite_categories: String, // JSON array
    pub food_spice_preference: i32,
    // Meta
    pub is_first_time: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ThemePreferences {
    pub is_dark_mode: bool,
    pub primary_color: String,
    pub accent_color: String,
    pub text_scale: f64,
    pub use_system_theme: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NotificationPreferences {
    pub enabled: bool,
    pub menu_updates: bool,
    pub poll_notifications: bool,
    pub feedback_responses: bool,
    pub promotions: bool,
    pub quiet_hours_start: String,
    pub quiet_hours_end: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AccessibilityPreferences {
    pub enable_haptic_feedback: bool,
    pub enable_sound_effects: bool,
    pub reduce_animations: bool,
    pub high_contrast: bool,
    pub animation_speed: f64,
    pub screen_reader: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FoodPreferences {
    pub disliked_foods: Vec<String>,
    pub favorite_categories: Vec<String>,
    pub spice_preference: i32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UserPreferencesResponse {
    pub user_id: String,
    pub username: String,
    pub email: String,
    pub theme: ThemePreferences,
    pub notifications: NotificationPreferences,
    pub accessibility: AccessibilityPreferences,
    pub food: FoodPreferences,
    pub last_updated: DateTime<Utc>,
    pub is_first_time: bool,
}

impl UserPreferencesResponse {
    pub fn from_db_with_user(prefs: UserPreferencesDb, user: User) -> Self {
        let disliked_foods: Vec<String> = serde_json::from_str(&prefs.food_disliked_foods).unwrap_or_default();
        let favorite_categories: Vec<String> = serde_json::from_str(&prefs.food_favorite_categories).unwrap_or_default();

        Self {
            user_id: prefs.user_id,
            username: user.username,
            email: user.email,
            theme: ThemePreferences {
                is_dark_mode: prefs.theme_is_dark_mode,
                primary_color: prefs.theme_primary_color,
                accent_color: prefs.theme_accent_color,
                text_scale: prefs.theme_text_scale,
                use_system_theme: prefs.theme_use_system_theme,
            },
            notifications: NotificationPreferences {
                enabled: prefs.notifications_enabled,
                menu_updates: prefs.notifications_menu_updates,
                poll_notifications: prefs.notifications_poll_notifications,
                feedback_responses: prefs.notifications_feedback_responses,
                promotions: prefs.notifications_promotions,
                quiet_hours_start: prefs.notifications_quiet_hours_start,
                quiet_hours_end: prefs.notifications_quiet_hours_end,
            },
            accessibility: AccessibilityPreferences {
                enable_haptic_feedback: prefs.accessibility_haptic_feedback,
                enable_sound_effects: prefs.accessibility_sound_effects,
                reduce_animations: prefs.accessibility_reduce_animations,
                high_contrast: prefs.accessibility_high_contrast,
                animation_speed: prefs.accessibility_animation_speed,
                screen_reader: prefs.accessibility_screen_reader,
            },
            food: FoodPreferences {
                disliked_foods,
                favorite_categories,
                spice_preference: prefs.food_spice_preference,
            },
            last_updated: prefs.updated_at,
            is_first_time: prefs.is_first_time,
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UpdateUserPreferencesRequest {
    pub theme: Option<ThemePreferences>,
    pub notifications: Option<NotificationPreferences>,
    pub accessibility: Option<AccessibilityPreferences>,
    pub food: Option<FoodPreferences>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CreateUserRequest {
    pub username: String,
    pub email: String,
    pub password: Option<String>,
}