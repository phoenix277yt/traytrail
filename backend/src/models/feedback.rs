use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc};
use sqlx::FromRow;

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct FeedbackEntry {
    pub id: String,
    pub title: String,
    pub content: String,
    pub category: String, // food_quality, service, suggestions, complaints, facilities
    pub rating: i32, // 1-5 stars
    pub author: Option<String>,
    pub is_anonymous: bool,
    pub status: String, // pending, in_progress, resolved, closed
    pub response: Option<String>,
    pub responded_at: Option<DateTime<Utc>>,
    pub likes: i32,
    pub liked_by: String, // JSON array of user IDs
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FeedbackEntryResponse {
    pub id: String,
    pub title: String,
    pub content: String,
    pub category: String,
    pub rating: i32,
    pub author: Option<String>,
    pub is_anonymous: bool,
    pub status: FeedbackStatus,
    pub response: Option<String>,
    pub responded_at: Option<DateTime<Utc>>,
    pub likes: i32,
    pub liked_by: Vec<String>, // Parsed JSON array
    pub replies: Vec<FeedbackReplyResponse>,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum FeedbackStatus {
    Pending,
    InProgress,
    Resolved,
    Closed,
}

impl From<String> for FeedbackStatus {
    fn from(status: String) -> Self {
        match status.as_str() {
            "in_progress" => FeedbackStatus::InProgress,
            "resolved" => FeedbackStatus::Resolved,
            "closed" => FeedbackStatus::Closed,
            _ => FeedbackStatus::Pending,
        }
    }
}

impl From<FeedbackStatus> for String {
    fn from(status: FeedbackStatus) -> Self {
        match status {
            FeedbackStatus::Pending => "pending".to_string(),
            FeedbackStatus::InProgress => "in_progress".to_string(),
            FeedbackStatus::Resolved => "resolved".to_string(),
            FeedbackStatus::Closed => "closed".to_string(),
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct FeedbackReply {
    pub id: String,
    pub feedback_id: String,
    pub author: Option<String>,
    pub content: String,
    pub is_staff_reply: bool,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FeedbackReplyResponse {
    pub id: String,
    pub author: Option<String>,
    pub content: String,
    pub is_staff_reply: bool,
    pub created_at: DateTime<Utc>,
}

impl From<FeedbackReply> for FeedbackReplyResponse {
    fn from(reply: FeedbackReply) -> Self {
        Self {
            id: reply.id,
            author: reply.author,
            content: reply.content,
            is_staff_reply: reply.is_staff_reply,
            created_at: reply.created_at,
        }
    }
}

impl FeedbackEntryResponse {
    pub fn from_feedback_with_replies(feedback: FeedbackEntry, replies: Vec<FeedbackReply>) -> Self {
        let liked_by: Vec<String> = serde_json::from_str(&feedback.liked_by).unwrap_or_default();
        Self {
            id: feedback.id,
            title: feedback.title,
            content: feedback.content,
            category: feedback.category,
            rating: feedback.rating,
            author: feedback.author,
            is_anonymous: feedback.is_anonymous,
            status: FeedbackStatus::from(feedback.status),
            response: feedback.response,
            responded_at: feedback.responded_at,
            likes: feedback.likes,
            liked_by,
            replies: replies.into_iter().map(FeedbackReplyResponse::from).collect(),
            created_at: feedback.created_at,
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CreateFeedbackRequest {
    pub title: String,
    pub content: String,
    pub category: String,
    pub rating: Option<i32>,
    pub author: Option<String>,
    pub is_anonymous: Option<bool>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CreateFeedbackReplyRequest {
    pub content: String,
    pub author: Option<String>,
    pub is_staff_reply: Option<bool>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FeedbackFormState {
    pub title: String,
    pub content: String,
    pub category: String,
    pub rating: i32,
    pub is_anonymous: bool,
    pub is_submitting: bool,
    pub error_message: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FeedbackState {
    pub entries: Vec<FeedbackEntryResponse>,
    pub categories: Vec<String>,
    pub selected_category: String,
    pub form_state: FeedbackFormState,
    pub is_loading: bool,
    pub error_message: Option<String>,
    pub last_updated: Option<DateTime<Utc>>,
    pub stats: std::collections::HashMap<String, i32>, // category -> count
}