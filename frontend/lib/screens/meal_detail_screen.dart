import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Meal detail screen showing detailed information about a meal
class MealDetailScreen extends StatelessWidget {
  const MealDetailScreen({super.key});

  // TODO: Replace with actual API call to fetch calorie data from backend
  // This dummy data should be replaced with dynamic data fetching
  static const MealDetails _mealDetails = MealDetails(
    name: 'Samosa',
    description: 'Crispy golden triangular pastry filled with spiced potatoes, onions, and green peas. Deep-fried to perfection and served hot with mint and tamarind chutneys.',
    totalCalories: 285,
    nutritionBreakdown: [
      NutritionComponent(name: 'Pastry Shell', calories: 120),
      NutritionComponent(name: 'Potato Filling', calories: 85),
      NutritionComponent(name: 'Spices & Oil', calories: 50),
      NutritionComponent(name: 'Green Peas', calories: 20),
      NutritionComponent(name: 'Onions', calories: 10),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Meal Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large placeholder image at the top
            _MealImage(),
            
            // Meal information section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal name in Zen Loop font, Payne's Gray
                  Text(
                    _mealDetails.name,
                    style: GoogleFonts.zenLoop(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF495867), // Payne's Gray
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Description in Epilogue font, Payne's Gray
                  Text(
                    _mealDetails.description,
                    style: GoogleFonts.epilogue(
                      fontSize: 16,
                      height: 1.5,
                      color: const Color(0xFF495867), // Payne's Gray
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Total calories info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5F0), // Light mint background
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF3AB795), // Mint border
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Color(0xFFFE7252), // Tomato color
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Total Calories: ${_mealDetails.totalCalories}',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF495867),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Tomato-colored "Add to Selections" button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${_mealDetails.name} added to selections'),
                            backgroundColor: const Color(0xFF3AB795), // Mint color
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFE7252), // Tomato color
                        foregroundColor: Colors.white,
                        textStyle: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Add to Selections'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Nutrition Breakdown section
                  _NutritionBreakdownSection(
                    nutritionData: _mealDetails.nutritionBreakdown,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Large meal image widget
class _MealImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7E1D7), // Champagne Pink
        border: Border.all(
          color: const Color(0xFF8B7D7A), // Outline color
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: const Color(0xFF495867).withValues(alpha: 0.6),
            ),
            const SizedBox(height: 12),
            Text(
              'Meal Image',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF495867).withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Nutrition breakdown section widget
class _NutritionBreakdownSection extends StatelessWidget {
  final List<NutritionComponent> nutritionData;

  const _NutritionBreakdownSection({
    required this.nutritionData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'Nutrition Breakdown',
          style: GoogleFonts.zenLoop(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF495867), // Payne's Gray
          ),
        ),
        const SizedBox(height: 16),
        
        // Nutrition table
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF8B7D7A).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1),
            },
            children: [
              // Table header
              const TableRow(
                decoration: BoxDecoration(
                  color: Color(0xFFF7E1D7), // Champagne Pink
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                children: [
                  _TableCell(
                    text: 'Component',
                    isHeader: true,
                  ),
                  _TableCell(
                    text: 'Calories',
                    isHeader: true,
                  ),
                ],
              ),
              
              // Nutrition data rows
              ...nutritionData.map((component) => TableRow(
                children: [
                  _TableCell(text: component.name),
                  _TableCell(text: '${component.calories} cal'),
                ],
              )),
              
              // Total row
              TableRow(
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5F0), // Light mint background
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                children: [
                  const _TableCell(
                    text: 'Total',
                    isBold: true,
                  ),
                  _TableCell(
                    text: '${nutritionData.fold(0, (sum, component) => sum + component.calories)} cal',
                    isBold: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Table cell widget for nutrition breakdown
class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  final bool isBold;

  const _TableCell({
    required this.text,
    this.isHeader = false,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: isHeader ? 14 : 16,
          fontWeight: isHeader || isBold ? FontWeight.w600 : FontWeight.w400,
          color: const Color(0xFF495867), // Payne's Gray
        ),
      ),
    );
  }
}

/// Data model for meal details
class MealDetails {
  final String name;
  final String description;
  final int totalCalories;
  final List<NutritionComponent> nutritionBreakdown;

  const MealDetails({
    required this.name,
    required this.description,
    required this.totalCalories,
    required this.nutritionBreakdown,
  });
}

/// Data model for nutrition components
class NutritionComponent {
  final String name;
  final int calories;

  const NutritionComponent({
    required this.name,
    required this.calories,
  });
}
