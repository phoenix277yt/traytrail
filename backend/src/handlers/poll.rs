use axum::{
    extract::State,
    http::StatusCode,
    response::Json,
};

use crate::database::Database;

pub async fn get_polls(
    State(_db): State<Database>,
) -> Result<Json<serde_json::Value>, StatusCode> {
    // TODO: Implement get polls
    Ok(Json(serde_json::json!([])))
}

pub async fn create_poll(
    State(_db): State<Database>,
) -> Result<Json<serde_json::Value>, StatusCode> {
    // TODO: Implement create poll
    Err(StatusCode::NOT_IMPLEMENTED)
}

pub async fn get_poll_by_id(
    State(_db): State<Database>,
) -> Result<Json<serde_json::Value>, StatusCode> {
    // TODO: Implement get poll by id
    Err(StatusCode::NOT_IMPLEMENTED)
}

pub async fn vote_poll(
    State(_db): State<Database>,
) -> Result<Json<serde_json::Value>, StatusCode> {
    // TODO: Implement poll voting
    Err(StatusCode::NOT_IMPLEMENTED)
}