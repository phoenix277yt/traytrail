import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography configuration using Google Fonts
class AppTypography {
  AppTypography._();

  /// Build custom text theme using Google Fonts
  static TextTheme buildTextTheme({bool isDark = false}) {
    final Color textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    
    return TextTheme(
      // Headlines using Zen Loop
      displayLarge: GoogleFonts.zenLoop(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      displayMedium: GoogleFonts.zenLoop(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      displaySmall: GoogleFonts.zenLoop(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      headlineLarge: GoogleFonts.zenLoop(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.zenLoop(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.zenLoop(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      
      // Titles using Zen Loop
      titleLarge: GoogleFonts.zenLoop(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleMedium: GoogleFonts.zenLoop(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleSmall: GoogleFonts.zenLoop(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      
      // Body text using Epilogue
      bodyLarge: GoogleFonts.epilogue(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.epilogue(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodySmall: GoogleFonts.epilogue(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      
      // Labels using Roboto (for functional elements)
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelMedium: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelSmall: GoogleFonts.roboto(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }

  // Font families for specific use cases
  static TextStyle get zenLoopHeading => GoogleFonts.zenLoop();
  static TextStyle get epilogueBody => GoogleFonts.epilogue();
  static TextStyle get robotoLabels => GoogleFonts.roboto();

  // Common text styles
  static TextStyle get appBarTitle => GoogleFonts.zenLoop(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get buttonText => GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get inputLabel => GoogleFonts.roboto(
        color: AppColors.textSecondary,
      );

  static TextStyle get inputHint => GoogleFonts.roboto(
        color: AppColors.textSecondary.withValues(alpha: 0.6),
      );
}
