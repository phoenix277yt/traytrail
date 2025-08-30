import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/state/providers/menu_provider_with_api.dart';
import '../core/api/api.dart';

/// Example widget demonstrating backend integration
/// This shows how to use the new API-enabled providers
class BackendIntegrationExample extends ConsumerStatefulWidget {
  const BackendIntegrationExample({super.key});

  @override
  ConsumerState<BackendIntegrationExample> createState() => _BackendIntegrationExampleState();
}

class _BackendIntegrationExampleState extends ConsumerState<BackendIntegrationExample> {
  final MenuApiService _menuApiService = MenuApiService();
  final ApiClient _apiClient = ApiClient();
  
  String _statusMessage = 'Checking backend status...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkBackendStatus();
  }

  Future<void> _checkBackendStatus() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Checking backend connection...';
    });

    try {
      final isHealthy = await _apiClient.checkHealth();
      if (isHealthy) {
        setState(() {
          _statusMessage = '✅ Backend is connected and healthy!';
        });
        await _testApiCalls();
      } else {
        setState(() {
          _statusMessage = '❌ Backend is not available. Using local data only.';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = '⚠️ Error connecting to backend: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testApiCalls() async {
    try {
      // Test menu API
      final menuItems = await _menuApiService.getMenuItems();
      setState(() {
        _statusMessage += '\n📋 Loaded ${menuItems.length} menu items from API';
      });

      // Test today's menu
      final todaysMenu = await _menuApiService.getTodaysMenu();
      if (todaysMenu != null) {
        setState(() {
          _statusMessage += '\n🍽️ Today\'s menu: ${todaysMenu.date}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage += '\n❌ API test failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProviderWithApi);
    final isBackendAvailable = ref.watch(backendAvailabilityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Integration Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              isBackendAvailable ? Icons.cloud_done : Icons.cloud_off,
              color: isBackendAvailable ? Colors.green : Colors.orange,
            ),
            onPressed: _checkBackendStatus,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Backend Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isBackendAvailable ? Icons.check_circle : Icons.error,
                          color: isBackendAvailable ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Backend Status',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      Text(
                        _statusMessage,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Menu State Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu State (from Provider)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (menuState.isLoading)
                      const Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Loading menu data...'),
                        ],
                      )
                    else ...[
                      _buildMenuInfo('Today\'s Menu', menuState.todaysMenu),
                      _buildMenuInfo('Tomorrow\'s Menu', menuState.tomorrowsMenu),
                      _buildInfoRow('Selected Category', menuState.selectedCategory),
                      _buildInfoRow('Favorite Items', '${menuState.favoriteItemIds.length}'),
                      if (menuState.lastUpdated != null)
                        _buildInfoRow('Last Updated', 
                          '${menuState.lastUpdated!.hour}:${menuState.lastUpdated!.minute.toString().padLeft(2, '0')}'),
                      if (menuState.errorMessage != null)
                        Text(
                          'Error: ${menuState.errorMessage}',
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => ref.read(menuProviderWithApi.notifier).refresh(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Menu'),
                ),
                ElevatedButton.icon(
                  onPressed: _checkBackendStatus,
                  icon: const Icon(Icons.cloud_sync),
                  label: const Text('Check Backend'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _testDirectApiCall(),
                  icon: const Icon(Icons.api),
                  label: const Text('Direct API Call'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuInfo(String title, dynamic menu) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              menu != null ? 'Available (${menu.date})' : 'Not available',
              style: TextStyle(
                color: menu != null ? Colors.green : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _testDirectApiCall() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Testing direct API call...')),
      );

      final menuItems = await _menuApiService.getMenuItems(category: 'lunch');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Direct API call successful! Found ${menuItems.length} lunch items'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Direct API call failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}