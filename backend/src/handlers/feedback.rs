use axum::{
    extract::State,
    http::StatusCode,
    response::Json,
};

use crate::database::Database;

pub async fn get_feedback(
    State(_db): State<Database>,
) -> Result<Json<serde_json::Value>, StatusCode> {
    // TODO: Implement get feedback
    Ok(Json(serde_json::json!([])))
}

pub async fn create_feedback(
    State(_db): State<Database>,
) -> Result<Json<serde_json::Value>, StatusCode> {
    // TODO: Implement create feedback
    Err(StatusCode::NOT_IMPLEMENTED)
}