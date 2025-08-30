import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// API client configuration and base client
class ApiClient {
  static const String _baseUrl = kDebugMode 
      ? 'http://localhost:3000/api'  // Development
      : 'https://api.traytrail.com/api';  // Production - TODO: Set actual URL

  late final Dio _dio;

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors for logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }

    // Add error handling interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        debugPrint('API Error: ${error.message}');
        debugPrint('API Error Response: ${error.response?.data}');
        handler.next(error);
      },
    ));
  }

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  Dio get dio => _dio;

  /// Check if backend is available
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Health check failed: $e');
      return false;
    }
  }

  /// Handle API responses with error mapping
  Future<T> handleResponse<T>(
    Future<Response> apiCall,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await apiCall;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return fromJson(response.data);
      } else {
        throw ApiException(
          'Request failed with status: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  /// Handle API responses for lists
  Future<List<T>> handleListResponse<T>(
    Future<Response> apiCall,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await apiCall;
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => fromJson(item)).toList();
      } else {
        throw ApiException(
          'Request failed with status: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Request timeout', 408);
      case DioExceptionType.connectionError:
        return ApiException('No internet connection', 0);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final message = e.response?.data?['message'] ?? 'Server error';
        return ApiException(message, statusCode);
      default:
        return ApiException('Network error: ${e.message}');
    }
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException(this.message, [this.statusCode, this.data]);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';

  bool get isNetworkError => statusCode == 0;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isClientError => statusCode != null && statusCode! >= 400 && statusCode! < 500;
}