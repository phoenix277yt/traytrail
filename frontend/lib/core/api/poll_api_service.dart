import 'api_client.dart';
import 'api_models.dart';

/// Poll API service for backend integration
class PollApiService {
  final ApiClient _client = ApiClient();

  /// Get all active polls
  Future<List<ApiPoll>> getActivePolls() async {
    return _client.handleListResponse(
      _client.dio.get('/polls'),
      ApiPoll.fromJson,
    );
  }

  /// Get a specific poll by ID
  Future<ApiPoll> getPollById(String pollId) async {
    return _client.handleResponse(
      _client.dio.get('/polls/$pollId'),
      ApiPoll.fromJson,
    );
  }

  /// Create a new poll
  Future<ApiPoll> createPoll(Map<String, dynamic> data) async {
    return _client.handleResponse(
      _client.dio.post('/polls', data: data),
      ApiPoll.fromJson,
    );
  }

  /// Vote on a poll
  Future<Map<String, dynamic>> votePoll({
    required String pollId,
    required String optionId,
    String? userId,
    String? ipAddress,
    Map<String, dynamic>? metadata,
  }) async {
    return _client.handleResponse(
      _client.dio.post('/polls/$pollId/vote', data: {
        'option_id': optionId,
        if (userId != null) 'user_id': userId,
        if (ipAddress != null) 'ip_address': ipAddress,
        if (metadata != null) 'metadata': metadata,
      }),
      (json) => json,
    );
  }

  /// Get poll statistics
  Future<Map<String, dynamic>> getPollStatistics(String pollId) async {
    return _client.handleResponse(
      _client.dio.get('/polls/$pollId/statistics'),
      (json) => json,
    );
  }
}