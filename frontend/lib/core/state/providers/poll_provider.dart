import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/poll_state.dart';
import '../persistence/state_persistence.dart';
import '../../services/food_tags_service.dart';

/// Poll state notifier
class PollNotifier extends StateNotifier<PollState> {
  PollNotifier() : super(const PollState()) {
    _loadPersistedState();
    _initializeMockData();
  }

  /// Load persisted state
  Future<void> _loadPersistedState() async {
    final persistedState = await StatePersistence.loadPollState();
    if (persistedState != null) {
      state = persistedState;
    }
  }

  /// Save state to persistence
  Future<void> _saveState() async {
    await StatePersistence.savePollState(state);
  }

  /// Initialize with mock data for demo
  void _initializeMockData() {
    if (state.polls.isEmpty) {
      final currentPoll = Poll(
        id: 'poll_1',
        title: 'Tomorrow\'s Lunch Preference',
        description: 'Vote for your preferred lunch options for tomorrow',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        endsAt: DateTime.now().add(const Duration(hours: 12)),
        isActive: true,
        totalVotes: 332,
        options: [
          PollOption(
            id: 'option_1',
            name: 'Rajma Chawal',
            description: 'Kidney beans curry with steamed rice',
            votes: 120,
            percentage: 45,
            iconName: 'rice_bowl',
            backgroundColor: '#E3F2FD',
            iconColor: '#1976D2',
            isLeading: true,
            dietaryTags: FoodTagsService.getTagsForFood('Rajma Chawal'),
          ),
          PollOption(
            id: 'option_2',
            name: 'Chole Bhature',
            description: 'Spiced chickpeas with fried bread',
            votes: 89,
            percentage: 32,
            iconName: 'local_dining',
            backgroundColor: '#F3E5F5',
            iconColor: '#7B1FA2',
            dietaryTags: FoodTagsService.getTagsForFood('Chole Bhature'),
          ),
          PollOption(
            id: 'option_3',
            name: 'Dal Tadka & Roti',
            description: 'Lentil curry with Indian flatbread',
            votes: 78,
            percentage: 23,
            iconName: 'breakfast_dining',
            backgroundColor: '#E8F5E8',
            iconColor: '#388E3C',
            dietaryTags: FoodTagsService.getTagsForFood('Dal Tadka & Roti'),
          ),
          PollOption(
            id: 'option_4',
            name: 'Grilled Chicken Salad',
            description: 'Fresh mixed greens with grilled chicken breast',
            votes: 45,
            percentage: 15,
            iconName: 'salad',
            backgroundColor: '#E0F2F1',
            iconColor: '#00695C',
            isLeading: false,
            dietaryTags: FoodTagsService.getTagsForFood('Grilled Chicken Salad'),
          ),
        ],
      );

      state = state.copyWith(
        polls: [currentPoll],
        currentPoll: currentPoll,
        lastUpdated: DateTime.now(),
      );
      _saveState();
    }
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
    _saveState();
  }

