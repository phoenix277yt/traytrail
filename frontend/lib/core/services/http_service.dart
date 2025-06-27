import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../services/logging_service.dart';

/// HTTP response wrapper
class ApiResponse<T> {
  final T? data;
  final bool success;
  final String? message;
  final int? statusCode;

  const ApiResponse({
    this.data,
    required this.success,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse(
      data: data,
      success: true,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
}

/// HTTP service for API calls
class HttpService {
  static final HttpService _instance = HttpService._internal();
  factory HttpService() => _instance;
  HttpService._internal();

  late HttpClient _httpClient;
  final String baseUrl = AppConfig.baseUrl;
  final Duration timeout = AppConfig.apiTimeout;

  /// Initialize HTTP service
  void initialize() {
    _httpClient = HttpClient();
    _httpClient.connectionTimeout = timeout;
    _httpClient.idleTimeout = timeout;
    
    // Add certificate validation in production
    if (!kDebugMode) {
      _httpClient.badCertificateCallback = (cert, host, port) => false;
    }
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _performRequest<T>(
      'GET',
      endpoint,
      headers: headers,
      queryParameters: queryParameters,
      fromJson: fromJson,
    );
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _performRequest<T>(
      'POST',
      endpoint,
      headers: headers,
      body: body,
      queryParameters: queryParameters,
      fromJson: fromJson,
    );
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _performRequest<T>(
      'PUT',
      endpoint,
      headers: headers,
      body: body,
      queryParameters: queryParameters,
      fromJson: fromJson,
    );
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _performRequest<T>(
      'DELETE',
      endpoint,
      headers: headers,
      queryParameters: queryParameters,
      fromJson: fromJson,
    );
  }

  /// Perform HTTP request
  Future<ApiResponse<T>> _performRequest<T>(
    String method,
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      // Build URL
      final uri = Uri.parse('$baseUrl/$endpoint');
      final uriWithQuery = queryParameters != null
          ? uri.replace(queryParameters: queryParameters.map((k, v) => MapEntry(k, v.toString())))
          : uri;

      // Create request
      final request = await _httpClient.openUrl(method, uriWithQuery);
      
      // Add headers
      request.headers.set('Content-Type', 'application/json');
      if (headers != null) {
        headers.forEach((key, value) {
          request.headers.set(key, value);
        });
      }

      // Add body for POST/PUT requests
      if (body != null && (method == 'POST' || method == 'PUT')) {
        final bodyBytes = utf8.encode(jsonEncode(body));
        request.contentLength = bodyBytes.length;
        request.add(bodyBytes);
      }

      // Send request
      final response = await request.close();
      stopwatch.stop();

      // Read response
      final responseBody = await response.transform(utf8.decoder).join();
      
      // Log API call
      LoggingService.logApiCall(
        method,
        endpoint,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        parameters: body ?? queryParameters,
      );

      // Handle response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseBody.isEmpty) {
          return ApiResponse<T>.success(null as T, statusCode: response.statusCode);
        }

        final jsonData = jsonDecode(responseBody);
        
        if (fromJson != null && jsonData is Map<String, dynamic>) {
          final data = fromJson(jsonData);
          return ApiResponse.success(data, statusCode: response.statusCode);
        }
        
        return ApiResponse.success(jsonData as T, statusCode: response.statusCode);
      } else {
        String errorMessage = 'Request failed with status ${response.statusCode}';
        try {
          final errorData = jsonDecode(responseBody);
          if (errorData is Map<String, dynamic> && errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          }
        } catch (_) {
          // Use default error message
        }
        
        return ApiResponse.error(errorMessage, statusCode: response.statusCode);
      }
    } catch (e) {
      stopwatch.stop();
      LoggingService.error('HTTP request failed', e);
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  /// Upload file
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    File file, {
    Map<String, String>? headers,
    Map<String, String>? fields,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final request = await _httpClient.postUrl(Uri.parse('$baseUrl/$endpoint'));
      
      // Add headers
      if (headers != null) {
        headers.forEach((key, value) {
          request.headers.set(key, value);
        });
      }

      // Add multipart form data logic here
      // This is a simplified version - you might want to use a package like dio for file uploads
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseBody.isEmpty) {
          return ApiResponse<T>.success(null as T);
        }

        final jsonData = jsonDecode(responseBody);
        if (fromJson != null && jsonData is Map<String, dynamic>) {
          final data = fromJson(jsonData);
          return ApiResponse.success(data);
        }
        
        return ApiResponse.success(jsonData as T);
      } else {
        return ApiResponse.error('Upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      LoggingService.error('File upload failed', e);
      return ApiResponse.error('Upload error: ${e.toString()}');
    }
  }

  /// Dispose resources
  void dispose() {
    _httpClient.close();
  }
}
