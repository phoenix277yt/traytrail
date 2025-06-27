import 'package:flutter/material.dart';

/// Main application provider for global app state
class AppProvider extends ChangeNotifier {
  // Theme management
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  // Locale management
  Locale _locale = const Locale('en', 'US');
  Locale get locale => _locale;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // User authentication state
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  /// Toggle theme mode between light and dark
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    notifyListeners();
  }

  /// Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  /// Change app locale
  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }

  /// Set loading state
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Set authentication state
  void setAuthenticated(bool authenticated) {
    if (_isAuthenticated != authenticated) {
      _isAuthenticated = authenticated;
      notifyListeners();
    }
  }

  /// Sign in user
  Future<void> signIn() async {
    setLoading(true);
    try {
      // Add authentication logic here
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      setAuthenticated(true);
    } catch (e) {
      // Handle error
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    setLoading(true);
    try {
      // Add sign out logic here
      await Future.delayed(const Duration(milliseconds: 500));
      setAuthenticated(false);
    } catch (e) {
      // Handle error
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
