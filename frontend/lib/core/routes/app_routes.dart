import 'package:flutter/material.dart';
import '../../screens/splash_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/signup_screen.dart';
import '../../screens/forgot_password_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/meal_detail_screen.dart';
import '../../screens/selections_screen.dart';
import '../../screens/order_history_screen.dart';
import '../../screens/poll_screen.dart';
import '../../screens/feedback_screen.dart';

/// Application routes configuration
class AppRoutes {
  AppRoutes._();

  // Route names
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot_password';
  static const String home = '/home';
  static const String mealDetail = '/meal_detail';
  static const String selections = '/selections';
  static const String orderHistory = '/order_history';
  static const String poll = '/poll';
  static const String feedback = '/feedback';

  /// Initial route for the application
  static const String initialRoute = splash;

  /// Build named routes configuration
  static Map<String, WidgetBuilder> buildRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      home: (context) => const HomeScreen(),
      mealDetail: (context) => const MealDetailScreen(),
      selections: (context) => const SelectionsScreen(),
      orderHistory: (context) => const OrderHistoryScreen(),
      poll: (context) => const PollScreen(),
      feedback: (context) => const FeedbackScreen(),
    };
  }

  /// Helper methods for navigation
  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, login);
  }

  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, home);
  }

  static void navigateToSignup(BuildContext context) {
    Navigator.pushNamed(context, signup);
  }

  static void navigateToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, forgotPassword);
  }

  static void navigateToMealDetail(BuildContext context) {
    Navigator.pushNamed(context, mealDetail);
  }

  static void navigateToSelections(BuildContext context) {
    Navigator.pushNamed(context, selections);
  }

  static void navigateToOrderHistory(BuildContext context) {
    Navigator.pushNamed(context, orderHistory);
  }

  static void navigateToPoll(BuildContext context) {
    Navigator.pushNamed(context, poll);
  }

  static void navigateToFeedback(BuildContext context) {
    Navigator.pushNamed(context, feedback);
  }

  /// Pop current screen
  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
