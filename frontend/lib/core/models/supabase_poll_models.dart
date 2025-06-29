/// Supabase-optimized poll models with enhanced features
library;

import 'package:flutter/foundation.dart';

/// Supabase-compatible poll option model
@immutable
class SupabasePollOption {
  final String id;
  final String pollId; // Foreign key to poll
  final String name;
  final String description;
  final int votes;
  final double percentage;
  final String iconName;
  final String backgroundColor;
  final String iconColor;
  final bool isLeading;
  final List<String> dietaryTags;
  final int displayOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SupabasePollOption({
    required this.id,
    required this.pollId,
    required this.name,
    required this.description,
    this.votes = 0,
    this.percentage = 0.0,
    this.iconName = 'restaurant',
    this.backgroundColor = '#E3F2FD',
    this.iconColor = '#1976D2',
    this.isLeading = false,
    this.dietaryTags = const [],
    this.displayOrder = 0,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor for Supabase JSON response
  factory SupabasePollOption.fromSupabase(Map<String, dynamic> json) {
    return SupabasePollOption(
      id: json['id'] as String,
      pollId: json['poll_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      votes: json['votes'] as int? ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      iconName: json['icon_name'] as String? ?? 'restaurant',
      backgroundColor: json['background_color'] as String? ?? '#E3F2FD',
      iconColor: json['icon_color'] as String? ?? '#1976D2',
      isLeading: json['is_leading'] as bool? ?? false,
      dietaryTags: List<String>.from(json['dietary_tags'] ?? []),
      displayOrder: json['display_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }

  /// Convert to JSON for Supabase insert/update
  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'poll_id': pollId,
      'name': name,
      'description': description,
      'votes': votes,
      'percentage': percentage,
      'icon_name': iconName,
      'background_color': backgroundColor,
      'icon_color': iconColor,
      'is_leading': isLeading,
      'dietary_tags': dietaryTags,
      'display_order': displayOrder,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SupabasePollOption copyWith({
    String? id,
    String? pollId,
    String? name,
    String? description,
    int? votes,
    double? percentage,
    String? iconName,
    String? backgroundColor,
    String? iconColor,
    bool? isLeading,
    List<String>? dietaryTags,
    int? displayOrder,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupabasePollOption(
      id: id ?? this.id,
      pollId: pollId ?? this.pollId,
      name: name ?? this.name,
      description: description ?? this.description,
      votes: votes ?? this.votes,
      percentage: percentage ?? this.percentage,
      iconName: iconName ?? this.iconName,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconColor: iconColor ?? this.iconColor,
      isLeading: isLeading ?? this.isLeading,
      dietaryTags: dietaryTags ?? this.dietaryTags,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SupabasePollOption && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Supabase-compatible poll model
@immutable
class SupabasePoll {
  final String id;
  final String title;
  final String description;
  final List<SupabasePollOption> options;
  final DateTime createdAt;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final bool isActive;
  final bool isPublished;
  final int totalVotes;
  final String? createdBy; // User ID who created the poll
  final Map<String, dynamic>? metadata; // Additional configuration
  final DateTime? updatedAt;

  const SupabasePoll({
    required this.id,
    required this.title,
    required this.description,
    this.options = const [],
    required this.createdAt,
    this.startsAt,
    this.endsAt,
    this.isActive = true,
    this.isPublished = false,
    this.totalVotes = 0,
    this.createdBy,
    this.metadata,
    this.updatedAt,
  });

  /// Factory constructor for Supabase JSON response
  factory SupabasePoll.fromSupabase(Map<String, dynamic> json) {
    return SupabasePoll(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      options: (json['poll_options'] as List?)
          ?.map((option) => SupabasePollOption.fromSupabase(option))
          .toList() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
      startsAt: json['starts_at'] != null 
          ? DateTime.parse(json['starts_at'] as String) 
          : null,
      endsAt: json['ends_at'] != null 
          ? DateTime.parse(json['ends_at'] as String) 
          : null,
      isActive: json['is_active'] as bool? ?? true,
      isPublished: json['is_published'] as bool? ?? false,
      totalVotes: json['total_votes'] as int? ?? 0,
      createdBy: json['created_by'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }

  /// Convert to JSON for Supabase insert/update
  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'starts_at': startsAt?.toIso8601String(),
      'ends_at': endsAt?.toIso8601String(),
      'is_active': isActive,
      'is_published': isPublished,
      'total_votes': totalVotes,
      'created_by': createdBy,
      'metadata': metadata,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Check if poll is currently active and within time bounds
  bool get isCurrentlyActive {
    if (!isActive || !isPublished) return false;
    
    final now = DateTime.now();
    
    if (startsAt != null && now.isBefore(startsAt!)) return false;
    if (endsAt != null && now.isAfter(endsAt!)) return false;
    
    return true;
  }

  /// Get time remaining for the poll
  Duration get timeRemaining {
    if (endsAt == null) return Duration.zero;
    
    final now = DateTime.now();
    if (now.isAfter(endsAt!)) return Duration.zero;
    
    return endsAt!.difference(now);
  }

  /// Get human-readable time remaining string
  String get timeRemainingString {
    final remaining = timeRemaining;
    
    if (remaining == Duration.zero) return 'Poll ended';
    
    if (remaining.inDays > 0) {
      return '${remaining.inDays} day${remaining.inDays == 1 ? '' : 's'} left';
    } else if (remaining.inHours > 0) {
      return '${remaining.inHours} hour${remaining.inHours == 1 ? '' : 's'} left';
    } else if (remaining.inMinutes > 0) {
      return '${remaining.inMinutes} minute${remaining.inMinutes == 1 ? '' : 's'} left';
    } else {
      return 'Less than a minute left';
    }
  }

  SupabasePoll copyWith({
    String? id,
    String? title,
    String? description,
    List<SupabasePollOption>? options,
    DateTime? createdAt,
    DateTime? startsAt,
    DateTime? endsAt,
    bool? isActive,
    bool? isPublished,
    int? totalVotes,
    String? createdBy,
    Map<String, dynamic>? metadata,
    DateTime? updatedAt,
  }) {
    return SupabasePoll(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      options: options ?? this.options,
      createdAt: createdAt ?? this.createdAt,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      isActive: isActive ?? this.isActive,
      isPublished: isPublished ?? this.isPublished,
      totalVotes: totalVotes ?? this.totalVotes,
      createdBy: createdBy ?? this.createdBy,
      metadata: metadata ?? this.metadata,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SupabasePoll && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// User vote tracking for Supabase
@immutable
class UserVote {
  final String id;
  final String userId;
  final String pollId;
  final String optionId;
  final DateTime createdAt;
  final String? ipAddress;
  final Map<String, dynamic>? metadata;

  const UserVote({
    required this.id,
    required this.userId,
    required this.pollId,
    required this.optionId,
    required this.createdAt,
    this.ipAddress,
    this.metadata,
  });

  factory UserVote.fromSupabase(Map<String, dynamic> json) {
    return UserVote(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      pollId: json['poll_id'] as String,
      optionId: json['option_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      ipAddress: json['ip_address'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'user_id': userId,
      'poll_id': pollId,
      'option_id': optionId,
      'created_at': createdAt.toIso8601String(),
      'ip_address': ipAddress,
      'metadata': metadata,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserVote && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
