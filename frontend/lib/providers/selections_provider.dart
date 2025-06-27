import 'package:flutter/foundation.dart';
import '../core/core.dart';

/// Provider class for managing meal selections state
class SelectionsProvider extends ChangeNotifier {
  final List<MealSelection> _selections = List.from(SampleData.mealSelections);

  /// Get all selections
  List<MealSelection> get selections => List.unmodifiable(_selections);

  /// Get total calories for all selections
  int get totalCalories {
    return _selections.fold(0, (total, selection) => total + selection.totalCalories);
  }

  /// Get total number of items
  int get totalItems {
    return _selections.fold(0, (total, selection) => total + selection.quantity);
  }

  /// Check if selections list is empty
  bool get isEmpty => _selections.isEmpty;

  /// Increase quantity of a meal selection
  void increaseQuantity(String id) {
    final index = _selections.indexWhere((selection) => selection.id == id);
    if (index != -1) {
      _selections[index].quantity++;
      notifyListeners();
    }
  }

  /// Decrease quantity of a meal selection
  void decreaseQuantity(String id) {
    final index = _selections.indexWhere((selection) => selection.id == id);
    if (index != -1 && _selections[index].quantity > 1) {
      _selections[index].quantity--;
      notifyListeners();
    }
  }

  /// Remove a meal selection completely
  void removeSelection(String id) {
    _selections.removeWhere((selection) => selection.id == id);
    notifyListeners();
  }

  /// Add a new meal selection
  void addSelection(MealSelection selection) {
    final existingIndex = _selections.indexWhere((s) => s.id == selection.id);
    if (existingIndex != -1) {
      // If item already exists, increase quantity
      _selections[existingIndex].quantity += selection.quantity;
    } else {
      // Add new item
      _selections.add(selection);
    }
    notifyListeners();
  }

  /// Clear all selections
  void clearSelections() {
    _selections.clear();
    notifyListeners();
  }

  /// Confirm selections (for demo purposes)
  void confirmSelections() {
    // TODO: Implement actual order confirmation logic
    // This could involve API calls to submit the order
    notifyListeners();
  }
}
