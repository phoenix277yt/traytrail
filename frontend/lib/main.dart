import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/onboarding_service.dart';
import 'core/constants/app_constants.dart';
import 'features/home/screens/home_screen.dart';
import 'features/menu/screens/menu_screen.dart';
import 'features/polls/screens/polls_screen.dart';
import 'features/analytics/screens/analytics_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'shared/widgets/splash_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure performance optimizations
  if (kReleaseMode) {
    // Disable debugging overlays in release mode
    WidgetsApp.debugAllowBannerOverride = false;
  }
  
  runApp(
    const ProviderScope(
      child: TrayTrailApp(),
    ),
  );
}

class TrayTrailApp extends StatelessWidget {
  const TrayTrailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: TrayTrailTheme.lightTheme,
      darkTheme: TrayTrailTheme.lightTheme, // Using light theme for both for now
      themeMode: ThemeMode.system,
      home: const AppWrapper(),
      debugShowCheckedModeBanner: false,
      // Performance optimizations
      showPerformanceOverlay: kDebugMode && false, // Enable only when needed
      checkerboardRasterCacheImages: kDebugMode && false,
      checkerboardOffscreenLayers: kDebugMode && false,
    );
  }
}

class AppWrapper extends ConsumerStatefulWidget {
  const AppWrapper({super.key});

  @override
  ConsumerState<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends ConsumerState<AppWrapper> {
  bool _isLoading = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final hasSeenOnboarding = await OnboardingService.hasCompletedOnboarding();
      if (mounted) {
        setState(() {
          _showOnboarding = !hasSeenOnboarding;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _showOnboarding = false;
          _isLoading = false;
        });
      }
    }
  }

  void _onSplashComplete() {
    // Splash completed, move to main content
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return RepaintBoundary(
        child: SplashScreen(onAnimationComplete: _onSplashComplete),
      );
    }

    return _showOnboarding
        ? RepaintBoundary(
            child: const OnboardingScreen(),
          )
        : const RepaintBoundary(
            child: MainPage(),
          );
  }
}

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> 
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  late AnimationController _navigationController;
  late AnimationController _pageTransitionController;
  late Animation<double> _fadeAnimation;
  late PageController _pageController;
  
  // Cache pages for better performance
  late final List<Widget> _pages;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializePages();
    _startAnimations();
  }

  void _initializeControllers() {
    _pageController = PageController(initialPage: 0);
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
  }

  void _initializePages() {
    _pages = [
      RepaintBoundary(
        key: const ValueKey('home_page'),
        child: HomeScreen(onNavigate: _onNavigationItemTapped),
      ),
      const RepaintBoundary(
        key: ValueKey('menu_page'),
        child: MenuScreen(),
      ),
      const RepaintBoundary(
        key: ValueKey('polls_page'),
        child: PollsScreen(),
      ),
      const RepaintBoundary(
        key: ValueKey('analytics_page'),
        child: AnalyticsScreen(),
      ),
    ];
  }

  void _startAnimations() {
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
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _onNavigationItemTapped(int index) {
    if (index != _selectedIndex) {
      // Optimized page transition
      HapticFeedback.lightImpact();
      
      // Only reset animation if different page
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
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return Scaffold(
      body: RepaintBoundary(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _pages[index];
            },
          ),
        ),
      ),
      bottomNavigationBar: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 100 * (1 - _fadeAnimation.value)),
              child: _buildNavigationBar(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onNavigationItemTapped,
      destinations: _buildNavigationDestinations(),
      animationDuration: AppConstants.navigationDuration,
    );
  }

  List<NavigationDestination> _buildNavigationDestinations() {
    return const [
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
    ];
  }
}
