/// Service locator for dependency injection
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};

  /// Register a service
  void register<T>(T service) {
    _services[T] = service;
  }

  /// Register a singleton service
  void registerSingleton<T>(T Function() factory) {
    _services[T] = factory();
  }

  /// Register a lazy singleton service
  void registerLazySingleton<T>(T Function() factory) {
    _services[T] = factory;
  }

  /// Get a service
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service of type $T is not registered');
    }
    
    if (service is Function) {
      // Lazy initialization
      final instance = service();
      _services[T] = instance;
      return instance;
    }
    
    return service as T;
  }

  /// Check if a service is registered
  bool isRegistered<T>() {
    return _services.containsKey(T);
  }

  /// Remove a service
  void unregister<T>() {
    _services.remove(T);
  }

  /// Clear all services
  void clear() {
    _services.clear();
  }

  /// Initialize all services
  static Future<void> initialize() async {
    // Register core services here
    // final locator = ServiceLocator();
    
    // Example registrations:
    // locator.registerSingleton<ApiService>(() => ApiService());
    // locator.registerLazySingleton<DatabaseService>(() => DatabaseService());
    // locator.registerSingleton<CacheService>(() => CacheService());
  }
}
