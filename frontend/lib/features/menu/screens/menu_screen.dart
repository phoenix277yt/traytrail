import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/menu_item_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered animations for menu items
    for (int i = 0; i < 4; i++) {
      final begin = 0.1 + (i * 0.1);
      final end = 0.4 + (i * 0.1);
      
      _slideAnimations.add(
        Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(begin, end, curve: Curves.easeOutCubic),
        )),
      );

      _fadeAnimations.add(
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(begin, end, curve: Curves.easeInOut),
        )),
      );
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            SlideTransition(
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
                        MenuItemCard(
                          name: 'Poha',
                          description: 'Flattened rice with vegetables and spices',
                          calories: '280 cal',
                          icon: Icons.rice_bowl,
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(height: 12),
                        MenuItemCard(
                          name: 'Upma',
                          description: 'Semolina porridge with vegetables',
                          calories: '320 cal',
                          icon: Icons.breakfast_dining,
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SlideTransition(
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
                        MenuItemCard(
                          name: 'Rajma Chawal',
                          description: 'Kidney beans curry with steamed rice',
                          calories: '450 cal',
                          icon: Icons.rice_bowl,
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                        const SizedBox(height: 12),
                        MenuItemCard(
                          name: 'Chole Bhature',
                          description: 'Spiced chickpeas with fried bread',
                          calories: '520 cal',
                          icon: Icons.local_dining,
                          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                          iconColor: Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                        const SizedBox(height: 12),
                        MenuItemCard(
                          name: 'Dal Tadka & Roti',
                          description: 'Lentil curry with Indian flatbread',
                          calories: '380 cal',
                          icon: Icons.breakfast_dining,
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ],
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
}
