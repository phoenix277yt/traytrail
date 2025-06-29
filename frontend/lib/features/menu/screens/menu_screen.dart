import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/state/providers/menu_provider.dart';
import '../../../utils/performance_utils.dart';
import '../widgets/menu_item_card.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> 
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;
  
  // Cache for performance optimization
  final Map<String, IconData> _iconCache = {};
  final Map<String, Color> _colorCache = {};

  @override
  bool get wantKeepAlive => true; // Keep alive for performance

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _controller.forward();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered animations for menu items using helper
    _slideAnimations = StaggeredAnimationHelper.createStaggeredAnimations<Offset>(
      controller: _controller,
      count: 4,
      begin: const Offset(0, 1),
      end: Offset.zero,
      tweenFactory: (begin, end) => Tween(begin: begin, end: end),
      curve: Curves.easeOutCubic,
    );

    _fadeAnimations = StaggeredAnimationHelper.createStaggeredAnimations<double>(
      controller: _controller,
      count: 4,
      begin: 0.0,
      end: 1.0,
      tweenFactory: (begin, end) => Tween(begin: begin, end: end),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final menuState = ref.watch(menuProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Menu'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RepaintBoundary(
              child: SlideTransition(
                position: _slideAnimations[0],
                child: FadeTransition(
                  opacity: _fadeAnimations[0],
                  child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Breakfast (9:20 - 10:30 AM)',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ...menuState.todaysMenu?.breakfastItems.map((item) => 
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: MenuItemCard(
                              menuItem: item,
                              icon: _getIconFromName(item.iconName),
                              backgroundColor: _parseColor(item.backgroundColor),
                              iconColor: _parseColor(item.iconColor),
                            ),
                          ),
                        ) ?? [],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ),
            const SizedBox(height: 16),
            RepaintBoundary(
              child: SlideTransition(
                position: _slideAnimations[3],
                child: FadeTransition(
                  opacity: _fadeAnimations[3],
                  child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lunch (12:00 - 2:30 PM)',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ...menuState.todaysMenu?.lunchItems.map((item) => 
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: MenuItemCard(
                              menuItem: item,
                              icon: _getIconFromName(item.iconName),
                              backgroundColor: _parseColor(item.backgroundColor),
                              iconColor: _parseColor(item.iconColor),
                            ),
                          ),
                        ) ?? [],
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

  IconData _getIconFromName(String iconName) {
    return _iconCache.putIfAbsent(iconName, () {
      switch (iconName) {
        case 'rice_bowl':
          return Icons.rice_bowl;
        case 'breakfast_dining':
          return Icons.breakfast_dining;
        case 'local_dining':
          return Icons.local_dining;
        default:
          return Icons.restaurant;
      }
    });
  }

  Color _parseColor(String colorString) {
    return _colorCache.putIfAbsent(colorString, () {
      return Color(int.parse(colorString.substring(1, 7), radix: 16) + 0xFF000000);
    });
  }
}
