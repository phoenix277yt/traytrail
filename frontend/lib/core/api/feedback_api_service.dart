import 'api_client.dart';
import 'api_models.dart';

/// Feedback API service for backend integration
class FeedbackApiService {
  final ApiClient _client = ApiClient();

  /// Get all feedback entries with optional filtering
  Future<List<ApiFeedbackEntry>> getFeedback({
    String? category,
    String? status,
  }) async {
    return _client.handleListResponse(
      _client.dio.get('/feedback', queryParameters: {
        if (category != null) 'category': category,
        if (status != null) 'status': status,
      }),
      ApiFeedbackEntry.fromJson,
    );
  }

  /// Submit new feedback
  Future<ApiFeedbackEntry> submitFeedback({
    required String title,
    required String content,
    required String category,
    int? rating,
    String? author,
    bool? isAnonymous,
  }) async {
    return _client.handleResponse(
      _client.dio.post('/feedback', data: {
        'title': title,
        'content': content,
        'category': category,
        if (rating != null) 'rating': rating,
        if (author != null) 'author': author,
        if (isAnonymous != null) 'is_anonymous': isAnonymous,
      }),
      ApiFeedbackEntry.fromJson,
    );
  }

  /// Get feedback statistics by category
  Future<Map<String, int>> getFeedbackStats() async {
    return _client.handleResponse(
      _client.dio.get('/feedback/stats'),
      (json) => Map<String, int>.from(json),
    );
  }
}