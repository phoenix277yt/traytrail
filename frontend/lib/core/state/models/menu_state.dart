/// Menu-related state management models
library;

/// Represents a single menu item
class MenuItem {
  final String id;
  final String name;
  final String description;
  final String category; // breakfast, lunch, dinner, snacks
  final int calories;
  final double price;
  final bool isAvailable;
  final String iconName;
  final String backgroundColor;
  final String iconColor;
  final List<String> tags; // informational tags like 'vegetarian', 'healthy', 'protein-rich', etc.
  final double rating;
  final int reviewCount;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    this.category = 'lunch',
    this.calories = 0,
    this.price = 0.0,
    this.isAvailable = true,
    this.iconName = 'restaurant',
    this.backgroundColor = '#E3F2FD',
    this.iconColor = '#1976D2',
    this.tags = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    int? calories,
    double? price,
    bool? isAvailable,
    String? iconName,
    String? backgroundColor,
    String? iconColor,
    List<String>? tags,
    double? rating,
    int? reviewCount,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      calories: calories ?? this.calories,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
      iconName: iconName ?? this.iconName,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconColor: iconColor ?? this.iconColor,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'calories': calories,
      'price': price,
      'isAvailable': isAvailable,
      'iconName': iconName,
      'backgroundColor': backgroundColor,
      'iconColor': iconColor,
      'tags': tags,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'] ?? 'lunch',
      calories: json['calories'] ?? 0,
      price: json['price']?.toDouble() ?? 0.0,
      isAvailable: json['isAvailable'] ?? true,
      iconName: json['iconName'] ?? 'restaurant',
      backgroundColor: json['backgroundColor'] ?? '#E3F2FD',
      iconColor: json['iconColor'] ?? '#1976D2',
      tags: List<String>.from(json['tags'] ?? []),
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
    );
  }
}

/// Represents a daily menu
class DailyMenu {
  final String id;
  final DateTime date;
  final List<MenuItem> breakfastItems;
  final List<MenuItem> lunchItems;
  final List<MenuItem> dinnerItems;
  final List<MenuItem> snackItems;
  final bool isPublished;
  final String? specialNote;

  const DailyMenu({
    required this.id,
    required this.date,
    this.breakfastItems = const [],
    this.lunchItems = const [],
    this.dinnerItems = const [],
    this.snackItems = const [],
    this.isPublished = false,
    this.specialNote,
  });

  DailyMenu copyWith({
    String? id,
    DateTime? date,
    List<MenuItem>? breakfastItems,
    List<MenuItem>? lunchItems,
    List<MenuItem>? dinnerItems,
    List<MenuItem>? snackItems,
    bool? isPublished,
    String? specialNote,
  }) {
    return DailyMenu(
      id: id ?? this.id,
      date: date ?? this.date,
      breakfastItems: breakfastItems ?? this.breakfastItems,
      lunchItems: lunchItems ?? this.lunchItems,
      dinnerItems: dinnerItems ?? this.dinnerItems,
      snackItems: snackItems ?? this.snackItems,
      isPublished: isPublished ?? this.isPublished,
      specialNote: specialNote ?? this.specialNote,
    );
  }

  List<MenuItem> getAllItems() {
    return [
      ...breakfastItems,
      ...lunchItems,
      ...dinnerItems,
      ...snackItems,
    ];
  }

