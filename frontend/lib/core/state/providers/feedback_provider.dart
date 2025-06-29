import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/feedback_state.dart';
import '../persistence/state_persistence.dart';

class FeedbackStateNotifier extends StateNotifier<FeedbackState> {
  FeedbackStateNotifier() : super(const FeedbackState()) {
    _loadState();
  }

  Future<void> _loadState() async {
    final savedState = await StatePersistence.loadFeedbackState();
    if (savedState != null) {
      state = savedState;
    }
  }

  Future<void> _saveState() async {
    await StatePersistence.saveFeedbackState(state);
  }

  Future<void> addFeedbackEntry(FeedbackEntry entry) async {
    state = state.copyWith(
      entries: [...state.entries, entry],
      lastUpdated: DateTime.now(),
    );
    await _saveState();
  }

  Future<void> updateFeedbackEntry(String id, FeedbackEntry updatedEntry) async {
    final updatedEntries = state.entries
        .map((entry) => entry.id == id ? updatedEntry : entry)
        .toList();
    
    state = state.copyWith(
      entries: updatedEntries,
      lastUpdated: DateTime.now(),
    );
    await _saveState();
  }

  Future<void> deleteFeedbackEntry(String id) async {
    final updatedEntries = state.entries
        .where((entry) => entry.id != id)
        .toList();
    
    state = state.copyWith(
      entries: updatedEntries,
      lastUpdated: DateTime.now(),
    );
    await _saveState();
  }

  Future<void> updateFeedbackStatus(String id, FeedbackStatus status) async {
    final updatedEntries = state.entries
        .map((entry) => entry.id == id ? entry.copyWith(status: status) : entry)
        .toList();
    
    state = state.copyWith(
      entries: updatedEntries,
      lastUpdated: DateTime.now(),
    );
    await _saveState();
  }

  Future<void> setSelectedCategory(String category) async {
    state = state.copyWith(selectedCategory: category);
    await _saveState();
  }

  Future<void> updateFormState(FeedbackFormState formState) async {
    state = state.copyWith(formState: formState);
    // Don't save form state to persistence immediately
  }

  Future<void> setLoading(bool isLoading) async {
    state = state.copyWith(isLoading: isLoading);
  }

  Future<void> setError(String? errorMessage) async {
    state = state.copyWith(errorMessage: errorMessage);
  }

  Future<void> clearAllFeedback() async {
    state = state.copyWith(
      entries: [],
      lastUpdated: DateTime.now(),
    );
    await _saveState();
  }

  Future<void> likeFeedback(String id, String userId) async {
    final updatedEntries = state.entries.map((entry) {
      if (entry.id == id) {
        final likedBy = [...entry.likedBy];
        if (likedBy.contains(userId)) {
          likedBy.remove(userId);
        } else {
          likedBy.add(userId);
        }
        return entry.copyWith(
          likes: likedBy.length,
          likedBy: likedBy,
        );
      }
      return entry;
    }).toList();
    
    state = state.copyWith(
      entries: updatedEntries,
      lastUpdated: DateTime.now(),
    );
    await _saveState();
  }

  Future<void> addReplyToFeedback(String feedbackId, FeedbackReply reply) async {
    final updatedEntries = state.entries.map((entry) {
      if (entry.id == feedbackId) {
        return entry.copyWith(
          replies: [...entry.replies, reply],
        );
      }
      return entry;
    }).toList();
    
    state = state.copyWith(
      entries: updatedEntries,
      lastUpdated: DateTime.now(),
    );
    await _saveState();
  }
}

// Main provider
final feedbackStateProvider = StateNotifierProvider<FeedbackStateNotifier, FeedbackState>((ref) {
  return FeedbackStateNotifier();
});

// Computed providers for common queries
final filteredFeedbackProvider = Provider<List<FeedbackEntry>>((ref) {
  final state = ref.watch(feedbackStateProvider);
  return state.filteredEntries;
});

final pendingFeedbackProvider = Provider<List<FeedbackEntry>>((ref) {
  final entries = ref.watch(feedbackStateProvider).entries;
  return entries.where((entry) => entry.status == FeedbackStatus.pending).toList();
});

final resolvedFeedbackProvider = Provider<List<FeedbackEntry>>((ref) {
  final entries = ref.watch(feedbackStateProvider).entries;
  return entries.where((entry) => entry.status == FeedbackStatus.resolved).toList();
});

final averageRatingProvider = Provider<double>((ref) {
  final entries = ref.watch(feedbackStateProvider).entries;
  
  if (entries.isEmpty) return 0.0;
  
  final totalRating = entries
      .map((entry) => entry.rating)
      .reduce((a, b) => a + b);
  
  return totalRating / entries.length;
});

final feedbackByCategoryProvider = Provider<Map<String, List<FeedbackEntry>>>((ref) {
  final entries = ref.watch(feedbackStateProvider).entries;
  final categories = ref.watch(feedbackStateProvider).categories;
  final Map<String, List<FeedbackEntry>> grouped = {};
  
  for (final category in categories) {
    if (category == 'all') {
      grouped[category] = entries;
    } else {
      grouped[category] = entries.where((entry) => entry.category == category).toList();
    }
  }
  
  return grouped;
});

final feedbackStatsProvider = Provider<Map<String, int>>((ref) {
  final state = ref.watch(feedbackStateProvider);
  return state.getStatsSummary();
});

final recentFeedbackProvider = Provider<List<FeedbackEntry>>((ref) {
  final entries = ref.watch(feedbackStateProvider).entries;
  final sortedEntries = [...entries];
  sortedEntries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return sortedEntries.take(10).toList();
});
