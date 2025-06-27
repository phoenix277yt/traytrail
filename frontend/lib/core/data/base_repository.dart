/// Base repository interface
abstract class BaseRepository<T, ID> {
  /// Get all items
  Future<List<T>> getAll();
  
  /// Get item by ID
  Future<T?> getById(ID id);
  
  /// Create new item
  Future<T> create(T item);
  
  /// Update existing item
  Future<T> update(T item);
  
  /// Delete item by ID
  Future<bool> delete(ID id);
  
  /// Search items
  Future<List<T>> search(String query);
  
  /// Get paginated items
  Future<List<T>> getPaginated(int page, int limit);
}

/// Repository exception
class RepositoryException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const RepositoryException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'RepositoryException: $message';
}

/// Repository result wrapper
class RepositoryResult<T> {
  final T? data;
  final bool success;
  final String? error;
  final String? errorCode;

  const RepositoryResult._({
    this.data,
    required this.success,
    this.error,
    this.errorCode,
  });

  factory RepositoryResult.success(T data) {
    return RepositoryResult._(
      data: data,
      success: true,
    );
  }

  factory RepositoryResult.failure(String error, {String? errorCode}) {
    return RepositoryResult._(
      success: false,
      error: error,
      errorCode: errorCode,
    );
  }

  /// Map the result data to another type
  RepositoryResult<U> map<U>(U Function(T) mapper) {
    if (success && data != null) {
      return RepositoryResult.success(mapper(data!));
    }
    return RepositoryResult.failure(error ?? 'Unknown error', errorCode: errorCode);
  }

  /// Execute a function on success
  RepositoryResult<T> onSuccess(void Function(T) callback) {
    if (success && data != null) {
      callback(data!);
    }
    return this;
  }

  /// Execute a function on failure
  RepositoryResult<T> onFailure(void Function(String) callback) {
    if (!success && error != null) {
      callback(error!);
    }
    return this;
  }
}
