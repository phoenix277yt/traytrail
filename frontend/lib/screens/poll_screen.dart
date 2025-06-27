import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Poll screen for user polls and surveys
class PollScreen extends StatefulWidget {
  const PollScreen({super.key});

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  // Track the selected meal option
  String? _selectedMeal;

  // List of meal options for the poll
  final List<MealOption> _mealOptions = [
    const MealOption(
      id: 'dosa',
      name: 'Dosa',
      description: 'Crispy South Indian crepe with chutney',
    ),
    const MealOption(
      id: 'vada',
      name: 'Vada',
      description: 'Deep-fried savory doughnut with sambar',
    ),
    const MealOption(
      id: 'uttapam',
      name: 'Uttapam',
      description: 'Thick pancake topped with vegetables',
    ),
    const MealOption(
      id: 'upma',
      name: 'Upma',
      description: 'Savory porridge made from semolina',
    ),
  ];

  /// Handle meal selection
  void _onMealSelected(String? mealId) {
    setState(() {
      _selectedMeal = mealId;
    });
  }

  /// Handle submit button press
  void _submitVote() {
    if (_selectedMeal != null) {
      final selectedMealName = _mealOptions
          .firstWhere((meal) => meal.id == _selectedMeal)
          .name;
      
      // Show success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vote recorded for $selectedMealName'),
          backgroundColor: const Color(0xFF3AB795), // Mint color for success
          duration: const Duration(seconds: 2),
        ),
      );

      // Reset selection after voting (optional)
      setState(() {
        _selectedMeal = null;
      });
    } else {
      // Show error if no option selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a meal option'),
          backgroundColor: Color(0xFFBA1A1A), // Error color
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Poll'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Poll title and description
            Text(
              'What\'s Your Favorite?',
              style: GoogleFonts.zenLoop(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF495867), // Payne's Gray
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Vote for your favorite South Indian breakfast item. Your choice helps us decide what to feature next!',
              style: GoogleFonts.epilogue(
                fontSize: 16,
                color: const Color(0xFF495867).withValues(alpha: 0.8),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Poll question
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
                    Icons.poll,
                    color: Color(0xFF3AB795), // Mint color
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Which breakfast item should we feature this week?',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF495867),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Meal options with radio buttons
            Expanded(
              child: _MealOptionsList(
                mealOptions: _mealOptions,
                selectedMeal: _selectedMeal,
                onMealSelected: _onMealSelected,
              ),
            ),
            
            // Submit button
            const SizedBox(height: 24),
            _SubmitButton(
              onPressed: _submitVote,
              hasSelection: _selectedMeal != null,
            ),
          ],
        ),
      ),
    );
  }
}

/// List of meal options with radio buttons
class _MealOptionsList extends StatelessWidget {
  final List<MealOption> mealOptions;
  final String? selectedMeal;
  final ValueChanged<String?> onMealSelected;

  const _MealOptionsList({
    required this.mealOptions,
    required this.selectedMeal,
    required this.onMealSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: mealOptions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final meal = mealOptions[index];
        return _MealOptionCard(
          meal: meal,
          isSelected: selectedMeal == meal.id,
          onSelected: () => onMealSelected(meal.id),
        );
      },
    );
  }
}

/// Individual meal option card with radio button
class _MealOptionCard extends StatelessWidget {
  final MealOption meal;
  final bool isSelected;
  final VoidCallback onSelected;

  const _MealOptionCard({
    required this.meal,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected 
              ? const Color(0xFFFE7252) // Tomato border when selected
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onSelected,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Radio button
              Radio<String>(
                value: meal.id,
                groupValue: isSelected ? meal.id : null,
                onChanged: (_) => onSelected(),
                activeColor: const Color(0xFFFE7252), // Tomato color
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 12),
              
              // Meal information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: GoogleFonts.zenLoop(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF495867), // Payne's Gray
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meal.description,
                      style: GoogleFonts.epilogue(
                        fontSize: 14,
                        color: const Color(0xFF495867).withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Selection indicator
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFE7252), // Tomato color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Submit button widget
class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool hasSelection;

  const _SubmitButton({
    required this.onPressed,
    required this.hasSelection,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: hasSelection 
              ? const Color(0xFFFE7252) // Tomato color when enabled
              : Colors.grey.shade400, // Gray when disabled
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: hasSelection ? 2 : 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.how_to_vote,
              size: 20,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text('Submit Vote'),
          ],
        ),
      ),
    );
  }
}

/// Data model for meal options
class MealOption {
  final String id;
  final String name;
  final String description;

  const MealOption({
    required this.id,
    required this.name,
    required this.description,
  });
}
