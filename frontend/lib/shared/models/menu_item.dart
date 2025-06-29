/// Model for menu items
class MenuItem {
  final String id;
  final String name;
  final String description;
  final String category; // 'breakfast', 'lunch', 'dinner'
  final int calories;
  final double price;
  final bool isAvailable;
  final List<String> tags; // informational tags like 'vegetarian', 'healthy', 'protein-rich', etc.
  final String iconName;
  final DateTime availableFrom;
  final DateTime availableTo;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.calories,
    required this.price,
    required this.isAvailable,
    this.tags = const [],
    required this.iconName,
    required this.availableFrom,
    required this.availableTo,
  });

  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    int? calories,
    double? price,
    bool? isAvailable,
    List<String>? tags,
    String? iconName,
    DateTime? availableFrom,
    DateTime? availableTo,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      calories: calories ?? this.calories,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
      tags: tags ?? this.tags,
      iconName: iconName ?? this.iconName,
      availableFrom: availableFrom ?? this.availableFrom,
      availableTo: availableTo ?? this.availableTo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'calories': calories,
      'price': price,
      'isAvailable': isAvailable,
      'tags': tags,
      'iconName': iconName,
      'availableFrom': availableFrom.toIso8601String(),
      'availableTo': availableTo.toIso8601String(),
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      calories: json['calories'] as int,
      price: json['price'] as double,
      isAvailable: json['isAvailable'] as bool,
      tags: List<String>.from(json['tags'] ?? []),
      iconName: json['iconName'] as String,
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableTo: DateTime.parse(json['availableTo'] as String),
    );
  }

  @override
  String toString() {
    return 'MenuItem(id: $id, name: $name, category: $category, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
