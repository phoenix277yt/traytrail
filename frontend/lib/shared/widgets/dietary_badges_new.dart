import 'package:flutter/material.dart';

/// Widget that displays informational badges for menu items and poll options
class DietaryBadges extends StatelessWidget {
  final List<String> tags;
  final EdgeInsetsGeometry padding;

  const DietaryBadges({
    super.key,
    required this.tags,
    this.padding = const EdgeInsets.only(top: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: Wrap(
        spacing: 6.0,
        runSpacing: 4.0,
        children: tags.map((tag) => _buildInfoBadge(tag, theme)).toList(),
      ),
    );
  }

  Widget _buildInfoBadge(String tag, ThemeData theme) {
    // Define colors for different types of tags
    Color backgroundColor;
    Color textColor;
    IconData? icon;

    switch (tag.toLowerCase()) {
      case 'healthy':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = Icons.favorite;
        break;
      case 'protein-rich':
      case 'protein rich':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        icon = Icons.fitness_center;
        break;
      case 'light':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        icon = Icons.air;
        break;
      case 'spicy':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Icons.local_fire_department;
        break;
      case 'vegetarian':
        backgroundColor = Colors.lightGreen.shade100;
        textColor = Colors.lightGreen.shade800;
        icon = Icons.eco;
        break;
      case 'vegan':
        backgroundColor = Colors.teal.shade100;
        textColor = Colors.teal.shade800;
        icon = Icons.nature;
        break;
      case 'gluten-free':
      case 'gluten free':
        backgroundColor = Colors.amber.shade100;
        textColor = Colors.amber.shade800;
        icon = Icons.grain;
        break;
      default:
        backgroundColor = theme.colorScheme.surfaceContainerHighest;
        textColor = theme.colorScheme.onSurfaceVariant;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: textColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            tag,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
