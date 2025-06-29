/// User preferences and settings state
library;

/// Theme preferences
class ThemePreferences {
  final bool isDarkMode;
  final String primaryColor;
  final String accentColor;
  final double textScale;
  final bool useSystemTheme;

  const ThemePreferences({
    this.isDarkMode = false,
    this.primaryColor = '#F7E1D7', // champagne pink - original brand color
    this.accentColor = '#3AB795', // mint - original brand color
    this.textScale = 1.0,
    this.useSystemTheme = false,
  });

  ThemePreferences copyWith({
    bool? isDarkMode,
    String? primaryColor,
    String? accentColor,
    double? textScale,
    bool? useSystemTheme,
  }) {
    return ThemePreferences(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
      textScale: textScale ?? this.textScale,
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'primaryColor': primaryColor,
      'accentColor': accentColor,
      'textScale': textScale,
      'useSystemTheme': useSystemTheme,
    };
  }

  factory ThemePreferences.fromJson(Map<String, dynamic> json) {
    return ThemePreferences(
      isDarkMode: json['isDarkMode'] ?? false,
      primaryColor: json['primaryColor'] ?? '#FF6B35',
      accentColor: json['accentColor'] ?? '#4ECDC4',
      textScale: json['textScale']?.toDouble() ?? 1.0,
      useSystemTheme: json['useSystemTheme'] ?? true,
    );
  }
}

/// Notification preferences
class NotificationPreferences {
  final bool enabled;
  final bool menuUpdates;
  final bool pollNotifications;
  final bool feedbackResponses;
  final bool promotions;
  final String quietHoursStart; // "22:00"
  final String quietHoursEnd; // "07:00"

  const NotificationPreferences({
    this.enabled = true,
    this.menuUpdates = true,
    this.pollNotifications = true,
    this.feedbackResponses = true,
    this.promotions = false,
    this.quietHoursStart = '22:00',
    this.quietHoursEnd = '07:00',
  });

  NotificationPreferences copyWith({
    bool? enabled,
    bool? menuUpdates,
    bool? pollNotifications,
    bool? feedbackResponses,
    bool? promotions,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) {
    return NotificationPreferences(
      enabled: enabled ?? this.enabled,
      menuUpdates: menuUpdates ?? this.menuUpdates,
      pollNotifications: pollNotifications ?? this.pollNotifications,
      feedbackResponses: feedbackResponses ?? this.feedbackResponses,
      promotions: promotions ?? this.promotions,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'menuUpdates': menuUpdates,
      'pollNotifications': pollNotifications,
      'feedbackResponses': feedbackResponses,
      'promotions': promotions,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
    };
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      enabled: json['enabled'] ?? true,
      menuUpdates: json['menuUpdates'] ?? true,
      pollNotifications: json['pollNotifications'] ?? true,
      feedbackResponses: json['feedbackResponses'] ?? true,
      promotions: json['promotions'] ?? false,
      quietHoursStart: json['quietHoursStart'] ?? '22:00',
      quietHoursEnd: json['quietHoursEnd'] ?? '07:00',
    );
  }
}

/// Accessibility preferences
class AccessibilityPreferences {
  final bool enableHapticFeedback;
  final bool enableSoundEffects;
  final bool reduceAnimations;
  final bool highContrast;
  final double animationSpeed; // 0.5 to 2.0
  final bool screenReader;

  const AccessibilityPreferences({
    this.enableHapticFeedback = true,
    this.enableSoundEffects = true,
    this.reduceAnimations = false,
    this.highContrast = false,
    this.animationSpeed = 1.0,
    this.screenReader = false,
  });

  AccessibilityPreferences copyWith({
    bool? enableHapticFeedback,
    bool? enableSoundEffects,
    bool? reduceAnimations,
    bool? highContrast,
    double? animationSpeed,
    bool? screenReader,
  }) {
    return AccessibilityPreferences(
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      enableSoundEffects: enableSoundEffects ?? this.enableSoundEffects,
      reduceAnimations: reduceAnimations ?? this.reduceAnimations,
      highContrast: highContrast ?? this.highContrast,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      screenReader: screenReader ?? this.screenReader,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enableHapticFeedback': enableHapticFeedback,
      'enableSoundEffects': enableSoundEffects,
      'reduceAnimations': reduceAnimations,
      'highContrast': highContrast,
      'animationSpeed': animationSpeed,
      'screenReader': screenReader,
    };
  }

