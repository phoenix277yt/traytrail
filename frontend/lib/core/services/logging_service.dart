import 'package:flutter/foundation.dart';

/// Log levels
enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

/// Enhanced logging service for the application
class LoggingService {
  static final LoggingService _instance = LoggingService._internal();
  factory LoggingService() => _instance;
  LoggingService._internal();

  static const String _tag = 'TrayTrail';
  
  /// Log a debug message
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, error, stackTrace);
  }

  /// Log an info message
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, error, stackTrace);
  }

  /// Log a warning message
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.warning, message, error, stackTrace);
  }

  /// Log an error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  /// Log a fatal error message
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.fatal, message, error, stackTrace);
  }

  /// Internal logging method
  static void _log(LogLevel level, String message, [dynamic error, StackTrace? stackTrace]) {
    if (!kDebugMode && level == LogLevel.debug) {
      return; // Skip debug logs in release mode
    }

    final String timestamp = DateTime.now().toIso8601String();
    final String emoji = _getEmojiForLevel(level);
    final String levelName = level.name.toUpperCase();
    
    String logMessage = '$emoji [$_tag] [$levelName] [$timestamp] $message';
    
    if (error != null) {
      logMessage += '\nError: $error';
    }
    
    if (stackTrace != null) {
      logMessage += '\nStack trace:\n$stackTrace';
    }

    // Print to console
    debugPrint(logMessage);
    
    // In production, you might want to send logs to a remote service
    // _sendToRemoteLogging(level, message, error, stackTrace);
  }

  /// Get emoji for log level
  static String _getEmojiForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.fatal:
        return '💀';
    }
  }

  /// Log user actions for analytics
  static void logUserAction(String action, [Map<String, dynamic>? parameters]) {
    info('User Action: $action${parameters != null ? ' - $parameters' : ''}');
    
    // Send to analytics service
    // Analytics.track(action, parameters);
  }

  /// Log navigation events
  static void logNavigation(String from, String to) {
    info('Navigation: $from -> $to');
  }

  /// Log API calls
  static void logApiCall(String method, String endpoint, {
    int? statusCode,
    Duration? duration,
    Map<String, dynamic>? parameters,
  }) {
    String message = 'API Call: $method $endpoint';
    
    if (statusCode != null) {
      message += ' (Status: $statusCode)';
    }
    
    if (duration != null) {
      message += ' (Duration: ${duration.inMilliseconds}ms)';
    }
    
    if (parameters != null && parameters.isNotEmpty) {
      message += ' - Parameters: $parameters';
    }

    if (statusCode != null && statusCode >= 400) {
      error(message);
    } else {
      info(message);
    }
  }

  /// Log performance metrics
  static void logPerformance(String operation, Duration duration, [Map<String, dynamic>? metadata]) {
    String message = 'Performance: $operation took ${duration.inMilliseconds}ms';
    
    if (metadata != null && metadata.isNotEmpty) {
      message += ' - $metadata';
    }

    if (duration.inMilliseconds > 1000) {
      warning(message);
    } else {
      info(message);
    }
  }
}
