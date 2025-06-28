import 'package:flutter/material.dart';
import 'app_colors.dart';

/// TrayTrail app themes with custom fonts and color schemes
class TrayTrailTheme {
  // Text theme using custom fonts
  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      // Display styles - using ZenLoop for headers
      displayLarge: TextStyle(
        fontFamily: 'ZenLoop',
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: colorScheme.onSurface,
      ),
      displayMedium: TextStyle(
        fontFamily: 'ZenLoop',
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      displaySmall: TextStyle(
        fontFamily: 'ZenLoop',
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      
      // Headline styles - using Epilogue
      headlineLarge: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      
      // Title styles - using Epilogue
      titleLarge: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: colorScheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: colorScheme.onSurface,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
      ),
      
      // Body styles - using Roboto
      bodyLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: colorScheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: colorScheme.onSurface,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: colorScheme.onSurfaceVariant,
      ),
      
      // Label styles - using Epilogue
      labelLarge: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: colorScheme.onSurface,
      ),
    );
  }

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: TrayTrailColorSchemes.lightColorScheme,
    textTheme: _buildTextTheme(TrayTrailColorSchemes.lightColorScheme),
    
    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: TrayTrailColorSchemes.lightColorScheme.surface,
      foregroundColor: TrayTrailColorSchemes.lightColorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Epilogue',
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: TrayTrailColorSchemes.lightColorScheme.onSurface,
      ),
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: TrayTrailColorSchemes.lightColorScheme.surface,
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TrayTrailColorSchemes.lightColorScheme.primary,
        foregroundColor: TrayTrailColorSchemes.lightColorScheme.onPrimary,
        textStyle: const TextStyle(
          fontFamily: 'Epilogue',
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    
    // Filled Button Theme
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: TrayTrailColorSchemes.lightColorScheme.primary,
        foregroundColor: TrayTrailColorSchemes.lightColorScheme.onPrimary,
        textStyle: const TextStyle(
          fontFamily: 'Epilogue',
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: TrayTrailColorSchemes.lightColorScheme.primary,
      foregroundColor: TrayTrailColorSchemes.lightColorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // Navigation Bar Theme
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: TrayTrailColorSchemes.lightColorScheme.surface,
      indicatorColor: TrayTrailColorSchemes.lightColorScheme.secondaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return TextStyle(
          fontFamily: 'Epilogue',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? TrayTrailColorSchemes.lightColorScheme.onSecondaryContainer
              : TrayTrailColorSchemes.lightColorScheme.onSurfaceVariant,
        );
      }),
    ),
  );
}
