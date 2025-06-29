import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_state.dart';
import '../persistence/state_persistence.dart';

/// Global app state provider
class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState()) {
    _loadPersistedState();
  }

  /// Load persisted state on initialization
  Future<void> _loadPersistedState() async {
    final persistedState = await StatePersistence.loadAppState();
    if (persistedState != null) {
      state = persistedState;
    }
  }

  /// Save state to persistence layer
  Future<void> _saveState() async {
    await StatePersistence.saveAppState(state);
  }

  /// Update loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
    _saveState();
  }

  /// Update navigation index
  void setNavigationIndex(int index) {
    state = state.copyWith(selectedNavigationIndex: index);
    _saveState();
  }

  /// Update splash screen visibility
  void setSplashVisible(bool showSplash) {
    state = state.copyWith(showSplash: showSplash);
    _saveState();
  }

  /// Update online status
  void setOnlineStatus(bool isOnline) {
    state = state.copyWith(isOnline: isOnline);
    _saveState();
  }

  /// Set error message
  void setError(String? errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
    _saveState();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
    _saveState();
  }

  /// Toggle dark mode
  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
    _saveState();
  }

  /// Set dark mode
  void setDarkMode(bool isDarkMode) {
    state = state.copyWith(isDarkMode: isDarkMode);
    _saveState();
  }

  /// Toggle animations
  void toggleAnimations() {
    state = state.copyWith(animationsEnabled: !state.animationsEnabled);
    _saveState();
  }

  /// Set animations enabled
  void setAnimationsEnabled(bool enabled) {
    state = state.copyWith(animationsEnabled: enabled);
    _saveState();
  }

  /// Reset to default state
  void reset() {
    state = const AppState();
    _saveState();
  }
}

/// Navigation state provider
class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(const NavigationState());

  /// Navigate to a specific index
  void navigateToIndex(int index) {
    state = state.copyWith(
      currentIndex: index,
      isTransitioning: true,
    );
    
    // Simulate transition completion
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        state = state.copyWith(isTransitioning: false);
      }
    });
  }

  /// Set pending route
  void setPendingRoute(String? route) {
    state = state.copyWith(pendingRoute: route);
  }

  /// Complete transition
  void completeTransition() {
    state = state.copyWith(
      isTransitioning: false,
      pendingRoute: null,
    );
  }
}

/// Providers
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

final navigationStateProvider = StateNotifierProvider<NavigationNotifier, NavigationState>((ref) {
  return NavigationNotifier();
});

/// Computed providers
final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).isLoading;
});

final currentNavigationIndexProvider = Provider<int>((ref) {
  return ref.watch(appStateProvider).selectedNavigationIndex;
});

final showSplashProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).showSplash;
});

final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).isOnline;
});

final errorMessageProvider = Provider<String?>((ref) {
  return ref.watch(appStateProvider).errorMessage;
});

final appDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).isDarkMode;
});

final animationsEnabledProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).animationsEnabled;
});

final isNavigationTransitioningProvider = Provider<bool>((ref) {
  return ref.watch(navigationStateProvider).isTransitioning;
});
