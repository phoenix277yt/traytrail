/// Service for managing food tags - purely informational dietary and nutritional information
class FoodTagsService {
  static const Map<String, List<String>> _foodTags = {
    // Breakfast items
    'poha': ['vegetarian', 'light', 'gluten-free'],
    'upma': ['vegetarian', 'healthy'],
    'idli sambar': ['vegetarian', 'healthy', 'light'],
    'idli': ['vegetarian', 'healthy', 'light'],
    'sambar': ['vegetarian', 'protein-rich'],
    
    // Lunch items
    'rajma chawal': ['vegetarian', 'protein-rich', 'healthy'],
    'rajma': ['vegetarian', 'protein-rich'],
    'chawal': ['vegetarian', 'gluten-free'],
    'rice': ['vegetarian', 'gluten-free'],
    'chole bhature': ['vegetarian', 'spicy', 'protein-rich'],
    'chole': ['vegetarian', 'protein-rich', 'spicy'],
    'bhature': ['vegetarian'],
    'dal tadka': ['vegetarian', 'protein-rich', 'healthy'],
    'dal': ['vegetarian', 'protein-rich'],
    'roti': ['vegetarian'],
    'biryani': ['spicy', 'protein-rich'],
    'chicken biryani': ['non-vegetarian', 'spicy', 'protein-rich'],
    'veg biryani': ['vegetarian', 'spicy'],
    
    // Proteins
    'chicken': ['non-vegetarian', 'protein-rich'],
    'fish': ['non-vegetarian', 'protein-rich'],
    'eggs': ['non-vegetarian', 'protein-rich'],
    'paneer': ['vegetarian', 'protein-rich'],
    
    // Salads and light items
    'salad': ['healthy', 'light'],
    'grilled chicken salad': ['non-vegetarian', 'healthy', 'protein-rich', 'light'],
    'green salad': ['vegetarian', 'healthy', 'light'],
    
    // Beverages
    'lassi': ['vegetarian'],
    'buttermilk': ['vegetarian', 'light'],
    'juice': ['healthy'],
    
    // Snacks
    'samosa': ['vegetarian', 'spicy'],
    'pakora': ['vegetarian', 'spicy'],
    'sandwich': ['vegetarian'],
    'club sandwich': ['non-vegetarian'],
  };

  /// Get tags for a food item
  /// Returns a list of purely informational tags about dietary and nutritional properties
  static List<String> getTagsForFood(String foodName) {
    final normalizedName = foodName.toLowerCase().trim();
    
    // Direct match
    if (_foodTags.containsKey(normalizedName)) {
      return List<String>.from(_foodTags[normalizedName]!);
    }
    
    // Fuzzy matching for compound names
    final tags = <String>{};
    
    for (final entry in _foodTags.entries) {
      if (normalizedName.contains(entry.key) || entry.key.contains(normalizedName)) {
        tags.addAll(entry.value);
      }
    }
    
    // If no matches found, infer from keywords
    if (tags.isEmpty) {
      tags.addAll(_inferTagsFromKeywords(normalizedName));
    }
    
    return tags.toList();
  }

  /// Infer tags from common keywords in food names
  static List<String> _inferTagsFromKeywords(String foodName) {
    final tags = <String>[];
    final name = foodName.toLowerCase();
    
    // Dietary classifications
    if (name.contains('chicken') || name.contains('mutton') || name.contains('fish') || name.contains('egg')) {
      tags.add('non-vegetarian');
    } else {
      tags.add('vegetarian');
    }
    
    // Nutritional properties
    if (name.contains('dal') || name.contains('rajma') || name.contains('chole') || 
        name.contains('paneer') || name.contains('chicken') || name.contains('fish')) {
      tags.add('protein-rich');
    }
    
    if (name.contains('salad') || name.contains('soup') || name.contains('juice')) {
      tags.add('healthy');
      tags.add('light');
    }
    
    if (name.contains('spicy') || name.contains('masala') || name.contains('chili')) {
      tags.add('spicy');
    }
    
    if (name.contains('rice') || name.contains('chawal') || name.contains('quinoa')) {
      tags.add('gluten-free');
    }
    
    return tags;
  }

  /// Get all available tags for filtering or display purposes
  static List<String> getAllAvailableTags() {
    final allTags = <String>{};
    for (final tagList in _foodTags.values) {
      allTags.addAll(tagList);
    }
    return allTags.toList()..sort();
  }

  /// Check if a food item has a specific tag
  static bool hasTag(String foodName, String tag) {
    return getTagsForFood(foodName).contains(tag.toLowerCase());
  }

  /// Add custom tags for a food item (for dynamic content)
  static final Map<String, List<String>> _customTags = {};
  
  static void addCustomTags(String foodName, List<String> tags) {
    _customTags[foodName.toLowerCase()] = tags;
  }
  
  static List<String> getCustomTags(String foodName) {
    return _customTags[foodName.toLowerCase()] ?? [];
  }
}
