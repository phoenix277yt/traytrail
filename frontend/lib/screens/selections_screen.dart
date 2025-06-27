import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/core.dart';
import '../providers/selections_provider.dart';

/// Selections screen for meal selections
class SelectionsScreen extends StatelessWidget {
  const SelectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('My Selections'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<SelectionsProvider>(
        builder: (context, selectionsProvider, child) {
          if (selectionsProvider.isEmpty) {
            return _EmptySelectionsView();
          }

          return Column(
            children: [
              // Selections list
              Expanded(
                child: _SelectionsList(
                  selections: selectionsProvider.selections,
                ),
              ),
              
              // Bottom section with total and confirm button
              _BottomSection(
                totalCalories: selectionsProvider.totalCalories,
                totalItems: selectionsProvider.totalItems,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Empty state view when no selections
class _EmptySelectionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 80,
              color: const Color(0xFF495867).withValues(alpha: 0.4),
            ),
            const SizedBox(height: 24),
            Text(
              'No Selections Yet',
              style: GoogleFonts.zenLoop(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF495867),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add some delicious meals to your selections from the home screen.',
              style: GoogleFonts.epilogue(
                fontSize: 16,
                color: const Color(0xFF495867).withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFE7252), // Tomato color
                foregroundColor: Colors.white,
                textStyle: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Browse Meals'),
            ),
          ],
        ),
      ),
    );
  }
}

/// List of meal selections
class _SelectionsList extends StatelessWidget {
  final List<MealSelection> selections;

  const _SelectionsList({
    required this.selections,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: selections.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _SelectionItem(
          selection: selections[index],
        );
      },
    );
  }
}

/// Individual selection item card
class _SelectionItem extends StatelessWidget {
  final MealSelection selection;

  const _SelectionItem({
    required this.selection,
  });

  @override
  Widget build(BuildContext context) {
    final selectionsProvider = Provider.of<SelectionsProvider>(context, listen: false);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal name and remove button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selection.name,
                    style: GoogleFonts.zenLoop(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF495867), // Payne's Gray
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => selectionsProvider.removeSelection(selection.id),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFBA1A1A), // Error color
                  ),
                  tooltip: 'Remove item',
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Calories per item
            Text(
              '${selection.caloriesPerItem} calories per item',
              style: GoogleFonts.epilogue(
                fontSize: 14,
                color: const Color(0xFF495867).withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            
            // Quantity controls and total calories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quantity controls
                Row(
                  children: [
                    Text(
                      'Quantity:',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF495867),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _QuantityControls(selection: selection),
                  ],
                ),
                
                // Total calories for this item
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5F0), // Light mint background
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF3AB795), // Mint border
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${selection.totalCalories} cal',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF495867),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Quantity control buttons
class _QuantityControls extends StatelessWidget {
  final MealSelection selection;

  const _QuantityControls({
    required this.selection,
  });

  @override
  Widget build(BuildContext context) {
    final selectionsProvider = Provider.of<SelectionsProvider>(context, listen: false);

    return Row(
      children: [
        // Decrease button
        Container(
          decoration: BoxDecoration(
            color: selection.quantity > 1 ? const Color(0xFFFE7252) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: selection.quantity > 1 
                ? () => selectionsProvider.decreaseQuantity(selection.id)
                : null,
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 36,
              height: 36,
              child: Icon(
                Icons.remove,
                color: selection.quantity > 1 ? Colors.white : Colors.grey.shade600,
                size: 20,
              ),
            ),
          ),
        ),
        
        // Quantity display
        Container(
          width: 50,
          alignment: Alignment.center,
          child: Text(
            '${selection.quantity}',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF495867),
            ),
          ),
        ),
        
        // Increase button
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFE7252), // Tomato color
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () => selectionsProvider.increaseQuantity(selection.id),
            borderRadius: BorderRadius.circular(8),
            child: const SizedBox(
              width: 36,
              height: 36,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom section with totals and confirm button
class _BottomSection extends StatelessWidget {
  final int totalCalories;
  final int totalItems;

  const _BottomSection({
    required this.totalCalories,
    required this.totalItems,
  });

  void _confirmSelections(BuildContext context) {
    final selectionsProvider = Provider.of<SelectionsProvider>(context, listen: false);
    
    selectionsProvider.confirmSelections();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selections confirmed'),
        backgroundColor: Color(0xFF3AB795), // Mint color
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Total summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Items',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: const Color(0xFF495867).withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    '$totalItems',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF495867),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Calories',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: const Color(0xFF495867).withValues(alpha: 0.7),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Color(0xFFFE7252),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$totalCalories',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF495867),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Tomato-colored "Confirm Selections" button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _confirmSelections(context),
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
              child: const Text('Confirm Selections'),
            ),
          ),
        ],
      ),
    );
  }
}
