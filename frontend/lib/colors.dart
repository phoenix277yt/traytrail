import 'package:flutter/material.dart';

/// TrayTrail color palette based on the custom brand colors
class TrayTrailColors {
  // Brand Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color champagnePink = Color(0xFFF7E1D7);
  static const Color mint = Color(0xFF3AB795);
  static const Color paynesGray = Color(0xFF495867);
  static const Color tomato = Color(0xFFFE7252);

  // Extended Mint palette
  static const Color mintLight = Color(0xFFD6F2EB);
  static const Color mintDark = Color(0xFF0C241E);
  static const Color mintSaturated = Color(0xFF2A9D7A); // More saturated for better contrast

  // Extended Champagne Pink palette
  static const Color champagnePinkLight = Color(0xFFFDF9F7);
  static const Color champagnePinkDark = Color(0xFF4E230F);
  static const Color champagnePinkSaturated = Color(0xFFE8C4B0); // More saturated for better contrast

  // Extended Payne's Gray palette
  static const Color paynesGrayLight = Color(0xFFD8DEE3);
  static const Color paynesGrayDark = Color(0xFF0F1215);
  static const Color paynesGraySaturated = Color(0xFF3A4A5C); // More saturated for better contrast

  // Extended Tomato palette
  static const Color tomatoLight = Color(0xFFFFE3DC);
  static const Color tomatoDark = Color(0xFF430D00);
  static const Color tomatoSaturated = Color(0xFFE85A3A); // More saturated for better contrast
}

/// Material 3 Color Schemes using TrayTrail brand colors
class TrayTrailColorSchemes {
  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: TrayTrailColors.champagnePinkSaturated,
    brightness: Brightness.light,
    primary: TrayTrailColors.champagnePinkSaturated,
    secondary: TrayTrailColors.tomatoSaturated,
    tertiary: TrayTrailColors.mintSaturated,
    surface: TrayTrailColors.white,
    onPrimary: TrayTrailColors.white,
    onSecondary: TrayTrailColors.white,
    onTertiary: TrayTrailColors.white,
    onSurface: TrayTrailColors.paynesGraySaturated,
    surfaceContainerHighest: TrayTrailColors.champagnePinkLight,
    onSurfaceVariant: TrayTrailColors.paynesGrayDark,
    outline: TrayTrailColors.paynesGraySaturated,
    surfaceTint: TrayTrailColors.champagnePinkSaturated,
    primaryContainer: TrayTrailColors.champagnePinkLight,
    onPrimaryContainer: TrayTrailColors.paynesGraySaturated,
    secondaryContainer: TrayTrailColors.tomatoLight,
    onSecondaryContainer: TrayTrailColors.tomatoDark,
    tertiaryContainer: TrayTrailColors.mintLight,
    onTertiaryContainer: TrayTrailColors.mintDark,
  );
}
