import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Application configuration and settings
class AppConfig {
  AppConfig._();

  // Environment settings
  static const bool isDebugMode = true;
  static const bool enableLogging = true;

  // API Configuration (for future use)
  static const String baseUrl = 'https://api.traytrail.com';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Feature flags
  static const bool enablePolls = true;
  static const bool enableFeedback = true;
  static const bool enableOrderHistory = true;
  static const bool enableNotifications = false;

  // Cache settings
  static const Duration cacheExpiry = Duration(hours: 1);
  static const int maxCacheSize = 100; // Number of items

  // UI Configuration
  static const bool enableAnimations = true;
  static const bool enableHapticFeedback = true;
  static const bool enableDarkMode = false;

  // Pagination settings
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File upload settings
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];

  // Security settings
  static const Duration sessionTimeout = Duration(hours: 24);
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);

  // Analytics and tracking
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;

  // Accessibility
  static const bool enableHighContrast = false;
  static const double minimumTouchTargetSize = 44.0;

  // Local storage keys
  static const String userPreferencesKey = 'user_preferences';
  static const String authTokenKey = 'auth_token';
  static const String lastSyncKey = 'last_sync';
  static const String selectedLanguageKey = 'selected_language';

  // Supported languages
  static const List<String> supportedLanguages = ['en', 'hi', 'es', 'fr'];
  static const String defaultLanguage = 'en';

  /// Initialize app configuration
  static Future<void> initialize() async {
    // Initialize shared preferences
    // final prefs = await SharedPreferences.getInstance();

    // Initialize Firebase or other services
    // await Firebase.initializeApp();

    // Initialize logging
    if (enableLogging && isDebugMode) {
      _initializeLogging();
    }

    // Initialize crash reporting
    if (enableCrashReporting) {
      // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }

    // Initialize analytics
    if (enableAnalytics) {
      // await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    }

    // Load user preferences
    // await _loadUserPreferences();

    // Set up error handling
    _setupErrorHandling();
  }

  /// Initialize logging
  static void _initializeLogging() {
    // Configure logging based on debug mode
    if (isDebugMode) {
      debugPrint('🚀 TrayTrail App initialized in debug mode');
    }
  }

  /// Setup error handling
  static void _setupErrorHandling() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      if (enableLogging) {
        debugPrint('🔥 Flutter Error: ${details.exception}');
        debugPrint('Stack trace: ${details.stack}');
      }

      // Send to crash reporting service
      if (enableCrashReporting) {
        // FirebaseCrashlytics.instance.recordFlutterError(details);
      }
    };
  }

  // Development settings
  static const bool showPerformanceOverlay = false;
  static const bool showSemanticsDebugger = false;
  static const bool debugShowCheckedModeBanner = false;
}
