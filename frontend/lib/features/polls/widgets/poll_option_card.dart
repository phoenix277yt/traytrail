import 'package:flutter/material.dart';

class PollOptionCard extends StatefulWidget {
  final String name;
  final String description;
  final int percentage;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final bool isLeading;
  final bool isSelected;
  final bool hasVoted;
  final VoidCallback onTap;

  const PollOptionCard({
    super.key,
    required this.name,
    required this.description,
    required this.percentage,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.isLeading,
    required this.isSelected,
    required this.hasVoted,
    required this.onTap,
  });

  @override
  State<PollOptionCard> createState() => _PollOptionCardState();
}

class _PollOptionCardState extends State<PollOptionCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _progressController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.percentage / 100,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    // Start progress animation after a delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _progressController.forward();
    });
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: GestureDetector(
        onTap: widget.hasVoted ? null : widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _progressAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.isSelected 
                    ? widget.backgroundColor.withValues(alpha: 0.3) 
                    : widget.backgroundColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.isSelected 
                      ? widget.backgroundColor 
                      : widget.backgroundColor.withValues(alpha: 0.3),
                    width: widget.isSelected || widget.isLeading ? 2 : 1,
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: widget.backgroundColor.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: widget.backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _isHovered
                                  ? [
                                      BoxShadow(
                                        color: widget.backgroundColor.withValues(alpha: 0.4),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              widget.icon,
                              color: widget.iconColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.name,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: widget.isLeading || widget.isSelected ? FontWeight.bold : FontWeight.normal,
                                        color: widget.isSelected ? widget.iconColor : null,
                                      ),
                                    ),
                                    if (widget.isLeading) ...[
                                      const SizedBox(width: 8),
                                      AnimatedRotation(
                                        turns: _isHovered ? 0.1 : 0.0,
                                        duration: const Duration(milliseconds: 200),
                                        child: const Icon(
                                          Icons.emoji_events,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                    if (widget.isSelected) ...[
                                      const SizedBox(width: 8),
                                      AnimatedScale(
                                        scale: _isHovered ? 1.1 : 1.0,
                                        duration: const Duration(milliseconds: 200),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: widget.iconColor,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  widget.description,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: widget.hasVoted 
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: widget.isSelected 
                                      ? widget.backgroundColor
                                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        widget.isSelected ? Icons.how_to_vote : Icons.bar_chart,
                                        size: 18,
                                        color: widget.isSelected 
                                          ? widget.iconColor
                                          : Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${widget.percentage}%',
                                        style: TextStyle(
                                          color: widget.isSelected 
                                            ? widget.iconColor
                                            : Theme.of(context).colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : FilledButton.icon(
                                  onPressed: widget.onTap,
                                  icon: const Icon(Icons.thumb_up, size: 18),
                                  label: Text('${widget.percentage}%'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: widget.backgroundColor,
                                    foregroundColor: widget.iconColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    elevation: _isHovered ? 4 : 0,
                                  ),
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: _progressAnimation.value,
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(widget.backgroundColor),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
