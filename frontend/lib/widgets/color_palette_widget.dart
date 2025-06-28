import 'package:flutter/material.dart';
import '../colors.dart';

/// Widget to display the TrayTrail color palette
class ColorPaletteWidget extends StatelessWidget {
  const ColorPaletteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Brand Colors (Light Mode)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                const _ColorChip(
                  color: TrayTrailColors.champagnePink,
                  name: 'Primary - Champagne Pink',
                ),
                const _ColorChip(
                  color: TrayTrailColors.tomato,
                  name: 'Secondary - Tomato',
                ),
                const _ColorChip(
                  color: TrayTrailColors.mint,
                  name: 'Tertiary - Mint',
                ),
                const _ColorChip(
                  color: TrayTrailColors.paynesGray,
                  name: 'Neutral - Payne\'s Gray',
                ),
                const _ColorChip(
                  color: TrayTrailColors.white,
                  name: 'Surface - White',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  final Color color;
  final String name;

  const _ColorChip({
    required this.color,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        name,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: _getContrastingTextColor(color),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getContrastingTextColor(Color backgroundColor) {
    // Calculate luminance to determine if we should use light or dark text
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}
