import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_state.dart';
import '../models/poll_state.dart';
import '../models/menu_state.dart';
import '../models/feedback_state.dart';
import '../models/user_preferences.dart';

/// Handles persistence of app state to local storage
class StatePersistence {
  static const String _keyAppState = 'app_state';
  static const String _keyPollState = 'poll_state';
  static const String _keyMenuState = 'menu_state';
  static const String _keyFeedbackState = 'feedback_state';
  static const String _keyUserPreferences = 'user_preferences';

  static SharedPreferences? _prefs;

  /// Initialize shared preferences
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensure preferences are initialized
  static Future<SharedPreferences> get prefs async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  // App State Persistence
  static Future<void> saveAppState(AppState state) async {
    final preferences = await prefs;
    final json = jsonEncode(state.toJson());
    await preferences.setString(_keyAppState, json);
  }

  static Future<AppState?> loadAppState() async {
    try {
      final preferences = await prefs;
      final json = preferences.getString(_keyAppState);
      if (json != null) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return AppState.fromJson(map);
      }
    } catch (e) {
      developer.log('Error loading app state: $e', name: 'StatePersistence');
    }
    return null;
  }

  // Poll State Persistence
  static Future<void> savePollState(PollState state) async {
    final preferences = await prefs;
    final json = jsonEncode(state.toJson());
    await preferences.setString(_keyPollState, json);
  }

  static Future<PollState?> loadPollState() async {
    try {
      final preferences = await prefs;
      final json = preferences.getString(_keyPollState);
      if (json != null) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return PollState.fromJson(map);
      }
    } catch (e) {
      developer.log('Error loading poll state: $e', name: 'StatePersistence');
    }
    return null;
  }

  // Menu State Persistence
  static Future<void> saveMenuState(MenuState state) async {
    final preferences = await prefs;
    final json = jsonEncode(state.toJson());
    await preferences.setString(_keyMenuState, json);
  }

  static Future<MenuState?> loadMenuState() async {
    try {
      final preferences = await prefs;
      final json = preferences.getString(_keyMenuState);
      if (json != null) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return MenuState.fromJson(map);
      }
    } catch (e) {
      developer.log('Error loading menu state: $e', name: 'StatePersistence');
    }
    return null;
  }

  // Feedback State Persistence
  static Future<void> saveFeedbackState(FeedbackState state) async {
    final preferences = await prefs;
    final json = jsonEncode(state.toJson());
    await preferences.setString(_keyFeedbackState, json);
  }

  static Future<FeedbackState?> loadFeedbackState() async {
    try {
      final preferences = await prefs;
      final json = preferences.getString(_keyFeedbackState);
      if (json != null) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return FeedbackState.fromJson(map);
      }
    } catch (e) {
      developer.log('Error loading feedback state: $e', name: 'StatePersistence');
    }
    return null;
  }

  // User Preferences Persistence
  static Future<void> saveUserPreferences(UserPreferences preferences) async {
    final prefs = await StatePersistence.prefs;
    final json = jsonEncode(preferences.toJson());
    await prefs.setString(_keyUserPreferences, json);
  }

  static Future<UserPreferences?> loadUserPreferences() async {
    try {
      final prefs = await StatePersistence.prefs;
      final json = prefs.getString(_keyUserPreferences);
      if (json != null) {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return UserPreferences.fromJson(map);
      }
    } catch (e) {
      developer.log('Error loading user preferences: $e', name: 'StatePersistence');
    }
    return null;
  }

  // Batch Operations
  static Future<void> saveAllState({
    AppState? appState,
    PollState? pollState,
    MenuState? menuState,
    FeedbackState? feedbackState,
    UserPreferences? userPreferences,
  }) async {
    final futures = <Future>[];

    if (appState != null) {
      futures.add(saveAppState(appState));
    }
    if (pollState != null) {
      futures.add(savePollState(pollState));
    }
    if (menuState != null) {
      futures.add(saveMenuState(menuState));
    }
    if (feedbackState != null) {
      futures.add(saveFeedbackState(feedbackState));
    }
    if (userPreferences != null) {
      futures.add(saveUserPreferences(userPreferences));
    }

    await Future.wait(futures);
  }

  static Future<Map<String, dynamic>> loadAllState() async {
    final futures = await Future.wait([
      loadAppState(),
      loadPollState(),
      loadMenuState(),
      loadFeedbackState(),
      loadUserPreferences(),
    ]);

    return {
      'appState': futures[0],
      'pollState': futures[1],
      'menuState': futures[2],
      'feedbackState': futures[3],
      'userPreferences': futures[4],
    };
  }

  // Clear Operations
  static Future<void> clearAppState() async {
    final preferences = await prefs;
    await preferences.remove(_keyAppState);
  }

  static Future<void> clearPollState() async {
    final preferences = await prefs;
    await preferences.remove(_keyPollState);
  }

  static Future<void> clearMenuState() async {
    final preferences = await prefs;
    await preferences.remove(_keyMenuState);
  }

  static Future<void> clearFeedbackState() async {
    final preferences = await prefs;
    await preferences.remove(_keyFeedbackState);
  }

  static Future<void> clearUserPreferences() async {
    final preferences = await prefs;
    await preferences.remove(_keyUserPreferences);
  }

  static Future<void> clearAllState() async {
    final preferences = await prefs;
    await Future.wait([
      preferences.remove(_keyAppState),
      preferences.remove(_keyPollState),
      preferences.remove(_keyMenuState),
      preferences.remove(_keyFeedbackState),
      preferences.remove(_keyUserPreferences),
    ]);
  }

  // Utility Methods
  static Future<bool> hasStoredState() async {
    final preferences = await prefs;
    return preferences.containsKey(_keyAppState) ||
           preferences.containsKey(_keyPollState) ||
           preferences.containsKey(_keyMenuState) ||
           preferences.containsKey(_keyFeedbackState) ||
           preferences.containsKey(_keyUserPreferences);
  }

  static Future<DateTime?> getLastSavedTime(String stateKey) async {
    try {
      final preferences = await prefs;
      final timestamp = preferences.getInt('${stateKey}_timestamp');
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    } catch (e) {
      developer.log('Error getting last saved time for $stateKey: $e', name: 'StatePersistence');
    }
    return null;
  }

  static Future<void> setLastSavedTime(String stateKey) async {
    final preferences = await prefs;
    await preferences.setInt('${stateKey}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  // Migration and Versioning
  static const String _keyVersion = 'state_version';
  static const int currentVersion = 1;

  static Future<int> getStateVersion() async {
    final preferences = await prefs;
    return preferences.getInt(_keyVersion) ?? 0;
  }

  static Future<void> setStateVersion(int version) async {
    final preferences = await prefs;
    await preferences.setInt(_keyVersion, version);
  }

  static Future<bool> needsMigration() async {
    final version = await getStateVersion();
    return version < currentVersion;
  }

  static Future<void> migrateState() async {
    final currentStateVersion = await getStateVersion();
    
    if (currentStateVersion < 1) {
      // Perform migration from version 0 to 1
      // This could involve updating data structures, adding new fields, etc.
      developer.log('Migrating state from version $currentStateVersion to 1', name: 'StatePersistence');
      
      // Example migration logic
      // await _migrateFromV0ToV1();
    }

    await setStateVersion(currentVersion);
  }
}
