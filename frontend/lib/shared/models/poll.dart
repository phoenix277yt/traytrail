/// Model for poll options
class PollOption {
  final String id;
  final String name;
  final String description;
  final int votes;
  final bool isSelected;
  final String iconName;

  const PollOption({
    required this.id,
    required this.name,
    required this.description,
    required this.votes,
    required this.isSelected,
    required this.iconName,
  });

  PollOption copyWith({
    String? id,
    String? name,
    String? description,
    int? votes,
    bool? isSelected,
    String? iconName,
  }) {
    return PollOption(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      votes: votes ?? this.votes,
      isSelected: isSelected ?? this.isSelected,
      iconName: iconName ?? this.iconName,
    );
  }

  int get percentage {
    // This would normally be calculated based on total votes
    // For now, returning a mock percentage
    return (votes / 100 * 100).round();
  }

  @override
  String toString() {
    return 'PollOption(id: $id, name: $name, votes: $votes, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PollOption && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Model for polls
class Poll {
  final String id;
  final String title;
  final String description;
  final List<PollOption> options;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final int totalVotes;

  const Poll({
    required this.id,
    required this.title,
    required this.description,
    required this.options,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.totalVotes,
  });

  Poll copyWith({
    String? id,
    String? title,
    String? description,
    List<PollOption>? options,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    int? totalVotes,
  }) {
    return Poll(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      options: options ?? this.options,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      totalVotes: totalVotes ?? this.totalVotes,
    );
  }

  Duration get timeRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) {
      return Duration.zero;
    }
    return endDate.difference(now);
  }

  String get timeRemainingString {
    final remaining = timeRemaining;
    if (remaining.inDays > 0) {
      return '${remaining.inDays} days left';
    } else if (remaining.inHours > 0) {
      return '${remaining.inHours} hours left';
    } else if (remaining.inMinutes > 0) {
      return '${remaining.inMinutes} minutes left';
    } else {
      return 'Poll ended';
    }
  }

  @override
  String toString() {
    return 'Poll(id: $id, title: $title, isActive: $isActive, totalVotes: $totalVotes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Poll && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
