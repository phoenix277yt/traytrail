import 'package:flutter/material.dart';

/// Base class for all view models
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get hasError => _errorMessage != null;

  /// Set loading state
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Set error message
  void setError(String? error) {
    if (_errorMessage != error) {
      _errorMessage = error;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    setError(null);
  }

  /// Execute an async operation with loading state management
  Future<T?> executeWithLoading<T>(Future<T> Function() operation) async {
    try {
      setLoading(true);
      clearError();
      return await operation();
    } catch (e) {
      setError(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Execute an async operation without loading state
  Future<T?> executeWithErrorHandling<T>(Future<T> Function() operation) async {
    try {
      clearError();
      return await operation();
    } catch (e) {
      setError(e.toString());
      return null;
    }
  }
}

/// Mixin for pagination functionality
mixin PaginationMixin<T> on BaseViewModel {
  List<T> _items = [];
  List<T> get items => _items;

  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  /// Reset pagination
  void resetPagination() {
    _items.clear();
    _currentPage = 0;
    _hasMoreData = true;
    _isLoadingMore = false;
    notifyListeners();
  }

  /// Load initial data
  Future<void> loadInitialData(Future<List<T>> Function() loadData) async {
    resetPagination();
    await executeWithLoading(() async {
      final data = await loadData();
      _items.addAll(data);
      _currentPage = 1;
      return data;
    });
  }

  /// Load more data
  Future<void> loadMoreData(Future<List<T>> Function(int page) loadData) async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final data = await loadData(_currentPage + 1);
      if (data.isEmpty) {
        _hasMoreData = false;
      } else {
        _items.addAll(data);
        _currentPage++;
      }
    } catch (e) {
      setError(e.toString());
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}

/// Mixin for search functionality
mixin SearchMixin<T> on BaseViewModel {
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<T> _searchResults = [];
  List<T> get searchResults => _searchResults;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  /// Update search query
  void updateSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  /// Perform search
  Future<void> search(Future<List<T>> Function(String query) searchFunction) async {
    if (_searchQuery.isEmpty) {
      _searchResults.clear();
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      final results = await searchFunction(_searchQuery);
      _searchResults = results;
    } catch (e) {
      setError(e.toString());
      _searchResults.clear();
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Clear search
  void clearSearch() {
    _searchQuery = '';
    _searchResults.clear();
    _isSearching = false;
    notifyListeners();
  }
}
