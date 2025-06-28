import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'theme.dart';
import 'splash_screen.dart';

void main() {
  runApp(const TrayTrailApp());
}

class TrayTrailApp extends StatefulWidget {
  const TrayTrailApp({super.key});

  @override
  State<TrayTrailApp> createState() => _TrayTrailAppState();
}

class _TrayTrailAppState extends State<TrayTrailApp> {
  bool _showSplash = true;

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrayTrail',
      theme: TrayTrailTheme.lightTheme,
      themeMode: ThemeMode.light, // Force light mode
      home: _showSplash 
          ? SplashScreen(onAnimationComplete: _onSplashComplete)
          : const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _navigationController;
  late AnimationController _pageTransitionController;
  late Animation<double> _fadeAnimation;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _navigationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pageTransitionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _navigationController, curve: Curves.easeInOut),
    );
    _navigationController.forward();
    _pageTransitionController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _navigationController.dispose();
    _pageTransitionController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNavigationItemTapped(int index) {
    if (index != _selectedIndex) {
      // Reset and forward the transition animation
      _pageTransitionController.reset();
      _pageTransitionController.forward();
    }
    
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            final pages = [
              HomeView(onNavigate: (navIndex) {
                _onNavigationItemTapped(navIndex);
              }),
              const MenuView(),
              const PollsView(),
              const AnalyticsView(),
            ];
            
            return AnimatedBuilder(
              animation: _pageTransitionController,
              builder: (context, child) {
                return pages[index];
              },
            );
          },
        ),
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 100 * (1 - _fadeAnimation.value)),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onNavigationItemTapped,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.restaurant_menu_outlined),
                  selectedIcon: Icon(Icons.restaurant_menu),
                  label: 'Menu',
                ),
                NavigationDestination(
                  icon: Icon(Icons.how_to_vote_outlined),
                  selectedIcon: Icon(Icons.how_to_vote),
                  label: 'Polls',
                ),
                NavigationDestination(
                  icon: Icon(Icons.analytics_outlined),
                  selectedIcon: Icon(Icons.analytics),
                  label: 'Analytics',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  final Function(int) onNavigate;
  
  const HomeView({super.key, required this.onNavigate});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _cardsController;
  late Animation<double> _logoScaleAnimation;
  late Animation<Offset> _cardsSlideAnimation;
  late Animation<double> _cardsFadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Animated logo at the top
              ScaleTransition(
                scale: _logoScaleAnimation,
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 48),
              SlideTransition(
                position: _cardsSlideAnimation,
                child: FadeTransition(
                  opacity: _cardsFadeAnimation,
                  child: _buildQuickActions(context),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SlideTransition(
                  position: _cardsSlideAnimation,
                  child: FadeTransition(
                    opacity: _cardsFadeAnimation,
                    child: SingleChildScrollView(
                      child: _buildRecentActivity(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
              child: _AnimatedQuickActionCard(
                icon: Icons.rate_review,
                title: 'Give Feedback',
                color: Theme.of(context).colorScheme.secondaryContainer,
                onColor: Theme.of(context).colorScheme.onSecondaryContainer,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _AnimatedQuickActionCard(
                icon: Icons.trending_up,
                title: 'Meal Predictions',
                color: Theme.of(context).colorScheme.primaryContainer,
                onColor: Theme.of(context).colorScheme.onPrimaryContainer,
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _AnimatedQuickActionCard(
                icon: Icons.how_to_vote,
                title: 'Vote in Poll',
                color: Theme.of(context).colorScheme.tertiaryContainer,
                onColor: Theme.of(context).colorScheme.onTertiaryContainer,
                onTap: () => widget.onNavigate(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _AnimatedQuickActionCard(
                icon: Icons.restaurant_menu,
                title: 'View Menu',
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                onColor: Theme.of(context).colorScheme.onSurface,
                onTap: () => widget.onNavigate(1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.thumb_up,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  title: Text(
                    'Positive feedback received',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    'Rajma Chawal - 2 hours ago',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
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

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> with TickerProviderStateMixin {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideTransition(
              position: _slideAnimations[0],
              child: FadeTransition(
                opacity: _fadeAnimations[0],
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Breakfast (9:20 - 10:30 AM)',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        SlideTransition(
                          position: _slideAnimations[1],
                          child: FadeTransition(
                            opacity: _fadeAnimations[1],
                            child: _buildMenuItem(
                              context,
                              'Poha',
                              'Flattened rice with vegetables and spices',
                              '280 cal',
                              Icons.rice_bowl,
                              Theme.of(context).colorScheme.primaryContainer,
                              Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SlideTransition(
                          position: _slideAnimations[2],
                          child: FadeTransition(
                            opacity: _fadeAnimations[2],
                            child: _buildMenuItem(
                              context,
                              'Upma',
                              'Semolina porridge with vegetables',
                              '320 cal',
                              Icons.breakfast_dining,
                              Theme.of(context).colorScheme.secondaryContainer,
                              Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                          ),
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lunch (12:00 - 2:30 PM)',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _buildMenuItem(
                          context,
                          'Rajma Chawal',
                          'Kidney beans curry with steamed rice',
                          '450 cal',
                          Icons.rice_bowl,
                          Theme.of(context).colorScheme.secondaryContainer,
                          Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                        const SizedBox(height: 12),
                        _buildMenuItem(
                          context,
                          'Chole Bhature',
                          'Spiced chickpeas with fried bread',
                          '520 cal',
                          Icons.local_dining,
                          Theme.of(context).colorScheme.tertiaryContainer,
                          Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                        const SizedBox(height: 12),
                        _buildMenuItem(
                          context,
                          'Dal Tadka & Roti',
                          'Lentil curry with Indian flatbread',
                          '380 cal',
                          Icons.breakfast_dining,
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(context).colorScheme.onPrimaryContainer,
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

  Widget _buildMenuItem(
    BuildContext context,
    String name,
    String description,
    String price,
    IconData icon,
    Color backgroundColor,
    Color iconColor,
  ) {
    return _AnimatedMenuItem(
      name: name,
      description: description,
      price: price,
      icon: icon,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );
  }
}

class PollsView extends StatefulWidget {
  const PollsView({super.key});

  @override
  State<PollsView> createState() => _PollsViewState();
}

class _PollsViewState extends State<PollsView> with TickerProviderStateMixin {
  late AnimationController _staggerController;
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Create staggered animations for cards
    for (int i = 0; i < 4; i++) {
      final begin = i * 0.1;
      final end = 0.4 + (i * 0.1);
      
      _slideAnimations.add(
        Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _staggerController,
          curve: Interval(begin, end, curve: Curves.easeOutCubic),
        )),
      );

      _fadeAnimations.add(
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _staggerController,
          curve: Interval(begin, end, curve: Curves.easeInOut),
        )),
      );
    }

    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Polls'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
            tooltip: 'Poll History',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideTransition(
              position: _slideAnimations[0],
              child: FadeTransition(
                opacity: _fadeAnimations[0],
                child: _buildTomorrowPreferences(context),
              ),
            ),
            const SizedBox(height: 24),
            SlideTransition(
              position: _slideAnimations[1],
              child: FadeTransition(
                opacity: _fadeAnimations[1],
                child: _buildCurrentPoll(context),
              ),
            ),
            const SizedBox(height: 24),
            SlideTransition(
              position: _slideAnimations[2],
              child: FadeTransition(
                opacity: _fadeAnimations[2],
                child: _buildPollStats(context),
              ),
            ),
            const SizedBox(height: 24),
            SlideTransition(
              position: _slideAnimations[3],
              child: FadeTransition(
                opacity: _fadeAnimations[3],
                child: _buildPreviousWinners(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPoll(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Poll',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '5 days left',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Vote for your favorite item to be added to next month\'s menu!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildPollOption(
              context,
              'Pav Bhaji',
              'Spiced vegetable curry with bread rolls',
              65,
              Icons.local_dining,
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.onPrimaryContainer,
              true,
            ),
            const SizedBox(height: 16),
            _buildPollOption(
              context,
              'Masala Dosa',
              'Crispy rice crepe with potato filling',
              45,
              Icons.breakfast_dining,
              Theme.of(context).colorScheme.secondaryContainer,
              Theme.of(context).colorScheme.onSecondaryContainer,
              false,
            ),
            const SizedBox(height: 16),
            _buildPollOption(
              context,
              'Aloo Paratha',
              'Stuffed flatbread with spiced potatoes',
              38,
              Icons.rice_bowl,
              Theme.of(context).colorScheme.tertiaryContainer,
              Theme.of(context).colorScheme.onTertiaryContainer,
              false,
            ),
            const SizedBox(height: 16),
            _buildPollOption(
              context,
              'Idli Sambar',
              'Steamed rice cakes with lentil curry',
              28,
              Icons.breakfast_dining,
              Theme.of(context).colorScheme.secondaryContainer,
              Theme.of(context).colorScheme.onSecondaryContainer,
              false,
            ),
            const SizedBox(height: 20),
            Text(
              'Total Votes: 342',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollOption(
    BuildContext context,
    String name,
    String description,
    int percentage,
    IconData icon,
    Color backgroundColor,
    Color iconColor,
    bool isLeading,
  ) {
    return _AnimatedPollOption(
      name: name,
      description: description,
      percentage: percentage,
      icon: icon,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      isLeading: isLeading,
    );
  }

  Widget _buildTomorrowPreferences(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tomorrow\'s Preferences',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'AI',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Help us prepare better! Select what you\'d like to eat tomorrow to reduce waste and ensure fresh meals.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Breakfast Section
            _buildMealSection(
              context,
              'Breakfast',
              Icons.wb_sunny,
              [
                _buildPreferenceOption(context, 'Poha', 'Current: 45 interested', 45, false),
                _buildPreferenceOption(context, 'Upma', 'Current: 32 interested', 32, false),
                _buildPreferenceOption(context, 'Idli Sambar', 'Current: 28 interested', 28, false),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Lunch Section  
            _buildMealSection(
              context,
              'Lunch',
              Icons.wb_sunny_outlined,
              [
                _buildPreferenceOption(context, 'Rajma Chawal', 'Current: 89 interested', 89, true),
                _buildPreferenceOption(context, 'Chole Bhature', 'Current: 67 interested', 67, false),
                _buildPreferenceOption(context, 'Dal Tadka & Roti', 'Current: 54 interested', 54, false),
                _buildPreferenceOption(context, 'Biryani', 'Current: 43 interested', 43, false),
              ],
            ),
            
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Selections'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                    label: const Text('Submit Preferences'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSection(BuildContext context, String mealType, IconData icon, List<Widget> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.secondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              mealType,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(children: options),
      ],
    );
  }

  Widget _buildPreferenceOption(BuildContext context, String name, String subtitle, int count, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected 
          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
          : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isSelected ? Icons.check : Icons.restaurant,
            size: 16,
            color: isSelected 
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) 
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Selected',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'Add to preferences',
              ),
          ],
        ),
        onTap: () {},
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }

  Widget _buildPollStats(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Participation Stats',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    '342',
                    'Total Votes',
                    Icons.how_to_vote,
                    Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    '89%',
                    'Participation',
                    Icons.people,
                    Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    '12',
                    'Days Active',
                    Icons.calendar_today,
                    Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon, Color color) {
    // Use more saturated colors for better contrast
    Color saturatedColor;
    if (color == Theme.of(context).colorScheme.primaryContainer) {
      saturatedColor = Theme.of(context).colorScheme.primary;
    } else if (color == Theme.of(context).colorScheme.secondaryContainer) {
      saturatedColor = Theme.of(context).colorScheme.secondary;
    } else if (color == Theme.of(context).colorScheme.tertiaryContainer) {
      saturatedColor = Theme.of(context).colorScheme.tertiary;
    } else {
      saturatedColor = color;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: saturatedColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: saturatedColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousWinners(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Previous Winners',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildWinnerItem(context, 'Samosa Chaat', 'Last Month', '76% votes'),
            const SizedBox(height: 12),
            _buildWinnerItem(context, 'Butter Chicken', '2 months ago', '68% votes'),
            const SizedBox(height: 12),
            _buildWinnerItem(context, 'Vada Pav', '3 months ago', '82% votes'),
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerItem(BuildContext context, String name, String period, String votes) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.amber,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  period,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            votes,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> with TickerProviderStateMixin {
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
      duration: const Duration(milliseconds: 800),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Animated meal predictions overview
            ScaleTransition(
              scale: _headerScaleAnimation,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      AnimatedBuilder(
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
            const SizedBox(height: 24),
            
            // Animated statistics cards
            SlideTransition(
              position: _cardsSlideAnimation,
              child: FadeTransition(
                opacity: _cardsFadeAnimation,
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              AnimatedBuilder(
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
                              const SizedBox(height: 4),
                              Text(
                                'Expected Lunch',
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
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              AnimatedBuilder(
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
            const SizedBox(height: 24),
            
            // Animated popular items
            SlideTransition(
              position: _cardsSlideAnimation,
              child: FadeTransition(
                opacity: _cardsFadeAnimation,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 24),
            
            // Animated feedback summary
            SlideTransition(
              position: _cardsSlideAnimation,
              child: FadeTransition(
                opacity: _cardsFadeAnimation,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItem(BuildContext context, String item, String percentage, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
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

class _AnimatedQuickActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Color onColor;
  final VoidCallback onTap;

  const _AnimatedQuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onColor,
    required this.onTap,
  });

  @override
  State<_AnimatedQuickActionCard> createState() => _AnimatedQuickActionCardState();
}

class _AnimatedQuickActionCardState extends State<_AnimatedQuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: _isPressed ? 8 : 4,
              shadowColor: widget.color.withValues(alpha: 0.3),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.color,
                      widget.color.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.onColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          widget.icon,
                          size: 20,
                          color: widget.onColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Flexible(
                        child: Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: widget.onColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedMenuItem extends StatefulWidget {
  final String name;
  final String description;
  final String price;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _AnimatedMenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  State<_AnimatedMenuItem> createState() => _AnimatedMenuItemState();
}

class _AnimatedMenuItemState extends State<_AnimatedMenuItem>
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
                      widget.price,
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

class _AnimatedPollOption extends StatefulWidget {
  final String name;
  final String description;
  final int percentage;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final bool isLeading;

  const _AnimatedPollOption({
    required this.name,
    required this.description,
    required this.percentage,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.isLeading,
  });

  @override
  State<_AnimatedPollOption> createState() => _AnimatedPollOptionState();
}

class _AnimatedPollOptionState extends State<_AnimatedPollOption>
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
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _progressAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.backgroundColor.withValues(alpha: 0.3),
                  width: widget.isLeading ? 2 : 1,
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
                                      fontWeight: widget.isLeading ? FontWeight.bold : FontWeight.normal,
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
                          child: FilledButton.icon(
                            onPressed: () {},
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
    );
  }
}


