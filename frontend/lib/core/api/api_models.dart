/// API models that mirror the backend response structures
/// These are separate from state models to allow for API evolution

/// Menu API Models
class ApiMenuItem {
  final String id;
  final String name;
  final String? description;
  final String category;
  final int calories;
  final double price;
  final bool isAvailable;
  final String iconName;
  final String backgroundColor;
  final String iconColor;
  final List<String> tags;
  final double rating;
  final int reviewCount;

  const ApiMenuItem({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    required this.calories,
    required this.price,
    required this.isAvailable,
    required this.iconName,
    required this.backgroundColor,
    required this.iconColor,
    required this.tags,
    required this.rating,
    required this.reviewCount,
  });

  factory ApiMenuItem.fromJson(Map<String, dynamic> json) {
    return ApiMenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      calories: json['calories'],
      price: json['price'].toDouble(),
      isAvailable: json['is_available'],
      iconName: json['icon_name'],
      backgroundColor: json['background_color'],
      iconColor: json['icon_color'],
      tags: List<String>.from(json['tags'] ?? []),
      rating: json['rating'].toDouble(),
      reviewCount: json['review_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'calories': calories,
      'price': price,
      'is_available': isAvailable,
      'icon_name': iconName,
      'background_color': backgroundColor,
      'icon_color': iconColor,
      'tags': tags,
      'rating': rating,
      'review_count': reviewCount,
    };
  }
}

class ApiDailyMenu {
  final String id;
  final String date;
  final List<ApiMenuItem> breakfastItems;
  final List<ApiMenuItem> lunchItems;
  final List<ApiMenuItem> dinnerItems;
  final List<ApiMenuItem> snackItems;
  final bool isPublished;
  final String? specialNote;

  const ApiDailyMenu({
    required this.id,
    required this.date,
    required this.breakfastItems,
    required this.lunchItems,
    required this.dinnerItems,
    required this.snackItems,
    required this.isPublished,
    this.specialNote,
  });

  factory ApiDailyMenu.fromJson(Map<String, dynamic> json) {
    return ApiDailyMenu(
      id: json['id'],
      date: json['date'],
      breakfastItems: (json['breakfast_items'] as List)
          .map((item) => ApiMenuItem.fromJson(item))
          .toList(),
      lunchItems: (json['lunch_items'] as List)
          .map((item) => ApiMenuItem.fromJson(item))
          .toList(),
      dinnerItems: (json['dinner_items'] as List)
          .map((item) => ApiMenuItem.fromJson(item))
          .toList(),
      snackItems: (json['snack_items'] as List)
          .map((item) => ApiMenuItem.fromJson(item))
          .toList(),
      isPublished: json['is_published'],
      specialNote: json['special_note'],
    );
  }
}

/// Poll API Models
class ApiPollOption {
  final String id;
  final String pollId;
  final String name;
  final String? description;
  final int votes;
  final double percentage;
  final String iconName;
  final String backgroundColor;
  final String iconColor;
  final bool isLeading;
  final List<String> dietaryTags;
  final int displayOrder;
  final bool isActive;

  const ApiPollOption({
    required this.id,
    required this.pollId,
    required this.name,
    this.description,
    required this.votes,
    required this.percentage,
    required this.iconName,
    required this.backgroundColor,
    required this.iconColor,
    required this.isLeading,
    required this.dietaryTags,
    required this.displayOrder,
    required this.isActive,
  });

  factory ApiPollOption.fromJson(Map<String, dynamic> json) {
    return ApiPollOption(
      id: json['id'],
      pollId: json['poll_id'],
      name: json['name'],
      description: json['description'],
      votes: json['votes'],
      percentage: json['percentage'].toDouble(),
      iconName: json['icon_name'],
      backgroundColor: json['background_color'],
      iconColor: json['icon_color'],
      isLeading: json['is_leading'],
      dietaryTags: List<String>.from(json['dietary_tags'] ?? []),
      displayOrder: json['display_order'],
      isActive: json['is_active'],
    );
  }
}

