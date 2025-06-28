import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'shared/widgets/splash_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/menu/screens/menu_screen.dart';
import 'features/polls/screens/polls_screen.dart';
import 'features/analytics/screens/analytics_screen.dart';

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
      title: AppConstants.appName,
      theme: TrayTrailTheme.lightTheme,
      themeMode: ThemeMode.light, // Force light mode
      home: _showSplash 
          ? SplashScreen(onAnimationComplete: _onSplashComplete)
          : const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
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
      duration: AppConstants.navigationDuration,
      vsync: this,
    );
    _pageTransitionController = AnimationController(
      duration: AppConstants.pageTransitionDuration,
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
      duration: AppConstants.pageTransitionDuration,
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
              HomeScreen(onNavigate: (navIndex) {
                _onNavigationItemTapped(navIndex);
              }),
              const MenuScreen(),
              const PollsScreen(),
              const AnalyticsScreen(),
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
