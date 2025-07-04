import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/state/state.dart';
import '../widgets/quick_action_card.dart';
import '../../feedback/screens/feedback_screen.dart';
import '../../settings/screens/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final Function(int) onNavigate;
  
  const HomeScreen({super.key, required this.onNavigate});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _cardsController;
  late Animation<double> _logoScaleAnimation;
  late Animation<Offset> _cardsSlideAnimation;
  late Animation<double> _cardsFadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: AppConstants.cardAnimationDuration,
      vsync: this,
    );
    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _cardsSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
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

    _startAnimations();
  }

  void _startAnimations() async {
    await _logoController.forward();
    await _cardsController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main content with scrollable area
            RepaintBoundary(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Animated logo at the top - cached for performance
                    RepaintBoundary(
                      child: ScaleTransition(
                        scale: _logoScaleAnimation,
                        child: SvgPicture.asset(
                          AppConstants.logoPath,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    RepaintBoundary(
                      child: SlideTransition(
                        position: _cardsSlideAnimation,
                        child: FadeTransition(
                          opacity: _cardsFadeAnimation,
                          child: _buildQuickActions(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.largePadding),
                    RepaintBoundary(
                      child: SlideTransition(
                        position: _cardsSlideAnimation,
                        child: FadeTransition(
                          opacity: _cardsFadeAnimation,
                          child: _buildRecentActivity(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100), // Extra space for FAB
                  ],
                ),
              ),
            ),
            // Settings icon positioned in top right
            Positioned(
              top: 16,
              right: 16,
              child: RepaintBoundary(
                child: ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.settings,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget.onNavigate(1); // Navigate to Menu page (index 1)
        },
        icon: const Icon(Icons.restaurant),
        label: const Text('Today\'s Menu'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                icon: Icons.rate_review,
                title: 'Give Feedback',
                color: Theme.of(context).colorScheme.secondaryContainer,
                onColor: Theme.of(context).colorScheme.onSecondaryContainer,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedbackScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionCard(
                icon: Icons.how_to_vote,
                title: 'Vote in Poll',
                color: Theme.of(context).colorScheme.tertiaryContainer,
                onColor: Theme.of(context).colorScheme.onTertiaryContainer,
                onTap: () => widget.onNavigate(2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                icon: Icons.restaurant_menu,
                title: 'View Menu',
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                onColor: Theme.of(context).colorScheme.onSurface,
                onTap: () => widget.onNavigate(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionCard(
                icon: Icons.insights,
                title: 'Analytics',
                color: Theme.of(context).colorScheme.errorContainer,
                onColor: Theme.of(context).colorScheme.onErrorContainer,
                onTap: () => widget.onNavigate(3),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final pollState = ref.watch(pollProvider);
    final menuState = ref.watch(menuProvider);
    final feedbackStats = ref.watch(feedbackStatsProvider);
    final recentFeedback = ref.watch(recentFeedbackProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                widget.onNavigate(3); // Navigate to Analytics page (index 3)
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                // Current poll info
                if (pollState.polls.isNotEmpty)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(AppConstants.smallPadding),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                      ),
                      child: Icon(
                        Icons.poll,
                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                    title: Text(
                      pollState.polls.first.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      '${pollState.polls.first.totalVotes} votes • ${pollState.polls.first.isActive ? 'Active' : 'Ended'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    onTap: () => widget.onNavigate(2),
                  ),
                
                // Today's menu summary
                if (menuState.todaysMenu != null && menuState.todaysMenu!.getAllItems().isNotEmpty)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(AppConstants.smallPadding),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                      ),
                      child: Icon(
                        Icons.restaurant_menu,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    title: Text(
                      'Today\'s Menu',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      '${menuState.todaysMenu!.getAllItems().length} items available',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    onTap: () => widget.onNavigate(1),
                  ),
                
                // Recent feedback summary
                if (recentFeedback.isNotEmpty)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(AppConstants.smallPadding),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                      ),
                      child: Icon(
                        Icons.feedback,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    title: Text(
                      'Recent Feedback',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      '${feedbackStats['total']} total • Avg rating: ${feedbackStats['avgRating']}/5',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FeedbackScreen(),
                        ),
                      );
                    },
                  ),
                
                // Fallback when no data
                if (pollState.polls.isEmpty && 
                    (menuState.todaysMenu == null || menuState.todaysMenu!.getAllItems().isEmpty) && 
                    recentFeedback.isEmpty)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(AppConstants.smallPadding),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    title: Text(
                      'Welcome to TrayTrail!',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Check the menu, vote in polls, and share feedback',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(AppConstants.smallPadding),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppConstants.smallPadding),
                    ),
                    child: Icon(
                      Icons.trending_up,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(
                    'Meal prediction updated',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    'Tomorrow\'s lunch - 1 hour ago',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
