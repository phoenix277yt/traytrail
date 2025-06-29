import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/models/poll_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/dietary_badges.dart';
import '../../../utils/performance_utils.dart';

class PollOptionCard extends ConsumerStatefulWidget {
  final PollOption pollOption;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final bool isSelected;
  final bool hasVoted;
  final bool isLoading;
  final VoidCallback? onTap;
  final String? heroTag; // For hero animations

  const PollOptionCard({
    super.key,
    required this.pollOption,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.isSelected,
    required this.hasVoted,
    this.isLoading = false,
    this.onTap,
    this.heroTag,
  });

  @override
  ConsumerState<PollOptionCard> createState() => _PollOptionCardState();
}

class _PollOptionCardState extends ConsumerState<PollOptionCard>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  
  late final AnimationController _hoverController;
  late final AnimationController _progressController;
  late final Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation; // Remove 'final' to allow reassignment
  
  bool _isHovered = false;
  bool _animationsInitialized = false;

  @override
  bool get wantKeepAlive => true; // Keep state alive for performance

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _hoverController = AnimationController(
      duration: AppConstants.hoverAnimationDuration,
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: AppConstants.progressAnimationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AppConstants.hoverScaleFactor,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: (widget.pollOption.percentage / 100).clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _animationsInitialized = true;
    
    // Use WidgetsBinding for better performance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startProgressAnimation();
    });
  }

  void _startProgressAnimation() {
    if (!mounted || !_animationsInitialized) return;
    
    Future.delayed(
      const Duration(milliseconds: AppConstants.progressAnimationDelay),
      () {
        if (mounted) {
          _progressController.forward();
        }
      },
    );
  }

  @override
  void didUpdateWidget(PollOptionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update progress animation if percentage changed
    if (oldWidget.pollOption.percentage != widget.pollOption.percentage && 
        _animationsInitialized) {
      _updateProgressAnimation();
    }
  }

  void _updateProgressAnimation() {
    if (!mounted || !_animationsInitialized) return;
    
    final currentValue = _progressAnimation.value;
    final newTargetValue = (widget.pollOption.percentage / 100).clamp(0.0, 1.0);
    
    _progressAnimation = Tween<double>(
      begin: currentValue,
      end: newTargetValue,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));
    
    _progressController.reset();
    _progressController.forward();
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super for AutomaticKeepAliveClientMixin
    
    return Semantics(
      button: true,
      enabled: !widget.hasVoted && widget.onTap != null,
      selected: widget.isSelected,
      hint: widget.hasVoted 
          ? 'You have already voted for this option'
          : 'Tap to vote for ${widget.pollOption.name}',
      child: MouseRegion(
        onEnter: (_) {
          if (!widget.hasVoted) {
            setState(() => _isHovered = true);
            _hoverController.forward();
          }
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
              return OptimizedWidget(
                cacheKey: '${widget.pollOption.id}_${widget.isSelected}_${widget.hasVoted}',
                child: Transform.scale(
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
                        width: widget.isSelected || widget.pollOption.isLeading ? 2 : 1,
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
                          _buildHeader(context),
                          const SizedBox(height: 12),
                          _buildProgressBar(context),
                        ],
                      ),
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _buildIcon(context),
        const SizedBox(width: 16),
        Expanded(child: _buildContent(context)),
        const SizedBox(width: 12),
        _buildActionButton(context),
      ],
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Hero(
      tag: widget.heroTag ?? 'poll_icon_${widget.pollOption.id}',
      child: AnimatedContainer(
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
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        const SizedBox(height: 4),
        Text(
          widget.pollOption.description,
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        DietaryBadges(
          tags: widget.pollOption.dietaryTags,
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.pollOption.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: widget.pollOption.isLeading || widget.isSelected 
                  ? FontWeight.bold 
                  : FontWeight.normal,
              color: widget.isSelected ? widget.iconColor : null,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        if (widget.pollOption.isLeading) ...[
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
    );
  }

  Widget _buildActionButton(BuildContext context) {
    if (widget.isLoading) {
      return SizedBox(
        width: 80,
        height: 40,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(widget.backgroundColor),
            ),
          ),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: widget.hasVoted 
        ? _buildVotedIndicator(context)
        : _buildVoteButton(context),
    );
  }

  Widget _buildVotedIndicator(BuildContext context) {
    return Container(
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
            '${widget.pollOption.percentage.toInt()}%',
            style: TextStyle(
              color: widget.isSelected 
                ? widget.iconColor
                : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoteButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: widget.onTap,
      icon: const Icon(Icons.thumb_up, size: 18),
      label: Text('${widget.pollOption.percentage.toInt()}%'),
      style: FilledButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        foregroundColor: widget.iconColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: _isHovered ? 4 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return AnimatedBuilder(
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
    );
  }
}
