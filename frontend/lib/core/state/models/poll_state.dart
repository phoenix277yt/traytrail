/// Poll-related state management models
library;

/// Represents a single poll option
class PollOption {
  final String id;
  final String name;
  final String description;
  final int votes;
  final double percentage;
  final String iconName;
  final String backgroundColor;
  final String iconColor;
  final bool isLeading;
  final List<String> dietaryTags; // informational tags like 'vegetarian', 'healthy', 'protein-rich', etc.

  const PollOption({
    required this.id,
    required this.name,
    required this.description,
    this.votes = 0,
    this.percentage = 0.0,
    this.iconName = 'restaurant',
    this.backgroundColor = '#E3F2FD',
    this.iconColor = '#1976D2',
    this.isLeading = false,
    this.dietaryTags = const [],
  });

  PollOption copyWith({
    String? id,
    String? name,
    String? description,
    int? votes,
    double? percentage,
    String? iconName,
    String? backgroundColor,
    String? iconColor,
    bool? isLeading,
    List<String>? dietaryTags,
  }) {
    return PollOption(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      votes: votes ?? this.votes,
      percentage: percentage ?? this.percentage,
      iconName: iconName ?? this.iconName,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconColor: iconColor ?? this.iconColor,
      isLeading: isLeading ?? this.isLeading,
      dietaryTags: dietaryTags ?? this.dietaryTags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'votes': votes,
      'percentage': percentage,
      'iconName': iconName,
      'backgroundColor': backgroundColor,
      'iconColor': iconColor,
      'isLeading': isLeading,
      'dietaryTags': dietaryTags,
    };
  }

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      votes: json['votes'] ?? 0,
      percentage: json['percentage']?.toDouble() ?? 0.0,
      iconName: json['iconName'] ?? 'restaurant',
      backgroundColor: json['backgroundColor'] ?? '#E3F2FD',
      iconColor: json['iconColor'] ?? '#1976D2',
      isLeading: json['isLeading'] ?? false,
      dietaryTags: List<String>.from(json['dietaryTags'] ?? []),
    );
  }
}

/// Represents a complete poll
class Poll {
  final String id;
  final String title;
  final String description;
  final List<PollOption> options;
  final DateTime createdAt;
  final DateTime? endsAt;
  final bool isActive;
  final int totalVotes;

  const Poll({
    required this.id,
    required this.title,
    required this.description,
    this.options = const [],
    required this.createdAt,
    this.endsAt,
    this.isActive = true,
    this.totalVotes = 0,
  });

  Poll copyWith({
    String? id,
    String? title,
    String? description,
    List<PollOption>? options,
    DateTime? createdAt,
    DateTime? endsAt,
    bool? isActive,
    int? totalVotes,
  }) {
    return Poll(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      options: options ?? this.options,
      createdAt: createdAt ?? this.createdAt,
      endsAt: endsAt ?? this.endsAt,
      isActive: isActive ?? this.isActive,
      totalVotes: totalVotes ?? this.totalVotes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'options': options.map((o) => o.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'endsAt': endsAt?.toIso8601String(),
      'isActive': isActive,
      'totalVotes': totalVotes,
    };
  }

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      options: (json['options'] as List?)
          ?.map((o) => PollOption.fromJson(o))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      endsAt: json['endsAt'] != null ? DateTime.parse(json['endsAt']) : null,
      isActive: json['isActive'] ?? true,
      totalVotes: json['totalVotes'] ?? 0,
    );
  }
}

/// Overall polls state
class PollState {
  final List<Poll> polls;
  final Poll? currentPoll;
  final String? selectedPollOptionId;
  final bool hasVoted;
  final Set<String> selectedBreakfastItems;
  final Set<String> selectedLunchItems;
  final DateTime? lastPreferencesSubmissionDate;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? lastUpdated;

  const PollState({
    this.polls = const [],
    this.currentPoll,
    this.selectedPollOptionId,
    this.hasVoted = false,
    this.selectedBreakfastItems = const {},
    this.selectedLunchItems = const {},
    this.lastPreferencesSubmissionDate,
    this.isLoading = false,
    this.errorMessage,
    this.lastUpdated,
  });

  PollState copyWith({
    List<Poll>? polls,
    Poll? currentPoll,
    String? selectedPollOptionId,
    bool? hasVoted,
    Set<String>? selectedBreakfastItems,
    Set<String>? selectedLunchItems,
    DateTime? lastPreferencesSubmissionDate,
    bool? isLoading,
    String? errorMessage,
    DateTime? lastUpdated,
  }) {
    return PollState(
      polls: polls ?? this.polls,
      currentPoll: currentPoll ?? this.currentPoll,
      selectedPollOptionId: selectedPollOptionId ?? this.selectedPollOptionId,
      hasVoted: hasVoted ?? this.hasVoted,
      selectedBreakfastItems: selectedBreakfastItems ?? this.selectedBreakfastItems,
      selectedLunchItems: selectedLunchItems ?? this.selectedLunchItems,
      lastPreferencesSubmissionDate: lastPreferencesSubmissionDate ?? this.lastPreferencesSubmissionDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'polls': polls.map((p) => p.toJson()).toList(),
      'currentPoll': currentPoll?.toJson(),
      'selectedPollOptionId': selectedPollOptionId,
      'hasVoted': hasVoted,
      'selectedBreakfastItems': selectedBreakfastItems.toList(),
      'selectedLunchItems': selectedLunchItems.toList(),
      'lastPreferencesSubmissionDate': lastPreferencesSubmissionDate?.toIso8601String(),
      'isLoading': isLoading,
      'errorMessage': errorMessage,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory PollState.fromJson(Map<String, dynamic> json) {
    return PollState(
      polls: (json['polls'] as List?)
          ?.map((p) => Poll.fromJson(p))
          .toList() ?? [],
      currentPoll: json['currentPoll'] != null 
          ? Poll.fromJson(json['currentPoll']) 
          : null,
      selectedPollOptionId: json['selectedPollOptionId'],
      hasVoted: json['hasVoted'] ?? false,
      selectedBreakfastItems: Set<String>.from(json['selectedBreakfastItems'] ?? []),
      selectedLunchItems: Set<String>.from(json['selectedLunchItems'] ?? []),
      lastPreferencesSubmissionDate: json['lastPreferencesSubmissionDate'] != null 
          ? DateTime.parse(json['lastPreferencesSubmissionDate']) 
          : null,
      isLoading: json['isLoading'] ?? false,
      errorMessage: json['errorMessage'],
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated']) 
          : null,
    );
  }
}
