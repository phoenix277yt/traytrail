import 'api_client.dart';
import 'api_models.dart';

/// Menu API service for backend integration
class MenuApiService {
  final ApiClient _client = ApiClient();

  /// Get all menu items with optional filtering
  Future<List<ApiMenuItem>> getMenuItems({
    String? category,
    bool? availableOnly,
  }) async {
    return _client.handleListResponse(
      _client.dio.get('/menu-items', queryParameters: {
        if (category != null) 'category': category,
        if (availableOnly != null) 'available_only': availableOnly,
      }),
      ApiMenuItem.fromJson,
    );
  }

  /// Create a new menu item
  Future<ApiMenuItem> createMenuItem(Map<String, dynamic> data) async {
    return _client.handleResponse(
      _client.dio.post('/menu-items', data: data),
      ApiMenuItem.fromJson,
    );
  }

  /// Get daily menus with optional date filtering
  Future<List<ApiDailyMenu>> getDailyMenus({String? date}) async {
    return _client.handleListResponse(
      _client.dio.get('/menus', queryParameters: {
        if (date != null) 'date': date,
      }),
      ApiDailyMenu.fromJson,
    );
  }

  /// Get a specific daily menu by ID
  Future<ApiDailyMenu> getDailyMenuById(String id) async {
    return _client.handleResponse(
      _client.dio.get('/menus/$id'),
      ApiDailyMenu.fromJson,
    );
  }

  /// Create a new daily menu
  Future<ApiDailyMenu> createDailyMenu(Map<String, dynamic> data) async {
    return _client.handleResponse(
      _client.dio.post('/menus', data: data),
      ApiDailyMenu.fromJson,
    );
  }

  /// Get today's menu
  Future<ApiDailyMenu?> getTodaysMenu() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final menus = await getDailyMenus(date: today);
      return menus.isNotEmpty ? menus.first : null;
    } catch (e) {
      return null;
    }
  }

  /// Get tomorrow's menu
  Future<ApiDailyMenu?> getTomorrowsMenu() async {
    try {
      final tomorrow = DateTime.now()
          .add(const Duration(days: 1))
          .toIso8601String()
          .split('T')[0];
      final menus = await getDailyMenus(date: tomorrow);
      return menus.isNotEmpty ? menus.first : null;
    } catch (e) {
      return null;
    }
  }
}