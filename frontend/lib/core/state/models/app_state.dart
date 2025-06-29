/// Global application state
class AppState {
  final bool isLoading;
  final int selectedNavigationIndex;
  final bool showSplash;
  final bool isOnline;
  final String? errorMessage;
  final bool isDarkMode;
  final bool animationsEnabled;

  const AppState({
    this.isLoading = false,
    this.selectedNavigationIndex = 0,
    this.showSplash = true,
    this.isOnline = false,
    this.errorMessage,
    this.isDarkMode = false,
    this.animationsEnabled = true,
  });

  AppState copyWith({
    bool? isLoading,
    int? selectedNavigationIndex,
    bool? showSplash,
    bool? isOnline,
    String? errorMessage,
    bool? isDarkMode,
    bool? animationsEnabled,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      selectedNavigationIndex: selectedNavigationIndex ?? this.selectedNavigationIndex,
      showSplash: showSplash ?? this.showSplash,
      isOnline: isOnline ?? this.isOnline,
      errorMessage: errorMessage ?? this.errorMessage,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isLoading': isLoading,
      'selectedNavigationIndex': selectedNavigationIndex,
      'showSplash': showSplash,
      'isOnline': isOnline,
      'errorMessage': errorMessage,
      'isDarkMode': isDarkMode,
      'animationsEnabled': animationsEnabled,
    };
  }

  factory AppState.fromJson(Map<String, dynamic> json) {
    return AppState(
      isLoading: json['isLoading'] ?? false,
      selectedNavigationIndex: json['selectedNavigationIndex'] ?? 0,
      showSplash: json['showSplash'] ?? true,
      isOnline: json['isOnline'] ?? false,
      errorMessage: json['errorMessage'],
      isDarkMode: json['isDarkMode'] ?? false,
      animationsEnabled: json['animationsEnabled'] ?? true,
    );
  }
}

/// Navigation state for the app
class NavigationState {
  final int currentIndex;
  final bool isTransitioning;
  final String? pendingRoute;

  const NavigationState({
    this.currentIndex = 0,
    this.isTransitioning = false,
    this.pendingRoute,
  });

  NavigationState copyWith({
    int? currentIndex,
    bool? isTransitioning,
    String? pendingRoute,
  }) {
    return NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
      isTransitioning: isTransitioning ?? this.isTransitioning,
      pendingRoute: pendingRoute ?? this.pendingRoute,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentIndex': currentIndex,
      'isTransitioning': isTransitioning,
      'pendingRoute': pendingRoute,
    };
  }

  factory NavigationState.fromJson(Map<String, dynamic> json) {
    return NavigationState(
      currentIndex: json['currentIndex'] ?? 0,
      isTransitioning: json['isTransitioning'] ?? false,
      pendingRoute: json['pendingRoute'],
    );
  }
}
