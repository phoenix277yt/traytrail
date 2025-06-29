/// Performance optimization utilities for Flutter widgets
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Debounces a function call to prevent excessive executions
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

/// Throttles a function call to limit execution frequency
class Throttler {
  final int milliseconds;
  Timer? _timer;
  bool _isReady = true;

  Throttler({required this.milliseconds});

  void run(VoidCallback action) {
    if (!_isReady) return;
    
    _isReady = false;
    action();
    
    _timer = Timer(Duration(milliseconds: milliseconds), () {
      _isReady = true;
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}

/// Mixin for widgets that need performance monitoring
mixin PerformanceMonitorMixin on StatefulWidget {
  @override
  StatefulElement createElement() {
    if (kDebugMode) {
      print('Creating element for $runtimeType');
    }
    return super.createElement();
  }
}

/// Helper for conditional widget rebuilds
class ConditionalBuilder extends StatelessWidget {
  final bool condition;
  final Widget Function() trueBuilder;
  final Widget Function()? falseBuilder;

  const ConditionalBuilder({
    super.key,
    required this.condition,
    required this.trueBuilder,
    this.falseBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return trueBuilder();
    } else if (falseBuilder != null) {
      return falseBuilder!();
    } else {
      return const SizedBox.shrink();
    }
  }
}

/// Optimized wrapper for frequently rebuilt widgets
class OptimizedWidget extends StatelessWidget {
  final Widget child;
  final Object? cacheKey;

  const OptimizedWidget({
    super.key,
    required this.child,
    this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: child,
    );
  }
}

/// Cached widget builder to prevent unnecessary rebuilds
class CachedBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final List<Object?> dependencies;

  const CachedBuilder({
    super.key,
    required this.builder,
    required this.dependencies,
  });

  @override
  State<CachedBuilder> createState() => _CachedBuilderState();
}

class _CachedBuilderState extends State<CachedBuilder> {
  Widget? _cachedWidget;
  List<Object?>? _lastDependencies;

  @override
  Widget build(BuildContext context) {
    // Check if dependencies have changed
    if (_cachedWidget == null ||
        _lastDependencies == null ||
        !_dependenciesEqual(_lastDependencies!, widget.dependencies)) {
      _cachedWidget = widget.builder(context);
      _lastDependencies = List.from(widget.dependencies);
    }
    
    return _cachedWidget!;
  }

  bool _dependenciesEqual(List<Object?> a, List<Object?> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Optimized staggered animation controller
class StaggeredAnimationHelper {
  static List<Animation<T>> createStaggeredAnimations<T>({
    required AnimationController controller,
    required int count,
    required T begin,
    required T end,
    required Tween<T> Function(T begin, T end) tweenFactory,
    double staggerDelay = 0.1,
    Curve curve = Curves.easeOutCubic,
  }) {
    final animations = <Animation<T>>[];
    
    for (int i = 0; i < count; i++) {
      final intervalStart = i * staggerDelay;
      final intervalEnd = (intervalStart + 0.4).clamp(0.0, 1.0);
      
      animations.add(
        tweenFactory(begin, end).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(intervalStart, intervalEnd, curve: curve),
          ),
        ),
      );
    }
    
    return animations;
  }
}

/// Performance-optimized animated container
class OptimizedAnimatedContainer extends StatelessWidget {
  final Duration duration;
  final Curve curve;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;

  const OptimizedAnimatedContainer({
    super.key,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    required this.child,
    this.color,
    this.padding,
    this.borderRadius,
    this.boxShadow,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          boxShadow: boxShadow,
        ),
        child: child,
      ),
    );
  }
}

/// Smart rebuilder that only rebuilds when specific conditions are met
class SmartBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final bool Function()? shouldRebuild;
  final VoidCallback? onRebuild;

  const SmartBuilder({
    super.key,
    required this.builder,
    this.shouldRebuild,
    this.onRebuild,
  });

  @override
  State<SmartBuilder> createState() => _SmartBuilderState();
}

class _SmartBuilderState extends State<SmartBuilder> {
  Widget? _cachedWidget;
  bool _hasCachedWidget = false;

  @override
  Widget build(BuildContext context) {
    final shouldRebuild = widget.shouldRebuild?.call() ?? true;
    
    if (!_hasCachedWidget || shouldRebuild) {
      _cachedWidget = widget.builder(context);
      _hasCachedWidget = true;
      widget.onRebuild?.call();
    }
    
    return _cachedWidget!;
  }
}

