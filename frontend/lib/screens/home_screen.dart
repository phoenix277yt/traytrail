import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/core.dart';

/// Home screen - main screen after login
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Dummy data for menu items with Indian food
  static final List<MenuItem> _menuItems = [
    MenuItem(
      id: '1',
      name: 'Chai',
      description: 'Aromatic spiced tea with milk and cardamom',
      calories: 120,
      healthLevel: HealthLevel.medium,
      ingredients: ['black tea', 'milk', 'cardamom', 'ginger', 'sugar'],
      allergens: ['dairy'],
    ),
    MenuItem(
      id: '2',
      name: 'Samosa',
      description: 'Crispy fried pastry filled with spiced potatoes',
      calories: 285,
      healthLevel: HealthLevel.high,
      ingredients: ['potatoes', 'flour', 'peas', 'cumin', 'coriander'],
      allergens: ['gluten'],
    ),
    MenuItem(
      id: '3',
      name: 'Dosa',
      description: 'Thin crispy crepe made from fermented rice batter',
      calories: 168,
      healthLevel: HealthLevel.low,
      ingredients: ['rice', 'lentils', 'fenugreek', 'salt'],
      allergens: [],
    ),
    MenuItem(
      id: '4',
      name: 'Biryani',
      description: 'Fragrant basmati rice with aromatic spices and meat',
      calories: 425,
      healthLevel: HealthLevel.high,
      ingredients: ['basmati rice', 'chicken', 'saffron', 'cardamom', 'bay leaves'],
      allergens: [],
    ),
    MenuItem(
      id: '5',
      name: 'Idli',
      description: 'Soft steamed rice cakes served with chutney',
      calories: 58,
      healthLevel: HealthLevel.low,
      ingredients: ['rice', 'lentils', 'salt'],
      allergens: [],
    ),
    MenuItem(
      id: '6',
      name: 'Butter Chicken',
      description: 'Tender chicken in rich creamy tomato curry',
      calories: 350,
      healthLevel: HealthLevel.medium,
      ingredients: ['chicken', 'tomatoes', 'cream', 'butter', 'spices'],
      allergens: ['dairy'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('TrayTrail'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to profile or logout
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              'Hello, Food Lover!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'What would you like to eat today?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            
            // Menu items grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75, // Make cards taller
                ),
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  return _MenuItemCard(
                    menuItem: _menuItems[index],
                    onTap: () => Navigator.pushNamed(context, '/meal_detail'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Menu item card widget
class _MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;
  final VoidCallback onTap;

  const _MenuItemCard({
    required this.menuItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Placeholder image with health indicator
              Stack(
                children: [
                  Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7E1D7), // Champagne Pink
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF8B7D7A), // Outline color
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Image',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: const Color(0xFF495867),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // Health level indicator
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: const Color(0xFF3AB795), // Mint color
                      child: Text(
                        menuItem.healthLevel.label[0], // First letter
                        style: GoogleFonts.roboto(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Item name in Zen Loop font
              Text(
                menuItem.name,
                style: GoogleFonts.zenLoop(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF495867), // Payne's Gray
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              
              // Description in Epilogue font
              Expanded(
                child: Text(
                  menuItem.description,
                  style: GoogleFonts.epilogue(
                    fontSize: 12,
                    color: const Color(0xFF495867), // Payne's Gray
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              
              // Calories info
              Text(
                '${menuItem.calories} cal',
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF495867).withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 12),
              
              // Tomato-colored "Add to Selections" button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${menuItem.name} added to selections'),
                        backgroundColor: const Color(0xFF3AB795), // Mint color
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE7252), // Tomato color
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    minimumSize: const Size(0, 32),
                  ),
                  child: const Text('Add to Selections'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
