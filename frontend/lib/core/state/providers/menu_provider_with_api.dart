import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../models/menu_state.dart';
import '../persistence/state_persistence.dart';
import '../../api/api.dart';
import '../../constants/app_constants.dart';

/// Enhanced menu provider with backend integration
/// Falls back to local persistence when backend is unavailable
class MenuNotifierWithApi extends StateNotifier<MenuState> {
  final MenuApiService _apiService = MenuApiService();
  final ApiClient _apiClient = ApiClient();
  bool _isBackendAvailable = false;

  MenuNotifierWithApi() : super(const MenuState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    // Load from local persistence first
    await _loadFromLocal();
    
    // Check if backend is available
    _isBackendAvailable = await _apiClient.checkHealth();
    
    if (_isBackendAvailable) {
      // Try to sync with backend
      await _syncWithBackend();
    } else {
      debugPrint('Backend not available, using local data only');
    }
  }

  Future<void> _loadFromLocal() async {
    try {
      final localState = await StatePersistence.loadMenuState();
      if (localState != null) {
        state = localState;
      }
    } catch (e) {
      debugPrint('Error loading local menu state: $e');
    }
  }

  Future<void> _syncWithBackend() async {
    if (!_isBackendAvailable) return;

    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Fetch data from backend
      final menuItems = await _apiService.getMenuItems();
      final todaysMenu = await _apiService.getTodaysMenu();
      final tomorrowsMenu = await _apiService.getTomorrowsMenu();

      // Convert API models to state models
      final convertedTodaysMenu = todaysMenu != null 
          ? _convertApiDailyMenuToStateModel(todaysMenu)
          : null;
      
      final convertedTomorrowsMenu = tomorrowsMenu != null
          ? _convertApiDailyMenuToStateModel(tomorrowsMenu)
          : null;

      // Update state
      state = state.copyWith(
        todaysMenu: convertedTodaysMenu,
        tomorrowsMenu: convertedTomorrowsMenu,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );

      // Persist to local storage
      await StatePersistence.saveMenuState(state);
      
    } catch (e) {
      debugPrint('Error syncing with backend: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to sync with server: ${e.toString()}',
      );
      
      // Backend error doesn't prevent using local data
      _isBackendAvailable = false;
    }
  }

  /// Refresh menu data
  Future<void> refresh() async {
    if (_isBackendAvailable) {
      await _syncWithBackend();
    } else {
      // Try to reconnect to backend
      _isBackendAvailable = await _apiClient.checkHealth();
      if (_isBackendAvailable) {
        await _syncWithBackend();
      } else {
        // Just refresh local data timestamp
        state = state.copyWith(lastUpdated: DateTime.now());
      }
    }
  }

  /// Set selected category
  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
    StatePersistence.saveMenuState(state);
  }

  /// Toggle favorite item
  void toggleFavoriteItem(String itemId) {
    final favoriteIds = List<String>.from(state.favoriteItemIds);
    if (favoriteIds.contains(itemId)) {
      favoriteIds.remove(itemId);
    } else {
      favoriteIds.add(itemId);
    }
    
    state = state.copyWith(favoriteItemIds: favoriteIds);
    StatePersistence.saveMenuState(state);

    // TODO: Sync favorites with backend when available
    if (_isBackendAvailable) {
      _syncFavoritesWithBackend(itemId, favoriteIds.contains(itemId));
    }
  }

  Future<void> _syncFavoritesWithBackend(String itemId, bool isFavorite) async {
    try {
      // TODO: Implement favorites API endpoint
      debugPrint('Syncing favorite $itemId ($isFavorite) with backend');
    } catch (e) {
      debugPrint('Failed to sync favorites with backend: $e');
    }
  }

  /// Convert API model to state model
  DailyMenu _convertApiDailyMenuToStateModel(ApiDailyMenu apiMenu) {
    return DailyMenu(
      id: apiMenu.id,
      date: DateTime.parse(apiMenu.date),
      breakfastItems: apiMenu.breakfastItems.map(_convertApiMenuItemToStateModel).toList(),
      lunchItems: apiMenu.lunchItems.map(_convertApiMenuItemToStateModel).toList(),
      dinnerItems: apiMenu.dinnerItems.map(_convertApiMenuItemToStateModel).toList(),
      snackItems: apiMenu.snackItems.map(_convertApiMenuItemToStateModel).toList(),
      isPublished: apiMenu.isPublished,
      specialNote: apiMenu.specialNote,
    );
  }

  /// Convert API menu item to state model
  MenuItem _convertApiMenuItemToStateModel(ApiMenuItem apiItem) {
    return MenuItem(
      id: apiItem.id,
      name: apiItem.name,
      description: apiItem.description ?? '',
      category: apiItem.category,
      calories: apiItem.calories,
      price: apiItem.price,
      isAvailable: apiItem.isAvailable,
      iconName: apiItem.iconName,
      backgroundColor: apiItem.backgroundColor,
      iconColor: apiItem.iconColor,
      tags: apiItem.tags,
      rating: apiItem.rating,
      reviewCount: apiItem.reviewCount,
    );
  }

  /// Get backend availability status
  bool get isBackendAvailable => _isBackendAvailable;

  /// Check if data is stale and needs refresh
  bool get needsRefresh {
    if (state.lastUpdated == null) return true;
    final timeSinceUpdate = DateTime.now().difference(state.lastUpdated!);
    return timeSinceUpdate.inMinutes > AppConstants.dataRefreshIntervalMinutes;
  }
}

/// Provider for the enhanced menu state with backend integration
final menuProviderWithApi = StateNotifierProvider<MenuNotifierWithApi, MenuState>((ref) {
  return MenuNotifierWithApi();
});

/// Convenience providers for specific menu data
final todaysMenuProvider = Provider<DailyMenu?>((ref) {
  return ref.watch(menuProviderWithApi).todaysMenu;
});

final tomorrowsMenuProvider = Provider<DailyMenu?>((ref) {
  return ref.watch(menuProviderWithApi).tomorrowsMenu;
});

final favoriteItemsProvider = Provider<List<String>>((ref) {
  return ref.watch(menuProviderWithApi).favoriteItemIds;
});

final menuLoadingProvider = Provider<bool>((ref) {
  return ref.watch(menuProviderWithApi).isLoading;
});

final menuErrorProvider = Provider<String?>((ref) {
  return ref.watch(menuProviderWithApi).errorMessage;
});

/// Provider to check if backend is available
final backendAvailabilityProvider = Provider<bool>((ref) {
  return ref.watch(menuProviderWithApi.notifier).isBackendAvailable;
});