/// Efficient list builder with automatic optimization
class OptimizedListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;

  const OptimizedListView.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          key: ValueKey(index),
          child: itemBuilder(context, index),
        );
      },
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap,
      cacheExtent: 200, // Optimize for better scrolling performance
    );
  }
}

/// Frame rate monitor for performance tracking
class FrameRateMonitor {
  static final List<Duration> _frameTimes = [];
  static Stopwatch? _stopwatch;
  
  static void startMonitoring() {
    if (kDebugMode) {
      _stopwatch = Stopwatch()..start();
      WidgetsBinding.instance.addPostFrameCallback(_recordFrame);
    }
  }
  
  static void _recordFrame(Duration timestamp) {
    if (_stopwatch != null) {
      _frameTimes.add(_stopwatch!.elapsed);
      _stopwatch!.reset();
      
      // Keep only last 60 frames for rolling average
      if (_frameTimes.length > 60) {
        _frameTimes.removeAt(0);
      }
      
      WidgetsBinding.instance.addPostFrameCallback(_recordFrame);
    }
  }
  
  static double get averageFrameRate {
    if (_frameTimes.isEmpty) return 0.0;
    final totalTime = _frameTimes.fold<Duration>(
      Duration.zero, 
      (prev, curr) => prev + curr,
    );
    return 1000.0 / (totalTime.inMilliseconds / _frameTimes.length);
  }
  
  static void stopMonitoring() {
    _stopwatch?.stop();
    _stopwatch = null;
    _frameTimes.clear();
  }
}

/// Performance-optimized image widget
class OptimizedImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool enableMemoryCache;

  const OptimizedImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.enableMemoryCache = true,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}

/// Memory-efficient list view with automatic optimization
class MemoryEfficientListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final double? itemExtent;

  const MemoryEfficientListView.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
    this.itemExtent,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemExtent: itemExtent, // Helps with scrolling performance
      itemBuilder: (context, index) {
        return RepaintBoundary(
          key: ValueKey('item_$index'),
          child: itemBuilder(context, index),
        );
      },
      physics: physics ?? const BouncingScrollPhysics(),
      padding: padding,
      shrinkWrap: shrinkWrap,
      cacheExtent: 500, // Increased cache for better performance
      addRepaintBoundaries: false, // We're adding them manually
    );
  }
}

/// Efficient animation controller manager
class AnimationManager {
  static final Set<AnimationController> _activeControllers = {};
  
  static void registerController(AnimationController controller) {
    _activeControllers.add(controller);
  }
  
  static void unregisterController(AnimationController controller) {
    _activeControllers.remove(controller);
  }
  
  /// Pause all animations to save battery
  static void pauseAllAnimations() {
    for (final controller in _activeControllers) {
      if (controller.isAnimating) {
        controller.stop();
      }
    }
  }
  
  /// Resume all animations
  static void resumeAllAnimations() {
    for (final controller in _activeControllers) {
      if (!controller.isCompleted && !controller.isDismissed) {
        controller.forward();
      }
    }
  }
  
  /// Dispose all controllers
  static void disposeAll() {
    for (final controller in _activeControllers) {
      controller.dispose();
    }
    _activeControllers.clear();
  }
}

/// Optimized transform widget that minimizes repaints
class OptimizedTransform extends StatelessWidget {
  final Matrix4? transform;
  final Offset? origin;
  final AlignmentGeometry? alignment;
  final bool transformHitTests;
  final Widget child;

  const OptimizedTransform({
    super.key,
    this.transform,
    this.origin,
    this.alignment,
    this.transformHitTests = true,
    required this.child,
  });

  const OptimizedTransform.scale({
    super.key,
    required double scale,
    this.origin,
    this.alignment = Alignment.center,
    this.transformHitTests = true,
    required this.child,
  }) : transform = null;

  const OptimizedTransform.rotate({
    super.key,
    required double angle,
    this.origin,
    this.alignment = Alignment.center,
    this.transformHitTests = true,
    required this.child,
  }) : transform = null;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Transform(
        transform: transform ?? Matrix4.identity(),
        origin: origin,
        alignment: alignment,
        transformHitTests: transformHitTests,
        child: child,
      ),
    );
  }
}