  /// Vote for a poll option
  Future<void> voteForOption(String optionId) async {
    if (state.hasVoted || state.currentPoll == null) return;

    setLoading(true);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      final currentPoll = state.currentPoll!;
      final updatedOptions = currentPoll.options.map((option) {
        if (option.id == optionId) {
          final newVotes = option.votes + 1;
          final newTotal = currentPoll.totalVotes + 1;
          final newPercentage = (newVotes / newTotal * 100).round();
          
          return option.copyWith(
            votes: newVotes,
            percentage: newPercentage.toDouble(),
          );
        }
        return option;
      }).toList();

      // Recalculate percentages for all options
      final newTotalVotes = currentPoll.totalVotes + 1;
      final normalizedOptions = updatedOptions.map((option) {
        final newPercentage = (option.votes / newTotalVotes * 100).round();
        return option.copyWith(percentage: newPercentage.toDouble());
      }).toList();

      // Find new leading option
      final maxVotes = normalizedOptions.map((o) => o.votes).reduce((a, b) => a > b ? a : b);
      final finalOptions = normalizedOptions.map((option) {
        return option.copyWith(isLeading: option.votes == maxVotes);
      }).toList();

      final updatedPoll = currentPoll.copyWith(
        options: finalOptions,
        totalVotes: newTotalVotes,
      );

      state = state.copyWith(
        currentPoll: updatedPoll,
        polls: state.polls.map((p) => p.id == updatedPoll.id ? updatedPoll : p).toList(),
        selectedPollOptionId: optionId,
        hasVoted: true,
        lastUpdated: DateTime.now(),
      );

    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to submit vote: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Add breakfast preference
  void addBreakfastPreference(String item) {
    final newPreferences = Set<String>.from(state.selectedBreakfastItems)..add(item);
    state = state.copyWith(selectedBreakfastItems: newPreferences);
    _saveState();
  }

  /// Remove breakfast preference
  void removeBreakfastPreference(String item) {
    final newPreferences = Set<String>.from(state.selectedBreakfastItems)..remove(item);
    state = state.copyWith(selectedBreakfastItems: newPreferences);
    _saveState();
  }

  /// Add lunch preference
  void addLunchPreference(String item) {
    final newPreferences = Set<String>.from(state.selectedLunchItems)..add(item);
    state = state.copyWith(selectedLunchItems: newPreferences);
    _saveState();
  }

  /// Remove lunch preference
  void removeLunchPreference(String item) {
    final newPreferences = Set<String>.from(state.selectedLunchItems)..remove(item);
    state = state.copyWith(selectedLunchItems: newPreferences);
    _saveState();
  }

  /// Clear all preferences
  void clearAllPreferences() {
    state = state.copyWith(
      selectedBreakfastItems: const {},
      selectedLunchItems: const {},
    );
    _saveState();
  }

  /// Submit preferences
  Future<void> submitPreferences() async {
    setLoading(true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Update the submission date to today
      final now = DateTime.now();
      state = state.copyWith(
        lastPreferencesSubmissionDate: now,
        lastUpdated: now,
      );
      
      // For demo, we'll keep the preferences but mark them as submitted
      // In a real app, you might want to clear them after successful submission
      
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to submit preferences: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Refresh polls data
  Future<void> refreshPolls() async {
    setLoading(true);

    try {
      // Simulate API refresh
      await Future.delayed(const Duration(milliseconds: 1000));
      
      state = state.copyWith(
        lastUpdated: DateTime.now(),
        errorMessage: null,
      );

    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to refresh polls: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
    _saveState();
  }

  /// Reset poll state
  void reset() {
    state = const PollState();
    _saveState();
  }
}

/// Provider
final pollProvider = StateNotifierProvider<PollNotifier, PollState>((ref) {
  return PollNotifier();
});

/// Computed providers
final currentPollProvider = Provider<Poll?>((ref) {
  return ref.watch(pollProvider).currentPoll;
});

final hasVotedProvider = Provider<bool>((ref) {
  return ref.watch(pollProvider).hasVoted;
});

final selectedBreakfastItemsProvider = Provider<Set<String>>((ref) {
  return ref.watch(pollProvider).selectedBreakfastItems;
});

final selectedLunchItemsProvider = Provider<Set<String>>((ref) {
  return ref.watch(pollProvider).selectedLunchItems;
});

final totalSelectedPreferencesProvider = Provider<int>((ref) {
  final pollState = ref.watch(pollProvider);
  return pollState.selectedBreakfastItems.length + pollState.selectedLunchItems.length;
});

final isPollLoadingProvider = Provider<bool>((ref) {
  return ref.watch(pollProvider).isLoading;
});

final pollErrorProvider = Provider<String?>((ref) {
  return ref.watch(pollProvider).errorMessage;
});

final canSubmitPreferencesTodayProvider = Provider<bool>((ref) {
  final pollState = ref.watch(pollProvider);
  final lastSubmission = pollState.lastPreferencesSubmissionDate;
  
  // If never submitted, can submit
  if (lastSubmission == null) return true;
  
  // Check if the last submission was on a different day
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final submissionDay = DateTime(lastSubmission.year, lastSubmission.month, lastSubmission.day);
  
  return !today.isAtSameMomentAs(submissionDay);
});

final lastPreferencesSubmissionProvider = Provider<DateTime?>((ref) {
  return ref.watch(pollProvider).lastPreferencesSubmissionDate;
});