class ApiPoll {
  final String id;
  final String title;
  final String? description;
  final List<ApiPollOption> options;
  final DateTime createdAt;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final bool isActive;
  final bool isPublished;
  final int totalVotes;
  final String? createdBy;
  final Map<String, dynamic> metadata;

  const ApiPoll({
    required this.id,
    required this.title,
    this.description,
    required this.options,
    required this.createdAt,
    this.startsAt,
    this.endsAt,
    required this.isActive,
    required this.isPublished,
    required this.totalVotes,
    this.createdBy,
    required this.metadata,
  });

  factory ApiPoll.fromJson(Map<String, dynamic> json) {
    return ApiPoll(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      options: (json['options'] as List)
          .map((option) => ApiPollOption.fromJson(option))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      startsAt: json['starts_at'] != null 
          ? DateTime.parse(json['starts_at']) 
          : null,
      endsAt: json['ends_at'] != null 
          ? DateTime.parse(json['ends_at']) 
          : null,
      isActive: json['is_active'],
      isPublished: json['is_published'],
      totalVotes: json['total_votes'],
      createdBy: json['created_by'],
      metadata: json['metadata'] ?? {},
    );
  }
}

/// Feedback API Models
class ApiFeedbackEntry {
  final String id;
  final String title;
  final String content;
  final String category;
  final int rating;
  final String? author;
  final bool isAnonymous;
  final String status;
  final String? response;
  final DateTime? respondedAt;
  final int likes;
  final List<String> likedBy;
  final List<ApiFeedbackReply> replies;
  final DateTime createdAt;

