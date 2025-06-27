/// Application constants
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'TrayTrail';
  static const String appDescription = 'Your food journey companion';

  // Navigation Timing
  static const int splashDurationSeconds = 3;
  static const int successMessageDurationMilliseconds = 2000;
  static const int shortDelayMilliseconds = 1500;

  // Validation Constants
  static const int minPasswordLength = 6;
  static const int maxCommentLength = 200;
  static const int maxMealNameLength = 50;
  static const int maxDescriptionLength = 200;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double screenPadding = 24.0;
  static const double cardPadding = 12.0;
  static const double sectionSpacing = 32.0;
  static const double itemSpacing = 16.0;
  static const double smallSpacing = 8.0;

  static const double defaultBorderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;

  static const double defaultElevation = 2.0;
  static const double cardElevation = 4.0;

  // Asset Paths (for future use)
  static const String iconsPath = 'assets/icons/';
  static const String imagesPath = 'assets/images/';
  static const String fontsPath = 'assets/fonts/';

  // Error Messages
  static const String emailRequiredError = 'Please enter your email';
  static const String emailFormatError = 'Email must contain @';
  static const String passwordRequiredError = 'Please enter your password';
  static const String passwordLengthError = 'Password must be at least 6 characters';
  static const String nameRequiredError = 'Please enter your name';
  static const String roleRequiredError = 'Please select your role';
  static const String feedbackRequiredError = 'Please enter your feedback';
  static const String commentLengthError = 'Comment must be 200 characters or less';
  static const String ratingRequiredError = 'Please select a rating before submitting';
  static const String selectOptionError = 'Please select an option';

  // Success Messages
  static const String loginSuccessMessage = 'Login successful';
  static const String signupSuccessMessage = 'Signup successful';
  static const String resetLinkSentMessage = 'Reset link sent';
  static const String feedbackSubmittedMessage = 'Thank you for your feedback!';
  static const String voteSubmittedMessage = 'Thank you for voting!';
  static const String selectionsConfirmedMessage = 'Selections confirmed';

  // Screen Titles
  static const String loginTitle = 'Login';
  static const String signupTitle = 'Sign Up';
  static const String forgotPasswordTitle = 'Forgot Password';
  static const String homeTitle = 'TrayTrail';
  static const String mealDetailTitle = 'Meal Details';
  static const String selectionsTitle = 'My Selections';
  static const String orderHistoryTitle = 'Order History';
  static const String pollTitle = 'Daily Poll';
  static const String feedbackTitle = 'Feedback';

  // User Roles
  static const List<String> userRoles = ['student', 'parent', 'teacher', 'staff'];

  // Default Values
  static const int defaultMealCalories = 100;
  static const int defaultQuantity = 1;
  static const int minQuantity = 1;
  static const int maxQuantity = 10;
}
