import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_preferences.dart';
import '../persistence/state_persistence.dart';

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  UserPreferencesNotifier() : super(UserPreferences()) {
    _loadState();
  }

  Future<void> _loadState() async {
    final savedState = await StatePersistence.loadUserPreferences();
    if (savedState != null) {
      state = savedState;
    }
  }

  Future<void> _saveState() async {
    await StatePersistence.saveUserPreferences(state);
  }

  // Theme preferences
  Future<void> setPrimaryColor(String color) async {
    state = state.copyWith(
      theme: state.theme.copyWith(primaryColor: color),
    );
    await _saveState();
  }

  Future<void> setAccentColor(String color) async {
    state = state.copyWith(
      theme: state.theme.copyWith(accentColor: color),
    );
    await _saveState();
  }

  Future<void> setTextScale(double scale) async {
    state = state.copyWith(
      theme: state.theme.copyWith(textScale: scale),
    );
    await _saveState();
  }

  // Notification preferences
  Future<void> setNotificationsEnabled(bool enabled) async {
    state = state.copyWith(
      notifications: state.notifications.copyWith(enabled: enabled),
    );
    await _saveState();
  }

  Future<void> setMenuUpdatesEnabled(bool enabled) async {
    state = state.copyWith(
      notifications: state.notifications.copyWith(menuUpdates: enabled),
    );
    await _saveState();
  }

  Future<void> setPollNotificationsEnabled(bool enabled) async {
    state = state.copyWith(
      notifications: state.notifications.copyWith(pollNotifications: enabled),
    );
    await _saveState();
  }

  Future<void> setFeedbackResponsesEnabled(bool enabled) async {
    state = state.copyWith(
      notifications: state.notifications.copyWith(feedbackResponses: enabled),
    );
    await _saveState();
  }

  Future<void> setPromotionsEnabled(bool enabled) async {
    state = state.copyWith(
      notifications: state.notifications.copyWith(promotions: enabled),
    );
    await _saveState();
  }

  Future<void> setQuietHours(String start, String end) async {
    state = state.copyWith(
      notifications: state.notifications.copyWith(
        quietHoursStart: start,
        quietHoursEnd: end,
      ),
    );
    await _saveState();
  }

  // Food preferences
  Future<void> addDislikedFood(String food) async {
    if (!state.food.dislikedFoods.contains(food)) {
      state = state.copyWith(
        food: state.food.copyWith(
          dislikedFoods: [...state.food.dislikedFoods, food],
        ),
      );
      await _saveState();
    }
  }

  Future<void> removeDislikedFood(String food) async {
    state = state.copyWith(
      food: state.food.copyWith(
        dislikedFoods: state.food.dislikedFoods
            .where((f) => f != food)
            .toList(),
      ),
    );
    await _saveState();
  }

  Future<void> addFavoriteCategory(String category) async {
    if (!state.food.favoriteCategories.contains(category)) {
      state = state.copyWith(
        food: state.food.copyWith(
          favoriteCategories: [...state.food.favoriteCategories, category],
        ),
      );
      await _saveState();
    }
  }

  Future<void> removeFavoriteCategory(String category) async {
    state = state.copyWith(
      food: state.food.copyWith(
        favoriteCategories: state.food.favoriteCategories
            .where((c) => c != category)
            .toList(),
      ),
    );
    await _saveState();
  }

  Future<void> setSpicePreference(int level) async {
    state = state.copyWith(
      food: state.food.copyWith(spicePreference: level),
    );
    await _saveState();
  }

  // Accessibility preferences
  Future<void> setHighContrast(bool enabled) async {
    state = state.copyWith(
      accessibility: state.accessibility.copyWith(highContrast: enabled),
    );
    await _saveState();
  }

  Future<void> setLargeText(bool enabled) async {
    state = state.copyWith(
      accessibility: state.accessibility.copyWith(reduceAnimations: enabled),
    );
    await _saveState();
  }

  Future<void> setReduceAnimations(bool enabled) async {
    state = state.copyWith(
      accessibility: state.accessibility.copyWith(reduceAnimations: enabled),
    );
    await _saveState();
  }

  Future<void> setScreenReader(bool enabled) async {
    state = state.copyWith(
      accessibility: state.accessibility.copyWith(screenReader: enabled),
    );
    await _saveState();
  }

  Future<void> setHapticFeedback(bool enabled) async {
    state = state.copyWith(
      accessibility: state.accessibility.copyWith(enableHapticFeedback: enabled),
    );
    await _saveState();
  }

  Future<void> setSoundEffects(bool enabled) async {
    state = state.copyWith(
      accessibility: state.accessibility.copyWith(enableSoundEffects: enabled),
    );
    await _saveState();
  }

  Future<void> setAnimationSpeed(double speed) async {
    state = state.copyWith(
      accessibility: state.accessibility.copyWith(animationSpeed: speed),
    );
    await _saveState();
  }

  // User info
  Future<void> setUserInfo(String userId, String username, String email) async {
    state = state.copyWith(
      userId: userId,
      username: username,
      email: email,
    );
    await _saveState();
  }

  Future<void> setFirstTimeComplete() async {
    state = state.copyWith(isFirstTime: false);
    await _saveState();
  }

  Future<void> resetToDefaults() async {
    state = UserPreferences.defaultPreferences();
    await _saveState();
  }
}

// Main provider
final userPreferencesProvider = StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  return UserPreferencesNotifier();
});

// Computed providers for easier access to specific preferences
final themePreferencesProvider = Provider<ThemePreferences>((ref) {
  return ref.watch(userPreferencesProvider).theme;
});

final notificationPreferencesProvider = Provider<NotificationPreferences>((ref) {
  return ref.watch(userPreferencesProvider).notifications;
});

final foodPreferencesProvider = Provider<FoodPreferences>((ref) {
  return ref.watch(userPreferencesProvider).food;
});

final accessibilityPreferencesProvider = Provider<AccessibilityPreferences>((ref) {
  return ref.watch(userPreferencesProvider).accessibility;
});

final notificationsEnabledProvider = Provider<bool>((ref) {
  return ref.watch(userPreferencesProvider).notifications.enabled;
});

final favoritesCategoriesProvider = Provider<List<String>>((ref) {
  return ref.watch(userPreferencesProvider).food.favoriteCategories;
});

final userInfoProvider = Provider<Map<String, String>>((ref) {
  final prefs = ref.watch(userPreferencesProvider);
  return {
    'userId': prefs.userId,
    'username': prefs.username,
    'email': prefs.email,
  };
});

final isFirstTimeProvider = Provider<bool>((ref) {
  return ref.watch(userPreferencesProvider).isFirstTime;
});
