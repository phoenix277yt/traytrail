import 'package:flutter/material.dart';

/// Utility class for common helper functions
class AppUtils {
  /// Format duration to human readable string
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays == 1 ? '' : 's'}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours == 1 ? '' : 's'}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes == 1 ? '' : 's'}';
    } else {
      return '${duration.inSeconds} second${duration.inSeconds == 1 ? '' : 's'}';
    }
  }

  /// Get time ago string from DateTime
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Format time range for menu availability
  static String formatTimeRange(DateTime from, DateTime to) {
    final fromTime = TimeOfDay.fromDateTime(from);
    final toTime = TimeOfDay.fromDateTime(to);
    return '${fromTime.format(
      // We need a context for this, so we'll use a simplified format
      BuildContext as dynamic,
    )} - ${toTime.format(
      BuildContext as dynamic,
    )}';
  }

  /// Simplified time format without context
  static String formatTimeRangeSimple(DateTime from, DateTime to) {
    return '${_formatTime(from)} - ${_formatTime(to)}';
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$displayHour:$minuteStr $period';
  }

  /// Generate a random ID for demo purposes
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Calculate percentage
  static int calculatePercentage(int value, int total) {
    if (total == 0) return 0;
    return ((value / total) * 100).round();
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Show custom snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
        duration: duration,
      ),
    );
  }

  /// Get icon data from string name
  static IconData getIconFromString(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'breakfast_dining':
        return Icons.breakfast_dining;
      case 'rice_bowl':
        return Icons.rice_bowl;
      case 'local_dining':
        return Icons.local_dining;
      case 'restaurant':
        return Icons.restaurant;
      case 'coffee':
        return Icons.coffee;
      case 'fastfood':
        return Icons.fastfood;
      case 'lunch_dining':
        return Icons.lunch_dining;
      case 'dinner_dining':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }

  /// Get color shade based on value (for data visualization)
  static Color getColorShade(Color baseColor, double intensity) {
    // intensity should be between 0.0 and 1.0
    final clampedIntensity = intensity.clamp(0.0, 1.0);
    return Color.lerp(
      baseColor.withValues(alpha: 0.1),
      baseColor,
      clampedIntensity,
    )!;
  }
}
