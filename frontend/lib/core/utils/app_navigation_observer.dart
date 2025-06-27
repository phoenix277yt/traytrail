import 'package:flutter/material.dart';

/// Navigation observer for tracking route changes
class AppNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logRouteChange('Push', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logRouteChange('Pop', route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _logRouteChange('Remove', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null && oldRoute != null) {
      _logRouteChange('Replace', newRoute, oldRoute);
    }
  }

  void _logRouteChange(String action, Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = route.settings.name ?? 'Unknown';
    final previousRouteName = previousRoute?.settings.name ?? 'None';
    
    debugPrint('🧭 Navigation $action: $routeName (from: $previousRouteName)');
    
    // You can add analytics tracking here
    // Analytics.trackScreenView(routeName);
  }
}
