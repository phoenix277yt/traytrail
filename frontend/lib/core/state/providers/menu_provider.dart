import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_state.dart';
import '../persistence/state_persistence.dart';
import '../../services/food_tags_service.dart';

/// Menu state notifier
class MenuNotifier extends StateNotifier<MenuState> {
  MenuNotifier() : super(const MenuState()) {
    _loadPersistedState();
    _initializeMockData();
  }

  /// Load persisted state
  Future<void> _loadPersistedState() async {
    final persistedState = await StatePersistence.loadMenuState();
    if (persistedState != null) {
      state = persistedState;
    }
  }

  /// Save state to persistence
  Future<void> _saveState() async {
    await StatePersistence.saveMenuState(state);
  }

  /// Initialize with mock data
  void _initializeMockData() {
    if (state.weeklyMenus.isEmpty) {
      final today = DateTime.now();
      final todayMenu = DailyMenu(
        id: 'menu_${today.day}',
        date: today,
        isPublished: true,
        breakfastItems: [
          MenuItem(
            id: 'breakfast_1',
            name: 'Poha',
            description: 'Flattened rice with vegetables and spices',
            category: 'breakfast',
            calories: 280,
            price: 25.0,
            iconName: 'rice_bowl',
            backgroundColor: '#E3F2FD',
            iconColor: '#1976D2',
            tags: FoodTagsService.getTagsForFood('Poha'),
            rating: 4.2,
            reviewCount: 45,
          ),
          MenuItem(
            id: 'breakfast_2',
            name: 'Upma',
            description: 'Semolina porridge with vegetables',
            category: 'breakfast',
            calories: 320,
            price: 30.0,
            iconName: 'breakfast_dining',
            backgroundColor: '#F3E5F5',
            iconColor: '#7B1FA2',
            tags: FoodTagsService.getTagsForFood('Upma'),
            rating: 3.8,
            reviewCount: 32,
          ),
        ],
        lunchItems: [
          MenuItem(
            id: 'lunch_1',
            name: 'Rajma Chawal',
            description: 'Kidney beans curry with steamed rice',
            category: 'lunch',
            calories: 450,
            price: 60.0,
            iconName: 'rice_bowl',
            backgroundColor: '#E8F5E8',
            iconColor: '#388E3C',
            tags: FoodTagsService.getTagsForFood('Rajma Chawal'),
            rating: 4.6,
            reviewCount: 89,
          ),
          MenuItem(
            id: 'lunch_2',
            name: 'Chole Bhature',
            description: 'Spiced chickpeas with fried bread',
            category: 'lunch',
            calories: 520,
            price: 70.0,
            iconName: 'local_dining',
            backgroundColor: '#FFF3E0',
            iconColor: '#F57C00',
            tags: FoodTagsService.getTagsForFood('Chole Bhature'),
            rating: 4.4,
            reviewCount: 76,
          ),
          MenuItem(
            id: 'lunch_3',
            name: 'Dal Tadka & Roti',
            description: 'Lentil curry with Indian flatbread',
            category: 'lunch',
            calories: 380,
            price: 55.0,
            iconName: 'breakfast_dining',
            backgroundColor: '#E0F2F1',
            iconColor: '#00695C',
            tags: FoodTagsService.getTagsForFood('Dal Tadka & Roti'),
            rating: 4.1,
            reviewCount: 54,
          ),
        ],
      );

      final tomorrowMenu = DailyMenu(
        id: 'menu_${today.add(const Duration(days: 1)).day}',
        date: today.add(const Duration(days: 1)),
        isPublished: false,
        specialNote: 'Menu under preparation based on your votes!',
      );

      final popularity = {
        'lunch_1': 89,  // Rajma Chawal
        'lunch_2': 76,  // Chole Bhature
        'breakfast_1': 45, // Poha
        'lunch_3': 54,  // Dal Tadka
        'breakfast_2': 32, // Upma
      };

      state = state.copyWith(
        weeklyMenus: [todayMenu],
        todaysMenu: todayMenu,
        tomorrowsMenu: tomorrowMenu,
        itemPopularity: popularity,
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

  /// Set selected category
  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
    _saveState();
  }

  /// Add item to favorites
  void addToFavorites(String itemId) {
    final newFavorites = List<String>.from(state.favoriteItemIds);
    if (!newFavorites.contains(itemId)) {
      newFavorites.add(itemId);
      state = state.copyWith(favoriteItemIds: newFavorites);
      _saveState();
    }
  }

  /// Remove item from favorites
  void removeFromFavorites(String itemId) {
    final newFavorites = List<String>.from(state.favoriteItemIds);
    newFavorites.remove(itemId);
    state = state.copyWith(favoriteItemIds: newFavorites);
    _saveState();
  }

  /// Toggle favorite status
  void toggleFavorite(String itemId) {
    if (state.favoriteItemIds.contains(itemId)) {
      removeFromFavorites(itemId);
    } else {
      addToFavorites(itemId);
    }
  }

  /// Update item rating
  Future<void> rateItem(String itemId, double rating) async {
    setLoading(true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Update the item rating in all menus
      final updatedMenus = state.weeklyMenus.map((menu) {
        final updatedItems = menu.getAllItems().map((item) {
          if (item.id == itemId) {
            final newReviewCount = item.reviewCount + 1;
            final newRating = ((item.rating * item.reviewCount) + rating) / newReviewCount;
            return item.copyWith(
              rating: newRating,
              reviewCount: newReviewCount,
            );
          }
          return item;
        }).toList();

        // Reconstruct the menu with updated items
        return menu.copyWith(
          breakfastItems: updatedItems.where((i) => i.category == 'breakfast').toList(),
          lunchItems: updatedItems.where((i) => i.category == 'lunch').toList(),
          dinnerItems: updatedItems.where((i) => i.category == 'dinner').toList(),
          snackItems: updatedItems.where((i) => i.category == 'snacks').toList(),
        );
      }).toList();

      state = state.copyWith(
        weeklyMenus: updatedMenus,
        todaysMenu: updatedMenus.isNotEmpty ? updatedMenus.first : null,
        lastUpdated: DateTime.now(),
      );

    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to submit rating: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Refresh menu data
  Future<void> refreshMenus() async {
    setLoading(true);

    try {
      // Simulate API refresh
      await Future.delayed(const Duration(milliseconds: 1000));
      
      state = state.copyWith(
        lastUpdated: DateTime.now(),
        errorMessage: null,
      );

    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to refresh menus: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Filter items by category
  List<MenuItem> getItemsByCategory(String category) {
    if (state.todaysMenu == null) return [];
    
    switch (category.toLowerCase()) {
      case 'breakfast':
        return state.todaysMenu!.breakfastItems;
      case 'lunch':
        return state.todaysMenu!.lunchItems;
      case 'dinner':
        return state.todaysMenu!.dinnerItems;
      case 'snacks':
        return state.todaysMenu!.snackItems;
      default:
        return state.todaysMenu!.getAllItems();
    }
  }

  /// Get favorite items
  List<MenuItem> getFavoriteItems() {
    final allItems = state.weeklyMenus.expand((menu) => menu.getAllItems()).toList();
    return allItems.where((item) => state.favoriteItemIds.contains(item.id)).toList();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
    _saveState();
  }

  /// Reset menu state
  void reset() {
    state = const MenuState();
    _saveState();
  }
}

/// Provider
final menuProvider = StateNotifierProvider<MenuNotifier, MenuState>((ref) {
  return MenuNotifier();
});

/// Computed providers
final todaysMenuProvider = Provider<DailyMenu?>((ref) {
  return ref.watch(menuProvider).todaysMenu;
});

final tomorrowsMenuProvider = Provider<DailyMenu?>((ref) {
  return ref.watch(menuProvider).tomorrowsMenu;
});

final selectedCategoryProvider = Provider<String>((ref) {
  return ref.watch(menuProvider).selectedCategory;
});

final favoriteItemsProvider = Provider<List<String>>((ref) {
  return ref.watch(menuProvider).favoriteItemIds;
});

final currentCategoryItemsProvider = Provider<List<MenuItem>>((ref) {
  final menuState = ref.watch(menuProvider);
  final menuNotifier = ref.watch(menuProvider.notifier);
  return menuNotifier.getItemsByCategory(menuState.selectedCategory);
});

final popularItemsProvider = Provider<List<MenuItem>>((ref) {
  final menuState = ref.watch(menuProvider);
  return menuState.getPopularItems();
});

final isMenuLoadingProvider = Provider<bool>((ref) {
  return ref.watch(menuProvider).isLoading;
});

final menuErrorProvider = Provider<String?>((ref) {
  return ref.watch(menuProvider).errorMessage;
});

final menuLastUpdatedProvider = Provider<DateTime?>((ref) {
  return ref.watch(menuProvider).lastUpdated;
});
