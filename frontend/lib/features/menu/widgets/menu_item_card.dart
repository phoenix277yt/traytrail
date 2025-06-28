import 'package:flutter/material.dart';

class MenuItemCard extends StatefulWidget {
  final String name;
  final String description;
  final String calories;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const MenuItemCard({
    super.key,
    required this.name,
    required this.description,
    required this.calories,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: widget.backgroundColor.withValues(alpha: 0.3),
      end: widget.backgroundColor.withValues(alpha: 0.6),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: _isHovered ? 8 : 2,
              shadowColor: widget.backgroundColor.withValues(alpha: 0.3),
              color: _colorAnimation.value,
              child: ListTile(
                leading: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: widget.backgroundColor.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                  ),
                ),
                title: Text(
                  widget.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: _isHovered ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  widget.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.calories,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _isHovered
                            ? widget.backgroundColor
                            : Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedRotation(
                      turns: _isHovered ? 0.1 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.star, color: Colors.amber, size: 16),
                    ),
                  ],
                ),
                onTap: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
