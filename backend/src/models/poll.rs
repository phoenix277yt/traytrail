use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc};
use sqlx::FromRow;

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct Poll {
    pub id: String,
    pub title: String,
    pub description: Option<String>,
    pub created_at: DateTime<Utc>,
    pub starts_at: Option<DateTime<Utc>>,
    pub ends_at: Option<DateTime<Utc>>,
    pub is_active: bool,
    pub is_published: bool,
    pub total_votes: i32,
    pub created_by: Option<String>,
    pub metadata: String, // JSON object as string
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct PollOption {
    pub id: String,
    pub poll_id: String,
    pub name: String,
    pub description: Option<String>,
    pub votes: i32,
    pub percentage: f64,
    pub icon_name: String,
    pub background_color: String,
    pub icon_color: String,
    pub is_leading: bool,
    pub dietary_tags: String, // JSON array as string
    pub display_order: i32,
    pub is_active: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PollOptionResponse {
    pub id: String,
    pub poll_id: String,
    pub name: String,
    pub description: Option<String>,
    pub votes: i32,
    pub percentage: f64,
    pub icon_name: String,
    pub background_color: String,
    pub icon_color: String,
    pub is_leading: bool,
    pub dietary_tags: Vec<String>, // Parsed JSON array
    pub display_order: i32,
    pub is_active: bool,
}

impl From<PollOption> for PollOptionResponse {
    fn from(option: PollOption) -> Self {
        let dietary_tags: Vec<String> = serde_json::from_str(&option.dietary_tags).unwrap_or_default();
        Self {
            id: option.id,
            poll_id: option.poll_id,
            name: option.name,
            description: option.description,
            votes: option.votes,
            percentage: option.percentage,
            icon_name: option.icon_name,
            background_color: option.background_color,
            icon_color: option.icon_color,
            is_leading: option.is_leading,
            dietary_tags,
            display_order: option.display_order,
            is_active: option.is_active,
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PollResponse {
    pub id: String,
    pub title: String,
    pub description: Option<String>,
    pub options: Vec<PollOptionResponse>,
    pub created_at: DateTime<Utc>,
    pub starts_at: Option<DateTime<Utc>>,
    pub ends_at: Option<DateTime<Utc>>,
    pub is_active: bool,
    pub is_published: bool,
    pub total_votes: i32,
    pub created_by: Option<String>,
    pub metadata: serde_json::Value, // Parsed JSON object
}

impl PollResponse {
    pub fn from_poll_with_options(poll: Poll, options: Vec<PollOption>) -> Self {
        let metadata: serde_json::Value = serde_json::from_str(&poll.metadata).unwrap_or(serde_json::json!({}));
        Self {
            id: poll.id,
            title: poll.title,
            description: poll.description,
            options: options.into_iter().map(PollOptionResponse::from).collect(),
            created_at: poll.created_at,
            starts_at: poll.starts_at,
            ends_at: poll.ends_at,
            is_active: poll.is_active,
            is_published: poll.is_published,
            total_votes: poll.total_votes,
            created_by: poll.created_by,
            metadata,
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct UserVote {
    pub id: String,
    pub poll_id: String,
    pub option_id: String,
    pub user_id: Option<String>,
    pub ip_address: Option<String>,
    pub metadata: String, // JSON object as string
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CreatePollRequest {
    pub title: String,
    pub description: Option<String>,
    pub starts_at: Option<DateTime<Utc>>,
    pub ends_at: Option<DateTime<Utc>>,
    pub is_published: Option<bool>,
    pub options: Vec<CreatePollOptionRequest>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CreatePollOptionRequest {
    pub name: String,
    pub description: Option<String>,
    pub icon_name: Option<String>,
    pub background_color: Option<String>,
    pub icon_color: Option<String>,
    pub dietary_tags: Option<Vec<String>>,
    pub display_order: Option<i32>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct VotePollRequest {
    pub option_id: String,
    pub user_id: Option<String>,
    pub ip_address: Option<String>,
    pub metadata: Option<serde_json::Value>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PollStatistics {
    pub poll_id: String,
    pub total_votes: i32,
    pub option_votes: Vec<PollOptionVoteCount>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PollOptionVoteCount {
    pub option_id: String,
    pub option_name: String,
    pub votes: i32,
    pub percentage: f64,
}