  List<MenuItem> getItemsByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return breakfastItems;
      case 'lunch':
        return lunchItems;
      case 'dinner':
        return dinnerItems;
      case 'snacks':
        return snackItems;
      default:
        return [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'breakfastItems': breakfastItems.map((i) => i.toJson()).toList(),
      'lunchItems': lunchItems.map((i) => i.toJson()).toList(),
      'dinnerItems': dinnerItems.map((i) => i.toJson()).toList(),
      'snackItems': snackItems.map((i) => i.toJson()).toList(),
      'isPublished': isPublished,
      'specialNote': specialNote,
    };
  }

  factory DailyMenu.fromJson(Map<String, dynamic> json) {
    return DailyMenu(
      id: json['id'],
      date: DateTime.parse(json['date']),
      breakfastItems: (json['breakfastItems'] as List?)
          ?.map((i) => MenuItem.fromJson(i))
          .toList() ?? [],
      lunchItems: (json['lunchItems'] as List?)
          ?.map((i) => MenuItem.fromJson(i))
          .toList() ?? [],
      dinnerItems: (json['dinnerItems'] as List?)
          ?.map((i) => MenuItem.fromJson(i))
          .toList() ?? [],
      snackItems: (json['snackItems'] as List?)
          ?.map((i) => MenuItem.fromJson(i))
          .toList() ?? [],
      isPublished: json['isPublished'] ?? false,
      specialNote: json['specialNote'],
    );
  }
}

/// Overall menu state
class MenuState {
  final List<DailyMenu> weeklyMenus;
  final DailyMenu? todaysMenu;
  final DailyMenu? tomorrowsMenu;
  final String selectedCategory;
  final List<String> favoriteItemIds;
  final Map<String, int> itemPopularity; // item_id -> popularity_score
  final bool isLoading;
  final String? errorMessage;
  final DateTime? lastUpdated;

  const MenuState({
    this.weeklyMenus = const [],
    this.todaysMenu,
    this.tomorrowsMenu,
    this.selectedCategory = 'lunch',
    this.favoriteItemIds = const [],
    this.itemPopularity = const {},
    this.isLoading = false,
    this.errorMessage,
    this.lastUpdated,
  });

  MenuState copyWith({
    List<DailyMenu>? weeklyMenus,
    DailyMenu? todaysMenu,
    DailyMenu? tomorrowsMenu,
    String? selectedCategory,
    List<String>? favoriteItemIds,
    Map<String, int>? itemPopularity,
    bool? isLoading,
    String? errorMessage,
    DateTime? lastUpdated,
  }) {
    return MenuState(
      weeklyMenus: weeklyMenus ?? this.weeklyMenus,
      todaysMenu: todaysMenu ?? this.todaysMenu,
      tomorrowsMenu: tomorrowsMenu ?? this.tomorrowsMenu,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      favoriteItemIds: favoriteItemIds ?? this.favoriteItemIds,
      itemPopularity: itemPopularity ?? this.itemPopularity,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  List<MenuItem> getPopularItems({int limit = 5}) {
    final allItems = weeklyMenus.expand((menu) => menu.getAllItems()).toList();
    allItems.sort((a, b) => (itemPopularity[b.id] ?? 0).compareTo(itemPopularity[a.id] ?? 0));
    return allItems.take(limit).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'weeklyMenus': weeklyMenus.map((m) => m.toJson()).toList(),
      'todaysMenu': todaysMenu?.toJson(),
      'tomorrowsMenu': tomorrowsMenu?.toJson(),
      'selectedCategory': selectedCategory,
      'favoriteItemIds': favoriteItemIds,
      'itemPopularity': itemPopularity,
      'isLoading': isLoading,
      'errorMessage': errorMessage,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory MenuState.fromJson(Map<String, dynamic> json) {
    return MenuState(
      weeklyMenus: (json['weeklyMenus'] as List?)
          ?.map((m) => DailyMenu.fromJson(m))
          .toList() ?? [],
      todaysMenu: json['todaysMenu'] != null 
          ? DailyMenu.fromJson(json['todaysMenu']) 
          : null,
      tomorrowsMenu: json['tomorrowsMenu'] != null 
          ? DailyMenu.fromJson(json['tomorrowsMenu']) 
          : null,
      selectedCategory: json['selectedCategory'] ?? 'lunch',
      favoriteItemIds: List<String>.from(json['favoriteItemIds'] ?? []),
      itemPopularity: Map<String, int>.from(json['itemPopularity'] ?? {}),
      isLoading: json['isLoading'] ?? false,
      errorMessage: json['errorMessage'],
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated']) 
          : null,
    );
  }
}