  const ApiFeedbackEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.rating,
    this.author,
    required this.isAnonymous,
    required this.status,
    this.response,
    this.respondedAt,
    required this.likes,
    required this.likedBy,
    required this.replies,
    required this.createdAt,
  });

  factory ApiFeedbackEntry.fromJson(Map<String, dynamic> json) {
    return ApiFeedbackEntry(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      rating: json['rating'],
      author: json['author'],
      isAnonymous: json['is_anonymous'],
      status: json['status'],
      response: json['response'],
      respondedAt: json['responded_at'] != null 
          ? DateTime.parse(json['responded_at']) 
          : null,
      likes: json['likes'],
      likedBy: List<String>.from(json['liked_by'] ?? []),
      replies: (json['replies'] as List)
          .map((reply) => ApiFeedbackReply.fromJson(reply))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ApiFeedbackReply {
  final String id;
  final String? author;
  final String content;
  final bool isStaffReply;
  final DateTime createdAt;

  const ApiFeedbackReply({
    required this.id,
    this.author,
    required this.content,
    required this.isStaffReply,
    required this.createdAt,
  });

  factory ApiFeedbackReply.fromJson(Map<String, dynamic> json) {
    return ApiFeedbackReply(
      id: json['id'],
      author: json['author'],
      content: json['content'],
      isStaffReply: json['is_staff_reply'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

/// User API Models
class ApiUserPreferences {
  final String userId;
  final String username;
  final String email;
  final ApiThemePreferences theme;
  final ApiNotificationPreferences notifications;
  final ApiAccessibilityPreferences accessibility;
  final ApiFoodPreferences food;
  final DateTime lastUpdated;
  final bool isFirstTime;

  const ApiUserPreferences({
    required this.userId,
    required this.username,
    required this.email,
    required this.theme,
    required this.notifications,
    required this.accessibility,
    required this.food,
    required this.lastUpdated,
    required this.isFirstTime,
  });

  factory ApiUserPreferences.fromJson(Map<String, dynamic> json) {
    return ApiUserPreferences(
      userId: json['user_id'],
      username: json['username'],
      email: json['email'],
      theme: ApiThemePreferences.fromJson(json['theme']),
      notifications: ApiNotificationPreferences.fromJson(json['notifications']),
      accessibility: ApiAccessibilityPreferences.fromJson(json['accessibility']),
      food: ApiFoodPreferences.fromJson(json['food']),
      lastUpdated: DateTime.parse(json['last_updated']),
      isFirstTime: json['is_first_time'],
    );
  }
}

class ApiThemePreferences {
  final bool isDarkMode;
  final String primaryColor;
  final String accentColor;
  final double textScale;
  final bool useSystemTheme;

  const ApiThemePreferences({
    required this.isDarkMode,
    required this.primaryColor,
    required this.accentColor,
    required this.textScale,
    required this.useSystemTheme,
  });

  factory ApiThemePreferences.fromJson(Map<String, dynamic> json) {
    return ApiThemePreferences(
      isDarkMode: json['is_dark_mode'],
      primaryColor: json['primary_color'],
      accentColor: json['accent_color'],
      textScale: json['text_scale'].toDouble(),
      useSystemTheme: json['use_system_theme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_dark_mode': isDarkMode,
      'primary_color': primaryColor,
      'accent_color': accentColor,
      'text_scale': textScale,
      'use_system_theme': useSystemTheme,
    };
  }
}

class ApiNotificationPreferences {
  final bool enabled;
  final bool menuUpdates;
  final bool pollNotifications;
  final bool feedbackResponses;
  final bool promotions;
  final String quietHoursStart;
  final String quietHoursEnd;

  const ApiNotificationPreferences({
    required this.enabled,
    required this.menuUpdates,
    required this.pollNotifications,
    required this.feedbackResponses,
    required this.promotions,
    required this.quietHoursStart,
    required this.quietHoursEnd,
  });

  factory ApiNotificationPreferences.fromJson(Map<String, dynamic> json) {
    return ApiNotificationPreferences(
      enabled: json['enabled'],
      menuUpdates: json['menu_updates'],
      pollNotifications: json['poll_notifications'],
      feedbackResponses: json['feedback_responses'],
      promotions: json['promotions'],
      quietHoursStart: json['quiet_hours_start'],
      quietHoursEnd: json['quiet_hours_end'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'menu_updates': menuUpdates,
      'poll_notifications': pollNotifications,
      'feedback_responses': feedbackResponses,
      'promotions': promotions,
      'quiet_hours_start': quietHoursStart,
      'quiet_hours_end': quietHoursEnd,
    };
  }
}

class ApiAccessibilityPreferences {
  final bool enableHapticFeedback;
  final bool enableSoundEffects;
  final bool reduceAnimations;
  final bool highContrast;
  final double animationSpeed;
  final bool screenReader;

  const ApiAccessibilityPreferences({
    required this.enableHapticFeedback,
    required this.enableSoundEffects,
    required this.reduceAnimations,
    required this.highContrast,
    required this.animationSpeed,
    required this.screenReader,
  });

  factory ApiAccessibilityPreferences.fromJson(Map<String, dynamic> json) {
    return ApiAccessibilityPreferences(
      enableHapticFeedback: json['enable_haptic_feedback'],
      enableSoundEffects: json['enable_sound_effects'],
      reduceAnimations: json['reduce_animations'],
      highContrast: json['high_contrast'],
      animationSpeed: json['animation_speed'].toDouble(),
      screenReader: json['screen_reader'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enable_haptic_feedback': enableHapticFeedback,
      'enable_sound_effects': enableSoundEffects,
      'reduce_animations': reduceAnimations,
      'high_contrast': highContrast,
      'animation_speed': animationSpeed,
      'screen_reader': screenReader,
    };
  }
}

class ApiFoodPreferences {
  final List<String> dislikedFoods;
  final List<String> favoriteCategories;
  final int spicePreference;

  const ApiFoodPreferences({
    required this.dislikedFoods,
    required this.favoriteCategories,
    required this.spicePreference,
  });

  factory ApiFoodPreferences.fromJson(Map<String, dynamic> json) {
    return ApiFoodPreferences(
      dislikedFoods: List<String>.from(json['disliked_foods'] ?? []),
      favoriteCategories: List<String>.from(json['favorite_categories'] ?? []),
      spicePreference: json['spice_preference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disliked_foods': dislikedFoods,
      'favorite_categories': favoriteCategories,
      'spice_preference': spicePreference,
    };
  }
}