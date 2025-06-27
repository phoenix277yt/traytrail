import 'package:flutter/material.dart';

/// Data model for menu items
class MenuItem {
  final String id;
  final String name;
  final String description;
  final int calories;
  final HealthLevel healthLevel;
  final String? imageUrl;
  final double? price;
  final List<String> ingredients;
  final List<String> allergens;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.calories,
    required this.healthLevel,
    this.imageUrl,
    this.price,
    this.ingredients = const [],
    this.allergens = const [],
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'calories': calories,
      'healthLevel': healthLevel.name,
      'imageUrl': imageUrl,
      'price': price,
      'ingredients': ingredients,
      'allergens': allergens,
    };
  }

  /// Create from JSON
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      calories: json['calories'] as int,
      healthLevel: HealthLevel.values.firstWhere(
        (e) => e.name == json['healthLevel'],
        orElse: () => HealthLevel.medium,
      ),
      imageUrl: json['imageUrl'] as String?,
      price: json['price'] as double?,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return 'MenuItem(id: $id, name: $name, calories: $calories, healthLevel: $healthLevel)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Health level enum
enum HealthLevel {
  low,
  medium,
  high;

  String get label {
    switch (this) {
      case HealthLevel.low:
        return 'Low';
      case HealthLevel.medium:
        return 'Medium';
      case HealthLevel.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case HealthLevel.low:
        return const Color(0xFF3AB795); // Mint color
      case HealthLevel.medium:
        return const Color(0xFFFE7252); // Tomato color
      case HealthLevel.high:
        return const Color(0xFFBA1A1A); // Red color
    }
  }

  IconData get icon {
    switch (this) {
      case HealthLevel.low:
        return Icons.eco; // Environment-friendly
      case HealthLevel.medium:
        return Icons.warning; // Moderate warning
      case HealthLevel.high:
        return Icons.error; // High warning
    }
  }
}
