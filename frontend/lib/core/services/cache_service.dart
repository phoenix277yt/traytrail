import 'dart:convert';
import '../config/app_config.dart';
import '../services/logging_service.dart';

/// Cache entry wrapper
class CacheEntry<T> {
  final T data;
  final DateTime timestamp;
  final Duration? expiry;

  CacheEntry(this.data, {this.expiry}) : timestamp = DateTime.now();

  bool get isExpired {
    if (expiry == null) return false;
    return DateTime.now().difference(timestamp) > expiry!;
  }
}

/// In-memory cache service
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  final Map<String, CacheEntry> _cache = {};
  static const Duration _defaultExpiry = AppConfig.cacheExpiry;
  static const int _maxCacheSize = AppConfig.maxCacheSize;

  /// Store data in cache
  void put<T>(String key, T data, {Duration? expiry}) {
    // Clean expired entries if cache is getting full
    if (_cache.length >= _maxCacheSize) {
      _cleanExpired();
      
      // If still at capacity, remove oldest entry
      if (_cache.length >= _maxCacheSize) {
        final oldestKey = _cache.keys.first;
        _cache.remove(oldestKey);
        LoggingService.debug('Cache: Removed oldest entry $oldestKey');
      }
    }

    _cache[key] = CacheEntry(data, expiry: expiry ?? _defaultExpiry);
    LoggingService.debug('Cache: Stored $key');
  }

  /// Get data from cache
  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) {
      LoggingService.debug('Cache: Miss for $key');
      return null;
    }

    if (entry.isExpired) {
      _cache.remove(key);
      LoggingService.debug('Cache: Expired entry removed for $key');
      return null;
    }

    LoggingService.debug('Cache: Hit for $key');
    return entry.data as T?;
  }

  /// Check if key exists and is not expired
  bool contains(String key) {
    final entry = _cache[key];
    if (entry == null) return false;
    
    if (entry.isExpired) {
      _cache.remove(key);
      return false;
    }
    
    return true;
  }

  /// Remove specific entry
  void remove(String key) {
    if (_cache.remove(key) != null) {
      LoggingService.debug('Cache: Removed $key');
    }
  }

  /// Clear all cache
  void clear() {
    final count = _cache.length;
    _cache.clear();
    LoggingService.debug('Cache: Cleared $count entries');
  }

  /// Clean expired entries
  void _cleanExpired() {
    final expiredKeys = _cache.entries
        .where((entry) => entry.value.isExpired)
        .map((entry) => entry.key)
        .toList();

    for (final key in expiredKeys) {
      _cache.remove(key);
    }

    if (expiredKeys.isNotEmpty) {
      LoggingService.debug('Cache: Cleaned ${expiredKeys.length} expired entries');
    }
  }

  /// Get cache statistics
  Map<String, dynamic> getStats() {
    _cleanExpired();
    return {
      'size': _cache.length,
      'maxSize': _maxCacheSize,
      'hitRate': 0.0, // Would need to track hits/misses for accurate rate
    };
  }

  /// Store JSON serializable data
  void putJson(String key, Map<String, dynamic> data, {Duration? expiry}) {
    final jsonString = jsonEncode(data);
    put(key, jsonString, expiry: expiry);
  }

  /// Get JSON data
  Map<String, dynamic>? getJson(String key) {
    final jsonString = get<String>(key);
    if (jsonString == null) return null;
    
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      LoggingService.error('Cache: Failed to decode JSON for $key', e);
      remove(key); // Remove corrupted entry
      return null;
    }
  }

  /// Store list data
  void putList<T>(String key, List<T> data, {Duration? expiry}) {
    put(key, data, expiry: expiry);
  }

  /// Get list data
  List<T>? getList<T>(String key) {
    final data = get<List<dynamic>>(key);
    return data?.cast<T>();
  }

  /// Cache with fallback - get from cache or execute function and cache result
  Future<T> getOrPut<T>(
    String key,
    Future<T> Function() fallback, {
    Duration? expiry,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cachedData = get<T>(key);
      if (cachedData != null) {
        return cachedData;
      }
    }

    final data = await fallback();
    put(key, data, expiry: expiry);
    return data;
  }

  /// Invalidate entries by prefix
  void invalidateByPrefix(String prefix) {
    final keysToRemove = _cache.keys
        .where((key) => key.startsWith(prefix))
        .toList();

    for (final key in keysToRemove) {
      _cache.remove(key);
    }

    LoggingService.debug('Cache: Invalidated ${keysToRemove.length} entries with prefix $prefix');
  }
}
