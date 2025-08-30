use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc, NaiveDate};
use sqlx::FromRow;

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct MenuItem {
    pub id: String,
    pub name: String,
    pub description: Option<String>,
    pub category: String, // breakfast, lunch, dinner, snacks
    pub calories: i32,
    pub price: f64,
    pub is_available: bool,
    pub icon_name: String,
    pub background_color: String,
    pub icon_color: String,
    pub tags: String, // JSON array as string
    pub rating: f64,
    pub review_count: i32,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MenuItemResponse {
    pub id: String,
    pub name: String,
    pub description: Option<String>,
    pub category: String,
    pub calories: i32,
    pub price: f64,
    pub is_available: bool,
    pub icon_name: String,
    pub background_color: String,
    pub icon_color: String,
    pub tags: Vec<String>, // Parsed JSON array
    pub rating: f64,
    pub review_count: i32,
}

impl From<MenuItem> for MenuItemResponse {
    fn from(item: MenuItem) -> Self {
        let tags: Vec<String> = serde_json::from_str(&item.tags).unwrap_or_default();
        Self {
            id: item.id,
            name: item.name,
            description: item.description,
            category: item.category,
            calories: item.calories,
            price: item.price,
            is_available: item.is_available,
            icon_name: item.icon_name,
            background_color: item.background_color,
            icon_color: item.icon_color,
            tags,
            rating: item.rating,
            review_count: item.review_count,
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct DailyMenu {
    pub id: String,
    pub date: NaiveDate,
    pub is_published: bool,
    pub special_note: Option<String>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DailyMenuResponse {
    pub id: String,
    pub date: String, // ISO date string
    pub breakfast_items: Vec<MenuItemResponse>,
    pub lunch_items: Vec<MenuItemResponse>,
    pub dinner_items: Vec<MenuItemResponse>,
    pub snack_items: Vec<MenuItemResponse>,
    pub is_published: bool,
    pub special_note: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CreateMenuItemRequest {
    pub name: String,
    pub description: Option<String>,
    pub category: String,
    pub calories: Option<i32>,
    pub price: Option<f64>,
    pub is_available: Option<bool>,
    pub icon_name: Option<String>,
    pub background_color: Option<String>,
    pub icon_color: Option<String>,
    pub tags: Option<Vec<String>>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CreateDailyMenuRequest {
    pub date: String, // ISO date string
    pub breakfast_item_ids: Option<Vec<String>>,
    pub lunch_item_ids: Option<Vec<String>>,
    pub dinner_item_ids: Option<Vec<String>>,
    pub snack_item_ids: Option<Vec<String>>,
    pub is_published: Option<bool>,
    pub special_note: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MenuState {
    pub weekly_menus: Vec<DailyMenuResponse>,
    pub todays_menu: Option<DailyMenuResponse>,
    pub tomorrows_menu: Option<DailyMenuResponse>,
    pub selected_category: String,
    pub favorite_item_ids: Vec<String>,
    pub item_popularity: std::collections::HashMap<String, i32>,
    pub is_loading: bool,
    pub error_message: Option<String>,
    pub last_updated: Option<DateTime<Utc>>,
}