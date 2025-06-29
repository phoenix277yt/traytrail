# TrayTrail Frontend

A beautiful Material 3 Flutter application with expressive theming.

## Features

- **Material 3 Design**: Utilizes the latest Material Design 3 components and theming
- **Expressive Theming**: Dynamic color schemes with light and dark mode support
- **Modern Navigation**: Bottom navigation bar with multiple views
- **Responsive Layout**: Adaptive UI components that work across different screen sizes
- **Clean Architecture**: Well-structured code with separation of concerns

## Pages

- **Home**: Welcome screen with quick actions and recent activity
- **Explore**: Discovery and exploration features (placeholder)
- **Profile**: User profile and settings (placeholder)

## Material 3 Components Used

- `NavigationBar` - Modern bottom navigation
- `SliverAppBar.large` - Large collapsing app bar
- `FilledButton` - Primary action buttons
- `Card` - Content containers with elevation
- `FloatingActionButton.extended` - Extended FAB with label
- Dynamic color schemes with `ColorScheme.fromSeed()`

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio with Android SDK
- **Android NDK 27.0.12077973** (configured in build.gradle.kts)
- iOS development tools (for iOS builds)

### Android Configuration

This project is configured to use Android NDK 27.0.12077973 to ensure compatibility with all dependencies, particularly `shared_preferences_android`. The NDK version is specified in `/android/app/build.gradle.kts`:

```kotlin
android {
    ndkVersion = "27.0.12077973"
}
```

### Installation

- Flutter SDK (latest stable version)
- Dart SDK
- Chrome/Edge browser (for web development)
- Android Studio/VS Code with Flutter extensions

### Installation

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

   Or for web development:
   ```bash
   flutter run -d chrome
   ```

## Project Structure

```
lib/
├── main.dart          # Main app entry point with Material 3 theming
└── (additional files as the project grows)
```

## Theming

The app uses Material 3's dynamic theming system with:
- Primary seed color: `#6750A4` (Material 3 purple)
- Dynamic color generation for light and dark themes
- System theme mode detection
- Typography based on Material 2021 type scale

## Development

This is a blank Material 3 template ready for further development. You can:

1. Add new pages by creating new widget classes
2. Implement navigation between pages
3. Add state management (Provider, Riverpod, Bloc, etc.)
4. Integrate with backend APIs
5. Add more Material 3 components as needed

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Material 3 Design](https://m3.material.io/)
- [Flutter Material 3 Components](https://docs.flutter.dev/ui/widgets/material)
