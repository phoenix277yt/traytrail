/// Application configuration
class AppConfig {
  // Environment Configuration
  static const bool isProduction = false;
  static const bool enableDebugMode = true;
  static const bool enableAnalytics = false;
  
  // API Configuration
  static const String baseUrl = 'https://api.traytrail.com';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enablePushNotifications = true;
  static const bool enableBiometricAuth = false;
  static const bool enableDarkMode = false; // Currently disabled
  
  // UI Configuration
  static const bool enableAnimations = true;
  static const bool enableHapticFeedback = true;
  static const double animationSpeedMultiplier = 1.0;
  
  // Cache Configuration
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
  
  // Polling Configuration
  static const Duration pollRefreshInterval = Duration(minutes: 5);
  static const Duration menuRefreshInterval = Duration(hours: 1);
  
  // Validation Configuration
  static const int maxFeedbackLength = 500;
  static const int minRating = 1;
  static const int maxRating = 5;
  
  // Asset Paths (relative to assets folder)
  static const String iconPath = 'images/icons/';
  static const String logoPath = 'images/logo.svg';
  static const String fontPath = 'fonts/';
  
  // Development helpers
  static String get fullApiUrl => '$baseUrl/$apiVersion';
  static bool get isDebugMode => !isProduction && enableDebugMode;
  
  // Environment-specific configurations
  static Map<String, dynamic> get databaseConfig => {
    'name': isProduction ? 'traytrail_prod' : 'traytrail_dev',
    'version': 1,
  };
}

/// Environment-specific configurations
enum Environment {
  development,
  staging,
  production;
  
  bool get isDevelopment => this == Environment.development;
  bool get isStaging => this == Environment.staging;
  bool get isProduction => this == Environment.production;
}