  factory AccessibilityPreferences.fromJson(Map<String, dynamic> json) {
    return AccessibilityPreferences(
      enableHapticFeedback: json['enableHapticFeedback'] ?? true,
      enableSoundEffects: json['enableSoundEffects'] ?? true,
      reduceAnimations: json['reduceAnimations'] ?? false,
      highContrast: json['highContrast'] ?? false,
      animationSpeed: json['animationSpeed']?.toDouble() ?? 1.0,
      screenReader: json['screenReader'] ?? false,
    );
  }
}

/// Food preferences (simplified - no allergens or dietary restrictions)
class FoodPreferences {
  final List<String> dislikedFoods;
  final List<String> favoriteCategories;
  final int spicePreference; // 0-5 scale

  const FoodPreferences({
    this.dislikedFoods = const [],
    this.favoriteCategories = const [],
    this.spicePreference = 2,
  });

  FoodPreferences copyWith({
    List<String>? dislikedFoods,
    List<String>? favoriteCategories,
    int? spicePreference,
  }) {
    return FoodPreferences(
      dislikedFoods: dislikedFoods ?? this.dislikedFoods,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      spicePreference: spicePreference ?? this.spicePreference,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dislikedFoods': dislikedFoods,
      'favoriteCategories': favoriteCategories,
      'spicePreference': spicePreference,
    };
  }

  factory FoodPreferences.fromJson(Map<String, dynamic> json) {
    return FoodPreferences(
      dislikedFoods: List<String>.from(json['dislikedFoods'] ?? []),
      favoriteCategories: List<String>.from(json['favoriteCategories'] ?? []),
      spicePreference: json['spicePreference'] ?? 2,
    );
  }
}

/// Overall user preferences state
class UserPreferences {
  final String userId;
  final String username;
  final String email;
  final ThemePreferences theme;
  final NotificationPreferences notifications;
  final AccessibilityPreferences accessibility;
  final FoodPreferences food;
  final DateTime lastUpdated;
  final bool isFirstTime;

  UserPreferences({
    this.userId = '',
    this.username = '',
    this.email = '',
    this.theme = const ThemePreferences(),
    this.notifications = const NotificationPreferences(),
    this.accessibility = const AccessibilityPreferences(),
    this.food = const FoodPreferences(),
    DateTime? lastUpdated,
    this.isFirstTime = true,
  }) : lastUpdated = lastUpdated ?? defaultDateTime;

  static final DateTime defaultDateTime = DateTime.fromMillisecondsSinceEpoch(0);

  UserPreferences copyWith({
    String? userId,
    String? username,
    String? email,
    ThemePreferences? theme,
    NotificationPreferences? notifications,
    AccessibilityPreferences? accessibility,
    FoodPreferences? food,
    DateTime? lastUpdated,
    bool? isFirstTime,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      theme: theme ?? this.theme,
      notifications: notifications ?? this.notifications,
      accessibility: accessibility ?? this.accessibility,
      food: food ?? this.food,
      lastUpdated: lastUpdated ?? DateTime.now(),
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'theme': theme.toJson(),
      'notifications': notifications.toJson(),
      'accessibility': accessibility.toJson(),
      'food': food.toJson(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'isFirstTime': isFirstTime,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      theme: json['theme'] != null 
          ? ThemePreferences.fromJson(json['theme'])
          : const ThemePreferences(),
      notifications: json['notifications'] != null 
          ? NotificationPreferences.fromJson(json['notifications'])
          : const NotificationPreferences(),
      accessibility: json['accessibility'] != null 
          ? AccessibilityPreferences.fromJson(json['accessibility'])
          : const AccessibilityPreferences(),
      food: json['food'] != null 
          ? FoodPreferences.fromJson(json['food'])
          : const FoodPreferences(),
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
      isFirstTime: json['isFirstTime'] ?? true,
    );
  }

  factory UserPreferences.defaultPreferences() {
    return UserPreferences(
      lastUpdated: DateTime.now(),
    );
  }
}
