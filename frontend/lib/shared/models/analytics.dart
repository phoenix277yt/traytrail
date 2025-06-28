/// Model for user feedback
class UserFeedback {
  final String id;
  final String menuItemId;
  final String menuItemName;
  final String feedback;
  final int rating; // 1-5 stars
  final DateTime createdAt;
  final String userId;

  const UserFeedback({
    required this.id,
    required this.menuItemId,
    required this.menuItemName,
    required this.feedback,
    required this.rating,
    required this.createdAt,
    required this.userId,
  });

  UserFeedback copyWith({
    String? id,
    String? menuItemId,
    String? menuItemName,
    String? feedback,
    int? rating,
    DateTime? createdAt,
    String? userId,
  }) {
    return UserFeedback(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      menuItemName: menuItemName ?? this.menuItemName,
      feedback: feedback ?? this.feedback,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }

  bool get isPositive => rating >= 4;
  bool get isNegative => rating <= 2;
  bool get isNeutral => rating == 3;

  @override
  String toString() {
    return 'UserFeedback(id: $id, menuItemName: $menuItemName, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserFeedback && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Model for analytics data
class AnalyticsData {
  final int expectedBreakfast;
  final int expectedLunch;
  final double averageRating;
  final int totalVotes;
  final int participationPercentage;
  final int daysActive;
  final List<String> popularItems;
  final List<UserFeedback> recentFeedback;

  const AnalyticsData({
    required this.expectedBreakfast,
    required this.expectedLunch,
    required this.averageRating,
    required this.totalVotes,
    required this.participationPercentage,
    required this.daysActive,
    required this.popularItems,
    required this.recentFeedback,
  });

  AnalyticsData copyWith({
    int? expectedBreakfast,
    int? expectedLunch,
    double? averageRating,
    int? totalVotes,
    int? participationPercentage,
    int? daysActive,
    List<String>? popularItems,
    List<UserFeedback>? recentFeedback,
  }) {
    return AnalyticsData(
      expectedBreakfast: expectedBreakfast ?? this.expectedBreakfast,
      expectedLunch: expectedLunch ?? this.expectedLunch,
      averageRating: averageRating ?? this.averageRating,
      totalVotes: totalVotes ?? this.totalVotes,
      participationPercentage: participationPercentage ?? this.participationPercentage,
      daysActive: daysActive ?? this.daysActive,
      popularItems: popularItems ?? this.popularItems,
      recentFeedback: recentFeedback ?? this.recentFeedback,
    );
  }

  @override
  String toString() {
    return 'AnalyticsData(expectedBreakfast: $expectedBreakfast, expectedLunch: $expectedLunch, averageRating: $averageRating)';
  }
}
