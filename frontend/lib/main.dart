import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'core/core.dart';
import 'providers/provider_setup.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize error handling
  await _initializeErrorHandling();
  
  // Configure system UI
  await _configureSystemUI();
  
  // Initialize app configuration
  await AppConfig.initialize();
  
  // Initialize services
  await _initializeServices();
  
  // Run the app
  runApp(const TrayTrailApp());
}

/// Initialize global error handling
Future<void> _initializeErrorHandling() async {
  // Handle Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    LoggingService.fatal(
      'Flutter Error: ${details.exception}',
      details.exception,
      details.stack,
    );
  };

  // Handle platform errors
  PlatformDispatcher.instance.onError = (error, stack) {
    LoggingService.fatal('Platform Error: $error', error, stack);
    return true;
  };
}

/// Initialize services
Future<void> _initializeServices() async {
  // Initialize service locator
  await ServiceLocator.initialize();
  
  // Initialize HTTP service
  HttpService().initialize();
  
  // Initialize cache service (already initialized as singleton)
  // CacheService();
  
  LoggingService.info('Services initialized successfully');
}

/// Configure system UI overlay style
Future<void> _configureSystemUI() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

/// Main app widget - stateless widget for the TrayTrail application
class TrayTrailApp extends StatelessWidget {
  const TrayTrailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ProviderSetup.getProviders(),
      child: Builder(
        builder: (context) {
          // Get the app provider if available
          final appProvider = context.read<AppProvider>();
          
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            
            // Material 3 theme configuration
            theme: AppTheme.buildLightTheme(),
            darkTheme: AppTheme.buildDarkTheme(),
            themeMode: appProvider.themeMode,
            
            // Localization
            locale: appProvider.locale,
            
            // Initial route
            initialRoute: AppRoutes.initialRoute,
            
            // Named routes configuration
            routes: AppRoutes.buildRoutes(),
            
            // Global navigation observers
            navigatorObservers: const [
              // AppNavigationObserver(),
            ],
            
            // Error handling
            builder: (context, widget) {
              // ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
              //   return AppErrorWidget(errorDetails: errorDetails);
              // };
              return widget ?? const SizedBox();
            },
          );
        },
      ),
    );
  }
}
