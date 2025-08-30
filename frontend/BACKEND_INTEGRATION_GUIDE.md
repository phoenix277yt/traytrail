# Backend Integration Guide

This document explains how the TrayTrail Flutter app integrates with the Rust backend API while maintaining local persistence as a fallback.

## Architecture Overview

### Hybrid State Management
The app uses a hybrid approach that combines:
- **Backend API**: Primary data source when available
- **Local Persistence**: Fallback and caching mechanism
- **Graceful Degradation**: App works offline with cached data

### Key Components

#### 1. API Layer (`lib/core/api/`)
- `ApiClient`: Dio-based HTTP client with error handling
- `ApiModels`: Data models that mirror backend responses
- Service classes: Type-safe API endpoints for each feature
  - `MenuApiService`: Menu and daily menu operations
  - `PollApiService`: Poll creation and voting
  - `FeedbackApiService`: Feedback submission and retrieval
  - `UserApiService`: User preferences and account management

#### 2. Enhanced State Providers
- Existing providers enhanced with backend integration
- Automatic fallback to local persistence
- Background sync when backend becomes available
- Example: `MenuNotifierWithApi` in `menu_provider_with_api.dart`

#### 3. Data Flow

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Flutter UI    │◄──►│  State Provider  │◄──►│ Local Storage   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌──────────────────┐
                       │   Backend API    │
                       └──────────────────┘
```

## Implementation Details

### Backend Health Checking
```dart
final ApiClient _apiClient = ApiClient();
bool _isBackendAvailable = await _apiClient.checkHealth();
```

### Hybrid Data Loading
1. **Immediate**: Load from local storage for instant UI
2. **Background**: Check backend availability
3. **Sync**: If backend available, fetch latest data
4. **Update**: Update UI and persist new data locally

### Error Handling
- Network errors don't break the app
- Fallback to cached data when API fails
- User-friendly error messages
- Automatic retry mechanisms

## Configuration

### Development vs Production
```dart
static const String _baseUrl = kDebugMode 
    ? 'http://localhost:3000/api'  // Development
    : 'https://api.traytrail.com/api';  // Production
```

### Backend URLs
- **Development**: `http://localhost:3000`
- **Production**: To be configured with actual deployment URL

## Usage Examples

### Basic Usage with Automatic Fallback
```dart
class MenuScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuState = ref.watch(menuProviderWithApi);
    final isBackendAvailable = ref.watch(backendAvailabilityProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: [
          if (!isBackendAvailable)
            Icon(Icons.cloud_off, color: Colors.orange),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => ref.read(menuProviderWithApi.notifier).refresh(),
          ),
        ],
      ),
      body: menuState.isLoading 
        ? CircularProgressIndicator()
        : _buildMenuContent(menuState),
    );
  }
}
```

### Manual API Calls
```dart
// For advanced use cases requiring direct API access
final menuApiService = MenuApiService();
try {
  final menuItems = await menuApiService.getMenuItems(category: 'lunch');
  // Handle success
} on ApiException catch (e) {
  if (e.isNetworkError) {
    // Handle network error
  } else if (e.isServerError) {
    // Handle server error
  }
}
```

### Voting Example
```dart
final pollService = PollApiService();
try {
  await pollService.votePoll(
    pollId: 'poll-123',
    optionId: 'option-456',
    userId: currentUserId,
  );
  // Update UI to reflect vote
} on ApiException catch (e) {
  // Show error message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Failed to vote: ${e.message}')),
  );
}
```

## Testing Strategy

### Local Development
1. **Backend Running**: Full integration testing
2. **Backend Stopped**: Offline mode testing
3. **Network Simulation**: Test various network conditions

### Testing Scenarios
- ✅ Fresh app start (no local data)
- ✅ Offline mode with cached data
- ✅ Network interruption during API calls
- ✅ Backend API changes/versioning
- ✅ Invalid API responses

## Migration Strategy

### Phase 1: Parallel Operation ✅
- New API providers alongside existing ones
- No breaking changes to existing UI
- Feature flag for enabling backend integration

### Phase 2: Gradual Migration
- Replace existing providers screen by screen
- Extensive testing with backend integration
- Monitor performance and error rates

### Phase 3: Backend-First
- Backend becomes primary data source
- Local storage as cache only
- Remove redundant local-only code

## Backend Requirements

### API Endpoints Status
- ✅ `/health` - Health check
- ⏳ `/menu-items` - Menu item CRUD
- ⏳ `/menus` - Daily menu management
- ⏳ `/polls` - Poll creation and voting
- ⏳ `/feedback` - Feedback system
- ⏳ `/users/preferences` - User settings

### Required Features
- CORS configuration for Flutter web
- JSON API responses matching Flutter models
- Error handling with appropriate HTTP status codes
- Rate limiting and security measures

## Deployment Considerations

### Environment Configuration
```dart
// TODO: Use flutter_dotenv for environment variables
const bool useBackend = bool.fromEnvironment('USE_BACKEND', defaultValue: true);
const String backendUrl = String.fromEnvironment('BACKEND_URL', defaultValue: 'http://localhost:3000');
```

### Monitoring
- API response times
- Error rates by endpoint
- Offline usage patterns
- Data sync success rates

## Security Notes

⚠️ **Important Security Considerations**:
- No authentication implemented yet (planned)
- API client ready for JWT tokens
- Sensitive data should not be cached locally
- HTTPS required for production
- Input validation on both client and server

## Troubleshooting

### Common Issues

1. **Backend Not Available**
   - Check if backend server is running on port 3000
   - Verify CORS configuration
   - Check network connectivity

2. **API Errors**
   - Check browser dev tools for network errors
   - Verify API endpoint URLs match backend routes
   - Check request/response format

3. **Data Sync Issues**
   - Clear local storage: `await StatePersistence.clearAll()`
   - Force refresh: `ref.read(menuProviderWithApi.notifier).refresh()`
   - Check data model compatibility

### Debug Mode
```dart
// Enable detailed API logging
if (kDebugMode) {
  _dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));
}
```

This integration provides a robust foundation for transitioning from a local-only app to a full-featured client-server application while maintaining excellent user experience even when offline.