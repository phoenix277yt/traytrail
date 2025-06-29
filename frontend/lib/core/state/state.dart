/// Core state management models and providers
/// 
/// This file exports all state management related components including:
/// - State models (data structures)
/// - State providers (Riverpod providers)
/// - State notifiers (complex state management)
/// - State persistence (local storage)
library;

// Core Models
export 'models/app_state.dart';
export 'models/poll_state.dart';
export 'models/menu_state.dart';
export 'models/feedback_state.dart';
export 'models/user_preferences.dart';

// State Providers
export 'providers/app_state_provider.dart';
export 'providers/poll_provider.dart';
export 'providers/menu_provider.dart';
export 'providers/feedback_provider.dart';
export 'providers/user_preferences_provider.dart';

// Persistence
export 'persistence/state_persistence.dart';
