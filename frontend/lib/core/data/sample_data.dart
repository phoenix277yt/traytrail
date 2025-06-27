import '../models/menu_item.dart';
import '../models/meal_selection.dart';

/// Sample data for development and testing
class SampleData {
  SampleData._();

  /// Sample menu items with Indian food
  static final List<MenuItem> menuItems = [
    MenuItem(
      id: 'chai_001',
      name: 'Chai',
      description: 'Aromatic spiced tea with milk and cardamom',
      calories: 120,
      healthLevel: HealthLevel.medium,
      price: 25.0,
      ingredients: ['Tea leaves', 'Milk', 'Sugar', 'Cardamom', 'Ginger'],
      allergens: ['Dairy'],
    ),
    MenuItem(
      id: 'samosa_001',
      name: 'Samosa',
      description: 'Crispy fried pastry filled with spiced potatoes',
      calories: 285,
      healthLevel: HealthLevel.high,
      price: 40.0,
      ingredients: ['Wheat flour', 'Potatoes', 'Onions', 'Spices', 'Oil'],
      allergens: ['Gluten'],
    ),
    MenuItem(
      id: 'dosa_001',
      name: 'Dosa',
      description: 'Thin crispy crepe made from fermented rice batter',
      calories: 168,
      healthLevel: HealthLevel.low,
      price: 60.0,
      ingredients: ['Rice', 'Urad dal', 'Fenugreek seeds', 'Salt'],
      allergens: [],
    ),
    MenuItem(
      id: 'biryani_001',
      name: 'Biryani',
      description: 'Fragrant basmati rice with aromatic spices and meat',
      calories: 425,
      healthLevel: HealthLevel.high,
      price: 150.0,
      ingredients: ['Basmati rice', 'Chicken', 'Onions', 'Yogurt', 'Spices'],
      allergens: ['Dairy'],
    ),
    MenuItem(
      id: 'idli_001',
      name: 'Idli',
      description: 'Soft steamed rice cakes served with chutney',
      calories: 58,
      healthLevel: HealthLevel.low,
      price: 35.0,
      ingredients: ['Rice', 'Urad dal', 'Salt'],
      allergens: [],
    ),
    MenuItem(
      id: 'butter_chicken_001',
      name: 'Butter Chicken',
      description: 'Tender chicken in rich creamy tomato curry',
      calories: 350,
      healthLevel: HealthLevel.medium,
      price: 180.0,
      ingredients: ['Chicken', 'Tomatoes', 'Cream', 'Butter', 'Spices'],
      allergens: ['Dairy'],
    ),
  ];

  /// Sample meal selections for the provider
  static final List<MealSelection> mealSelections = [
    MealSelection(
      id: 'idli_001',
      name: 'Idli',
      caloriesPerItem: 58,
      quantity: 2,
    ),
    MealSelection(
      id: 'samosa_001',
      name: 'Samosa',
      caloriesPerItem: 285,
      quantity: 1,
    ),
  ];

  /// Sample poll options
  static const List<String> pollOptions = [
    'Dosa',
    'Vada',
    'Uttapam',
    'Upma',
  ];

  /// Sample poll question
  static const String pollQuestion = 'What would you like for breakfast tomorrow?';

  /// Sample user roles
  static const List<String> userRoles = [
    'student',
    'parent',
    'teacher',
    'staff',
  ];

  /// Sample feedback ratings
  static const List<String> feedbackRatings = [
    'Poor - We need to improve',
    'Fair - Below expectations', 
    'Good - Meets expectations',
    'Very Good - Above expectations',
    'Excellent - Outstanding experience!',
  ];
}
