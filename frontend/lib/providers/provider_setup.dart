import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';
import 'selections_provider.dart';

/// Provider setup configuration for the application
class ProviderSetup {
  ProviderSetup._();

  /// Get all providers for the app
  static List<ChangeNotifierProvider> getProviders() {
    return [
      // Main app provider
      ChangeNotifierProvider<AppProvider>(
        create: (_) => AppProvider(),
      ),
      
      // Selections provider
      ChangeNotifierProvider<SelectionsProvider>(
        create: (_) => SelectionsProvider(),
      ),
      
      // Add more providers here as needed
      // ChangeNotifierProvider<UserProvider>(
      //   create: (_) => UserProvider(),
      // ),
      // ChangeNotifierProvider<MenuProvider>(
      //   create: (_) => MenuProvider(),
      // ),
    ];
  }

  /// Alternative method using MultiProvider.providers for better organization
  static List<ChangeNotifierProvider> getMultiProviders() {
    return [
      ChangeNotifierProvider<AppProvider>(
        create: (_) => AppProvider(),
      ),
      ChangeNotifierProvider<SelectionsProvider>(
        create: (_) => SelectionsProvider(),
      ),
      // ProxyProvider example for dependent providers
      // ProxyProvider<AppProvider, UserProvider>(
      //   update: (context, appProvider, previous) => 
      //     UserProvider(appProvider: appProvider),
      // ),
    ];
  }
}
