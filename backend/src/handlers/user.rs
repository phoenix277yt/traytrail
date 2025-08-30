use axum::{
    extract::State,
    http::StatusCode,
    response::Json,
};

use crate::database::Database;

pub async fn get_user_preferences(
    State(_db): State<Database>,
) -> Result<Json<serde_json::Value>, StatusCode> {
    // TODO: Implement get user preferences
    Ok(Json(serde_json::json!({})))
}

pub async fn update_user_preferences(
    State(_db): State<Database>,
) -> Result<Json<serde_json::Value>, StatusCode> {
    // TODO: Implement update user preferences
    Err(StatusCode::NOT_IMPLEMENTED)
}