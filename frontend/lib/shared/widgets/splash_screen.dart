import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onAnimationComplete;
  
  const SplashScreen({
    super.key,
    required this.onAnimationComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _backgroundAnimation;
  
  bool _disposed = false;
  Timer? _logoTimer;
  Timer? _textTimer;
  Timer? _completeTimer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Logo animations - optimized with better curves
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    ));

    // Text animations
    _textSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    // Background animation
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    // Start background animation immediately
    if (mounted && !_disposed) {
      _backgroundController.forward();
    }
    
    // Start logo animation after a brief delay
    _logoTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted && !_disposed && !_logoController.isCompleted) {
        _logoController.forward();
      }
    });
    
    // Start text animation
    _textTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted && !_disposed && !_textController.isCompleted) {
        _textController.forward();
      }
    });
    
    // Complete splash screen after animations
    _completeTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted && !_disposed) {
        widget.onAnimationComplete();
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    
    // Cancel any pending timers
    _logoTimer?.cancel();
    _textTimer?.cancel();
    _completeTimer?.cancel();
    
    // Dispose animation controllers
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _logoController,
            _textController,
            _backgroundController,
          ]),
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    TrayTrailColors.champagnePink.withValues(
                      alpha: 0.1 + (0.9 * _backgroundAnimation.value),
                    ),
                    TrayTrailColors.white,
                    TrayTrailColors.tomatoLight.withValues(
                      alpha: 0.1 + (0.8 * _backgroundAnimation.value),
                    ),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo - wrapped in RepaintBoundary for optimization
                    RepaintBoundary(
                      child: Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Opacity(
                          opacity: _logoOpacityAnimation.value,
                          child: SvgPicture.asset(
                            AppConstants.logoPath,
                            height: 120,
                            width: 120,
                          ),
                        ),
                      ),
                    ),
                        
                    const SizedBox(height: 32),
                        
                    // Animated Text - optimized transform
                    RepaintBoundary(
                      child: Transform.translate(
                        offset: Offset(0, _textSlideAnimation.value),
                        child: Opacity(
                          opacity: _textOpacityAnimation.value,
                          child: const Text(
                            'Smart Cafeteria',
                            style: TextStyle(
                              fontFamily: AppConstants.primaryFont,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: TrayTrailColors.paynesGray,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                        
                    const SizedBox(height: 48),
                        
                    // Loading indicator - cached for performance
                    RepaintBoundary(
                      child: Opacity(
                        opacity: _textOpacityAnimation.value,
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              TrayTrailColors.tomato,
                            ),
                          ),
                        ),
                      ),
                    ),
                        
                    const SizedBox(height: 80),
                        
                    // Copyright notice - const for performance
                    RepaintBoundary(
                      child: Opacity(
                        opacity: _textOpacityAnimation.value,
                        child: const Text(
                          '© 2025 Daksh Shrivastav',
                          style: TextStyle(
                            fontFamily: AppConstants.bodyFont,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: TrayTrailColors.paynesGray,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
