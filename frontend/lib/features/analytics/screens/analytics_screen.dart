import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardsController;
  late AnimationController _chartController;
  late Animation<double> _headerScaleAnimation;
  late Animation<Offset> _cardsSlideAnimation;
  late Animation<double> _cardsFadeAnimation;
  late Animation<double> _chartRotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _headerController = AnimationController(
      duration: AppConstants.cardAnimationDuration,
      vsync: this,
    );
    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _headerScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.elasticOut,
    ));

    _cardsSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardsController,
      curve: Curves.easeOutCubic,
    ));

    _cardsFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardsController,
      curve: Curves.easeInOut,
    ));

    _chartRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _chartController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _cardsController.forward();
    _chartController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardsController.dispose();
    _chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Animated meal predictions overview
            RepaintBoundary(
              child: ScaleTransition(
                scale: _headerScaleAnimation,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        RepaintBoundary(
                          child: AnimatedBuilder(
                            animation: _chartRotationAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _chartRotationAnimation.value * 0.1,
                                child: Icon(
                                  Icons.trending_up,
                                  size: 48,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Meal Predictions',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'AI-powered insights for better kitchen planning',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            
            // Animated statistics cards
            RepaintBoundary(
              child: SlideTransition(
                position: _cardsSlideAnimation,
                child: FadeTransition(
                  opacity: _cardsFadeAnimation,
                  child: Row(
                    children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.defaultPadding),
                          child: Column(
                            children: [
                              RepaintBoundary(
                                child: AnimatedBuilder(
                                  animation: _chartRotationAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: 0.8 + (_chartRotationAnimation.value * 0.2),
                                      child: Text(
                                        '142',
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Expected Breakfast',
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.defaultPadding),
                          child: Column(
                            children: [
                              RepaintBoundary(
                                child: AnimatedBuilder(
                                  animation: _chartRotationAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: 0.8 + (_chartRotationAnimation.value * 0.2),
                                      child: Text(
                                        '4.2',
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Avg Rating',
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            
            // Animated popular items
            RepaintBoundary(
              child: SlideTransition(
                position: _cardsSlideAnimation,
                child: FadeTransition(
                  opacity: _cardsFadeAnimation,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Popular Today',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPopularItem(context, 'Rajma Chawal', '89%', Icons.rice_bowl),
                        const SizedBox(height: 12),
                        _buildPopularItem(context, 'Chole Bhature', '76%', Icons.local_dining),
                        const SizedBox(height: 12),
                        _buildPopularItem(context, 'Dal Tadka', '68%', Icons.breakfast_dining),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            
            // Animated feedback summary
            RepaintBoundary(
              child: SlideTransition(
                position: _cardsSlideAnimation,
                child: FadeTransition(
                  opacity: _cardsFadeAnimation,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Feedback',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildFeedbackItem(
                          context,
                          'Perfect spice level and taste!',
                          'Rajma Chawal',
                          5,
                        ),
                        const SizedBox(height: 12),
                        _buildFeedbackItem(
                          context,
                          'Could use more gravy',
                          'Dal Tadka',
                          3,
                        ),
                        const SizedBox(height: 12),
                        _buildFeedbackItem(
                          context,
                          'Fresh and well-cooked bhature',
                          'Chole Bhature',
                          5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItem(BuildContext context, String item, String percentage, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.smallPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppConstants.smallPadding),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            item,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Text(
          percentage,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackItem(BuildContext context, String feedback, String item, int rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  size: 16,
                  color: Colors.amber,
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          feedback,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
