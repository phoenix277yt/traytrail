/// Model for a meal item in selections
class MealSelection {
  final String id;
  final String name;
  final int caloriesPerItem;
  int quantity;

  MealSelection({
    required this.id,
    required this.name,
    required this.caloriesPerItem,
    this.quantity = 1,
  });

  /// Get total calories for this selection
  int get totalCalories => caloriesPerItem * quantity;

  /// Create a copy with updated quantity
  MealSelection copyWith({int? quantity}) {
    return MealSelection(
      id: id,
      name: name,
      caloriesPerItem: caloriesPerItem,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'caloriesPerItem': caloriesPerItem,
      'quantity': quantity,
    };
  }

  /// Create from JSON
  factory MealSelection.fromJson(Map<String, dynamic> json) {
    return MealSelection(
      id: json['id'] as String,
      name: json['name'] as String,
      caloriesPerItem: json['caloriesPerItem'] as int,
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  @override
  String toString() {
    return 'MealSelection(id: $id, name: $name, caloriesPerItem: $caloriesPerItem, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MealSelection &&
        other.id == id &&
        other.name == name &&
        other.caloriesPerItem == caloriesPerItem &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        caloriesPerItem.hashCode ^
        quantity.hashCode;
  }
}
