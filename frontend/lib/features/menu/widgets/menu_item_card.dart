import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/models/menu_state.dart';
import '../../../shared/widgets/dietary_badges.dart';
import '../../../core/constants/app_constants.dart';

class MenuItemCard extends ConsumerStatefulWidget {
  final MenuItem menuItem;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon; // Icon to display
  final VoidCallback? onTap;

  const MenuItemCard({
    super.key,
    required this.menuItem,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    this.onTap,
  });

  @override
  ConsumerState<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends ConsumerState<MenuItemCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isHovered = false;

  @override
  bool get wantKeepAlive => true; // Keep widget alive for performance

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: AppConstants.hoverAnimationDuration,
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
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _controller.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _controller.reverse();
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Card(
                  elevation: _isHovered ? 8 : 2,
                  shadowColor: widget.backgroundColor.withValues(alpha: 0.3),
                  color: _colorAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 12),
                        _buildDetails(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        AnimatedContainer(
          duration: AppConstants.hoverAnimationDuration,
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
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.menuItem.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: _isHovered ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.menuItem.calories} cal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _isHovered
                          ? widget.backgroundColor
                          : Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RepaintBoundary(
                    child: AnimatedRotation(
                      turns: _isHovered ? 0.1 : 0.0,
                      duration: AppConstants.hoverAnimationDuration,
                      child: const Icon(Icons.star, color: Colors.amber, size: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.menuItem.description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        DietaryBadges(
          tags: widget.menuItem.tags,
        ),
      ],
    );
  }
}
