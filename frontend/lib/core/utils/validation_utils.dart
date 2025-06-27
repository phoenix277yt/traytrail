import '../constants/app_constants.dart';

/// Utility class for common validation functions
class ValidationUtils {
  ValidationUtils._();

  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.emailRequiredError;
    }
    if (!value.contains('@')) {
      return AppConstants.emailFormatError;
    }
    return null;
  }

  /// Validate password length
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.passwordRequiredError;
    }
    if (value.length < AppConstants.minPasswordLength) {
      return AppConstants.passwordLengthError;
    }
    return null;
  }

  /// Validate name field
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.nameRequiredError;
    }
    return null;
  }

  /// Validate role selection
  static String? validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.roleRequiredError;
    }
    return null;
  }

  /// Validate comment field
  static String? validateComment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.feedbackRequiredError;
    }
    if (value.length > AppConstants.maxCommentLength) {
      return AppConstants.commentLengthError;
    }
    return null;
  }

  /// Validate meal name
  static String? validateMealName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Meal name is required';
    }
    if (value.length > AppConstants.maxMealNameLength) {
      return 'Meal name must be ${AppConstants.maxMealNameLength} characters or less';
    }
    return null;
  }

  /// Validate meal description
  static String? validateMealDescription(String? value) {
    if (value != null && value.length > AppConstants.maxDescriptionLength) {
      return 'Description must be ${AppConstants.maxDescriptionLength} characters or less';
    }
    return null;
  }

  /// Validate quantity
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }
    
    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Please enter a valid number';
    }
    
    if (quantity < AppConstants.minQuantity) {
      return 'Quantity must be at least ${AppConstants.minQuantity}';
    }
    
    if (quantity > AppConstants.maxQuantity) {
      return 'Quantity must be ${AppConstants.maxQuantity} or less';
    }
    
    return null;
  }
}
