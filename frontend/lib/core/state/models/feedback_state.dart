/// Feedback-related state management models
library;

/// Represents a single feedback entry
class FeedbackEntry {
  final String id;
  final String title;
  final String content;
  final String category; // food_quality, service, suggestions, complaints, facilities
  final int rating; // 1-5 stars
  final String author;
  final bool isAnonymous;
  final DateTime createdAt;
  final FeedbackStatus status;
  final String? response;
  final DateTime? respondedAt;
  final int likes;
  final List<String> likedBy;
  final List<FeedbackReply> replies;

  const FeedbackEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.rating = 0,
    required this.author,
    this.isAnonymous = false,
    required this.createdAt,
    this.status = FeedbackStatus.pending,
    this.response,
    this.respondedAt,
    this.likes = 0,
    this.likedBy = const [],
    this.replies = const [],
  });

  FeedbackEntry copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    int? rating,
    String? author,
    bool? isAnonymous,
    DateTime? createdAt,
    FeedbackStatus? status,
    String? response,
    DateTime? respondedAt,
    int? likes,
    List<String>? likedBy,
    List<FeedbackReply>? replies,
  }) {
    return FeedbackEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      author: author ?? this.author,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      response: response ?? this.response,
      respondedAt: respondedAt ?? this.respondedAt,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      replies: replies ?? this.replies,
    );
  }

  String get displayAuthor => isAnonymous ? 'Anonymous' : author;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'rating': rating,
      'author': author,
      'isAnonymous': isAnonymous,
      'createdAt': createdAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'response': response,
      'respondedAt': respondedAt?.toIso8601String(),
      'likes': likes,
      'likedBy': likedBy,
      'replies': replies.map((r) => r.toJson()).toList(),
    };
  }

  factory FeedbackEntry.fromJson(Map<String, dynamic> json) {
    return FeedbackEntry(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      rating: json['rating'] ?? 0,
      author: json['author'],
      isAnonymous: json['isAnonymous'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      status: FeedbackStatus.values.firstWhere(
        (s) => s.toString().split('.').last == json['status'],
        orElse: () => FeedbackStatus.pending,
      ),
      response: json['response'],
      respondedAt: json['respondedAt'] != null 
          ? DateTime.parse(json['respondedAt']) 
          : null,
      likes: json['likes'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
      replies: (json['replies'] as List?)
          ?.map((r) => FeedbackReply.fromJson(r))
          .toList() ?? [],
    );
  }
}

/// Represents a reply to feedback
class FeedbackReply {
  final String id;
  final String feedbackId;
  final String content;
  final String author;
  final bool isOfficial; // From cafeteria staff
  final DateTime createdAt;

  const FeedbackReply({
    required this.id,
    required this.feedbackId,
    required this.content,
    required this.author,
    this.isOfficial = false,
    required this.createdAt,
  });

  FeedbackReply copyWith({
    String? id,
    String? feedbackId,
    String? content,
    String? author,
    bool? isOfficial,
    DateTime? createdAt,
  }) {
    return FeedbackReply(
      id: id ?? this.id,
      feedbackId: feedbackId ?? this.feedbackId,
      content: content ?? this.content,
      author: author ?? this.author,
      isOfficial: isOfficial ?? this.isOfficial,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'feedbackId': feedbackId,
      'content': content,
      'author': author,
      'isOfficial': isOfficial,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FeedbackReply.fromJson(Map<String, dynamic> json) {
    return FeedbackReply(
      id: json['id'],
      feedbackId: json['feedbackId'],
      content: json['content'],
      author: json['author'],
      isOfficial: json['isOfficial'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

/// Feedback status enum
enum FeedbackStatus {
  pending,
  inProgress,
  resolved,
  closed,
}

extension FeedbackStatusExtension on FeedbackStatus {
  String get displayName {
    switch (this) {
      case FeedbackStatus.pending:
        return 'Pending';
      case FeedbackStatus.inProgress:
        return 'In Progress';
      case FeedbackStatus.resolved:
        return 'Resolved';
      case FeedbackStatus.closed:
        return 'Closed';
    }
  }
}

/// Form state for creating feedback
class FeedbackFormState {
  final String title;
  final String content;
  final String category;
  final int rating;
  final bool isAnonymous;
  final bool isSubmitting;
  final String? errorMessage;

  const FeedbackFormState({
    this.title = '',
    this.content = '',
    this.category = 'food_quality',
    this.rating = 0,
    this.isAnonymous = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  FeedbackFormState copyWith({
    String? title,
    String? content,
    String? category,
    int? rating,
    bool? isAnonymous,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return FeedbackFormState(
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isValid {
    return title.trim().isNotEmpty && 
           content.trim().length >= 10 && 
           rating > 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'rating': rating,
      'isAnonymous': isAnonymous,
      'isSubmitting': isSubmitting,
      'errorMessage': errorMessage,
    };
  }

  factory FeedbackFormState.fromJson(Map<String, dynamic> json) {
    return FeedbackFormState(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? 'food_quality',
      rating: json['rating'] ?? 0,
      isAnonymous: json['isAnonymous'] ?? false,
      isSubmitting: json['isSubmitting'] ?? false,
      errorMessage: json['errorMessage'],
    );
  }
}

/// Overall feedback state
class FeedbackState {
  final List<FeedbackEntry> entries;
  final List<String> categories;
  final String selectedCategory;
  final FeedbackFormState formState;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? lastUpdated;
  final Map<String, int> stats; // category -> count

  const FeedbackState({
    this.entries = const [],
    this.categories = const [
      'all',
      'food_quality',
      'service',
      'suggestions',
      'complaints',
      'facilities'
    ],
    this.selectedCategory = 'all',
    this.formState = const FeedbackFormState(),
    this.isLoading = false,
    this.errorMessage,
    this.lastUpdated,
    this.stats = const {},
  });

  FeedbackState copyWith({
    List<FeedbackEntry>? entries,
    List<String>? categories,
    String? selectedCategory,
    FeedbackFormState? formState,
    bool? isLoading,
    String? errorMessage,
    DateTime? lastUpdated,
    Map<String, int>? stats,
  }) {
    return FeedbackState(
      entries: entries ?? this.entries,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      formState: formState ?? this.formState,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      stats: stats ?? this.stats,
    );
  }

  List<FeedbackEntry> get filteredEntries {
    if (selectedCategory == 'all') return entries;
    return entries.where((e) => e.category == selectedCategory).toList();
  }

  Map<String, int> getStatsSummary() {
    return {
      'total': entries.length,
      'pending': entries.where((e) => e.status == FeedbackStatus.pending).length,
      'resolved': entries.where((e) => e.status == FeedbackStatus.resolved).length,
      'avgRating': entries.isNotEmpty 
          ? (entries.map((e) => e.rating).reduce((a, b) => a + b) / entries.length).round()
          : 0,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'entries': entries.map((e) => e.toJson()).toList(),
      'categories': categories,
      'selectedCategory': selectedCategory,
      'formState': formState.toJson(),
      'isLoading': isLoading,
      'errorMessage': errorMessage,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'stats': stats,
    };
  }

  factory FeedbackState.fromJson(Map<String, dynamic> json) {
    return FeedbackState(
      entries: (json['entries'] as List?)
          ?.map((e) => FeedbackEntry.fromJson(e))
          .toList() ?? [],
      categories: List<String>.from(json['categories'] ?? [
        'all',
        'food_quality',
        'service',
        'suggestions',
        'complaints',
        'facilities'
      ]),
      selectedCategory: json['selectedCategory'] ?? 'all',
      formState: json['formState'] != null 
          ? FeedbackFormState.fromJson(json['formState'])
          : const FeedbackFormState(),
      isLoading: json['isLoading'] ?? false,
      errorMessage: json['errorMessage'],
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated']) 
          : null,
      stats: Map<String, int>.from(json['stats'] ?? {}),
    );
  }
}
