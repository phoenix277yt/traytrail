import 'package:flutter/material.dart';

/// App color scheme and color constants
class AppColors {
  AppColors._();

  // Brand Colors
  static const Color tomato = Color(0xFFFE7252);
  static const Color mint = Color(0xFFF7E1D7);
  static const Color champagnePink = Color(0xFFF7E1D7);
  static const Color paynesGray = Color(0xFF495867);

  // Light Theme Color Scheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    
    // Primary color - Tomato
    primary: tomato,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFFFE4E1),
    onPrimaryContainer: paynesGray,
    
    // Secondary color - Mint
    secondary: mint,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE8F5F0),
    onSecondaryContainer: paynesGray,
    
    // Background - Champagne Pink
    surface: champagnePink,
    onSurface: paynesGray, // Payne's Gray for text
    
    // Error colors
    error: Color(0xFFBA1A1A),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    
    // Additional surface colors
    surfaceContainerHighest: Color(0xFFFAE6DD),
    onSurfaceVariant: paynesGray,
    outline: Color(0xFF8B7D7A),
    shadow: Colors.black26,
    inverseSurface: paynesGray,
    onInverseSurface: champagnePink,
  );

  // Dark Theme Color Scheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    
    // Primary color - Tomato (slightly muted for dark theme)
    primary: Color(0xFFFF8A75),
    onPrimary: Color(0xFF1A1A1A),
    primaryContainer: Color(0xFF3D1A12),
    onPrimaryContainer: Color(0xFFFFE4E1),
    
    // Secondary color - Mint (adapted for dark)
    secondary: Color(0xFF4DC5A1),
    onSecondary: Color(0xFF1A1A1A),
    secondaryContainer: Color(0xFF1F3A32),
    onSecondaryContainer: Color(0xFFE8F5F0),
    
    // Background - Dark surfaces
    surface: Color(0xFF1A1A1A),
    onSurface: Color(0xFFE8E8E8),
    
    // Error colors
    error: Color(0xFFFF6B6B),
    onError: Color(0xFF1A1A1A),
    errorContainer: Color(0xFF3D1A1A),
    onErrorContainer: Color(0xFFFFDAD6),
    
    // Additional surface colors
    surfaceContainerHighest: Color(0xFF2A2A2A),
    onSurfaceVariant: Color(0xFFB8B8B8),
    outline: Color(0xFF6A6A6A),
    shadow: Colors.black54,
    inverseSurface: Color(0xFFE8E8E8),
    onInverseSurface: Color(0xFF1A1A1A),
  );

  // Text Colors
  static const Color textPrimary = paynesGray;
  static const Color textSecondary = Color(0xFF8B7D7A);

  // Dark Theme Semantic Colors
  static const Color darkCardBackground = Color(0xFF2A2A2A);
  static const Color darkInputFillColor = Color(0xFF2A2A2A);
  static const Color darkTextPrimary = Color(0xFFE8E8E8);
  static const Color darkTextSecondary = Color(0xFFB8B8B8);

  // Success Colors
  static const Color success = mint;
  static const Color successContainer = Color(0xFFE8F5F0);

  // Semantic Colors
  static const Color cardBackground = Colors.white;
  static const Color inputFillColor = Colors.white;
}
