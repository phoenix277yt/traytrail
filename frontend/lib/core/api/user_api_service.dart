import 'api_client.dart';
import 'api_models.dart';

/// User API service for backend integration
class UserApiService {
  final ApiClient _client = ApiClient();

  /// Get user preferences
  Future<ApiUserPreferences> getUserPreferences({String? userId}) async {
    return _client.handleResponse(
      _client.dio.get('/users/preferences', queryParameters: {
        if (userId != null) 'user_id': userId,
      }),
      ApiUserPreferences.fromJson,
    );
  }

  /// Update user preferences
  Future<ApiUserPreferences> updateUserPreferences({
    String? userId,
    ApiThemePreferences? theme,
    ApiNotificationPreferences? notifications,
    ApiAccessibilityPreferences? accessibility,
    ApiFoodPreferences? food,
  }) async {
    final data = <String, dynamic>{
      if (userId != null) 'user_id': userId,
      if (theme != null) 'theme': theme.toJson(),
      if (notifications != null) 'notifications': notifications.toJson(),
      if (accessibility != null) 'accessibility': accessibility.toJson(),
      if (food != null) 'food': food.toJson(),
    };

    return _client.handleResponse(
      _client.dio.post('/users/preferences', data: data),
      ApiUserPreferences.fromJson,
    );
  }

  /// Create or register a new user
  Future<Map<String, dynamic>> createUser({
    required String username,
    required String email,
    String? password,
  }) async {
    return _client.handleResponse(
      _client.dio.post('/users', data: {
        'username': username,
        'email': email,
        if (password != null) 'password': password,
      }),
      (json) => json,
    );
  }
}