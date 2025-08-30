use axum::{
    extract::{Query, State},
    http::StatusCode,
    response::Json,
};
use serde::Deserialize;

use crate::database::Database;
use crate::models::MenuItemResponse;

#[derive(Debug, Deserialize)]
pub struct MenuQuery {
    pub category: Option<String>,
}

pub async fn get_menu_items(
    Query(_params): Query<MenuQuery>,
    State(_db): State<Database>,
) -> Result<Json<Vec<MenuItemResponse>>, StatusCode> {
    // TODO: Implement database query
    Ok(Json(vec![]))
}

pub async fn create_menu_item(
    State(_db): State<Database>,
) -> Result<Json<MenuItemResponse>, StatusCode> {
    // TODO: Implement menu item creation
    Err(StatusCode::NOT_IMPLEMENTED)
}

pub async fn get_menus(
    State(_db): State<Database>,
) -> Result<Json<serde_json::Value>, StatusCode> {
    // TODO: Implement get menus
    Ok(Json(serde_json::json!([])))
}

pub async fn create_menu(
    State(_db): State<Database>,
) -> Result<Json<serde_json::Value>, StatusCode> {
    // TODO: Implement create menu
    Err(StatusCode::NOT_IMPLEMENTED)
}

pub async fn get_menu_by_id(
    State(_db): State<Database>,
) -> Result<Json<serde_json::Value>, StatusCode> {
    // TODO: Implement get menu by id
    Err(StatusCode::NOT_IMPLEMENTED)
}