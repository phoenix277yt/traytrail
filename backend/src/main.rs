use axum::{
    http::StatusCode,
    response::Json,
    routing::{get, post},
    Router,
};
use serde_json::{json, Value};
use sqlx::sqlite::SqlitePool;
use std::net::SocketAddr;
use tower_http::cors::CorsLayer;
use tracing::{info, Level};
use tracing_subscriber;

mod database;
mod handlers;
mod models;

use database::Database;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // Initialize tracing
    tracing_subscriber::fmt()
        .with_max_level(Level::INFO)
        .init();

    info!("Starting TrayTrail Backend API Server");

    // Initialize database
    let database = Database::new("sqlite:traytrail.db").await?;
    database.migrate().await?;

    // Build our application with a route
    let app = Router::new()
        .route("/", get(root))
        .route("/health", get(health_check))
        // Menu routes
        .route("/api/menus", get(handlers::menu::get_menus))
        .route("/api/menus", post(handlers::menu::create_menu))
        .route("/api/menus/:id", get(handlers::menu::get_menu_by_id))
        .route("/api/menu-items", get(handlers::menu::get_menu_items))
        .route("/api/menu-items", post(handlers::menu::create_menu_item))
        // Poll routes
        .route("/api/polls", get(handlers::poll::get_polls))
        .route("/api/polls", post(handlers::poll::create_poll))
        .route("/api/polls/:id", get(handlers::poll::get_poll_by_id))
        .route("/api/polls/:id/vote", post(handlers::poll::vote_poll))
        // Feedback routes
        .route("/api/feedback", get(handlers::feedback::get_feedback))
        .route("/api/feedback", post(handlers::feedback::create_feedback))
        // User routes
        .route("/api/users/preferences", get(handlers::user::get_user_preferences))
        .route("/api/users/preferences", post(handlers::user::update_user_preferences))
        // Analytics routes
        .route("/api/analytics/stats", get(handlers::analytics::get_statistics))
        .with_state(database)
        .layer(CorsLayer::permissive()); // TODO: Configure CORS properly for production

    // Run our app with hyper
    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    info!("Server listening on http://{}", addr);
    
    let listener = tokio::net::TcpListener::bind(addr).await?;
    axum::serve(listener, app).await?;

    Ok(())
}

async fn root() -> &'static str {
    "TrayTrail Backend API v0.1.0"
}

async fn health_check() -> Json<Value> {
    Json(json!({
        "status": "healthy",
        "service": "traytrail-backend",
        "version": "0.1.0",
        "timestamp": chrono::Utc::now().to_rfc3339()
    }))
}
