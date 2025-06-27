# TrayTrail Flutter App - Refactored Structure

## Overview
This Flutter app has been completely refactored to follow best practices and maintain clean architecture principles.

## 📁 Project Structure

```
lib/
├── core/                    # Core application components
│   ├── base/               # Base classes and mixins
│   │   └── base_view_model.dart    # Base ViewModel with common functionality
│   ├── config/             # App configuration
│   │   └── app_config.dart         # Centralized app settings
│   ├── constants/          # App constants
│   │   └── app_constants.dart      # UI, validation, and other constants
│   ├── data/               # Data layer
│   │   ├── base_repository.dart    # Repository pattern interface
│   │   └── sample_data.dart        # Mock/sample data
│   ├── models/             # Data models
│   │   ├── meal_selection.dart
│   │   └── menu_item.dart
│   ├── routes/             # Navigation
│   │   └── app_routes.dart         # Centralized route management
│   ├── services/           # App services
│   │   ├── cache_service.dart      # In-memory caching
│   │   ├── http_service.dart       # HTTP client wrapper
│   │   ├── logging_service.dart    # Enhanced logging
│   │   └── service_locator.dart    # Dependency injection
│   ├── theme/              # App theming
│   │   ├── app_colors.dart         # Color scheme (light/dark)
│   │   ├── app_theme.dart          # Theme configuration
│   │   └── app_typography.dart     # Text styles
│   ├── utils/              # Utilities
│   │   ├── app_navigation_observer.dart  # Navigation tracking
│   │   ├── ui_utils.dart
│   │   └── validation_utils.dart
│   ├── widgets/            # Reusable widgets
│   │   ├── app_error_widget.dart   # Error handling widget
│   │   └── common_widgets.dart     # Common UI components
│   └── core.dart           # Single export file for core
├── providers/              # State management
│   ├── app_provider.dart           # Global app state
│   ├── provider_setup.dart         # Provider configuration
│   └── selections_provider.dart    # Existing selections logic
├── screens/                # UI screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   └── ... (other screens)
└── main.dart              # App entry point
```

## 🎯 Key Improvements

### 1. **Clean Architecture**
- Separation of concerns with distinct layers
- Repository pattern for data access
- Service layer for business logic
- Clear dependency management

### 2. **State Management**
- Enhanced provider setup with MultiProvider
- Base view model with common functionality
- Mixins for pagination and search functionality
- Global app state management

### 3. **Theme & Styling**
- Complete dark/light theme support
- Consistent color scheme and typography
- Material 3 design implementation
- Centralized styling configuration

### 4. **Error Handling & Logging**
- Comprehensive error handling throughout the app
- Enhanced logging service with different levels
- Custom error widgets for better UX
- Performance monitoring capabilities

### 5. **Services & Utilities**
- HTTP service with proper error handling
- In-memory caching for performance
- Service locator for dependency injection
- Navigation observer for tracking

### 6. **Reusable Components**
- Common widget library
- Loading, empty, and error state widgets
- Custom app bar and button components
- Consistent UI patterns

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK
- Android Studio / VS Code

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## 📱 Features

### Current Implementation
- **Authentication Flow**: Login, signup, forgot password
- **Home Dashboard**: Main app interface
- **Meal Management**: Selection and detail views
- **Order History**: Past selections tracking
- **Polls & Feedback**: User engagement features

### Architecture Features
- **Error Boundaries**: Graceful error handling
- **Caching**: Improved performance with smart caching
- **Logging**: Comprehensive logging for debugging
- **Theme Switching**: Dynamic light/dark mode support
- **State Persistence**: Maintained app state across sessions

## 🛠️ Development Guidelines

### Code Organization
- Keep business logic in providers/view models
- Use the repository pattern for data access
- Leverage the service locator for dependencies
- Follow consistent naming conventions

### State Management
- Extend `BaseViewModel` for common functionality
- Use mixins for shared behaviors (pagination, search)
- Keep UI logic separate from business logic
- Use `Consumer` and `Provider.of` appropriately

### Styling
- Use `AppColors` and `AppTypography` consistently
- Follow Material 3 design principles
- Support both light and dark themes
- Use constants for consistent spacing

### Error Handling
- Use try-catch blocks with proper logging
- Display user-friendly error messages
- Implement retry mechanisms where appropriate
- Log errors for debugging purposes

## 📚 Key Classes & Usage

### AppProvider
```dart
// Global app state management
final appProvider = context.read<AppProvider>();
appProvider.toggleTheme();
```

### BaseViewModel
```dart
// Extend for screen-specific logic
class HomeViewModel extends BaseViewModel with PaginationMixin<MenuItem> {
  // Implementation
}
```

### ServiceLocator
```dart
// Dependency injection
ServiceLocator().register<ApiService>(ApiService());
final api = ServiceLocator().get<ApiService>();
```

### CacheService
```dart
// Caching data
CacheService().put('key', data);
final cached = CacheService().get<DataType>('key');
```

## 🔧 Configuration

### Environment Setup
- Modify `AppConfig` for environment-specific settings
- Update API endpoints and feature flags
- Configure logging levels for different builds

### Theme Customization
- Edit `AppColors` for color scheme changes
- Modify `AppTypography` for font customizations
- Update `AppTheme` for component theming

## 📈 Performance Optimizations

- **Lazy Loading**: Services initialized only when needed
- **Caching**: Intelligent caching with expiration
- **State Management**: Efficient provider usage
- **Image Optimization**: Proper image handling (when implemented)
- **Bundle Size**: Tree-shaking and code splitting

## 🧪 Testing Strategy

- **Unit Tests**: Test view models and services
- **Widget Tests**: Test individual UI components
- **Integration Tests**: Test complete user flows
- **Performance Tests**: Monitor app performance metrics

## 🚀 Future Enhancements

- [ ] Add offline support with local database
- [ ] Implement push notifications
- [ ] Add analytics and crash reporting
- [ ] Internationalization (i18n) support
- [ ] Add accessibility features
- [ ] Implement CI/CD pipeline

## 📞 Support

For any questions or issues with the refactored codebase, please refer to the code documentation or create an issue in the repository.

---

**Note**: This refactoring maintains all existing functionality while significantly improving code organization, maintainability, and scalability.
