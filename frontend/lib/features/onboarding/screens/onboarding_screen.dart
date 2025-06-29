import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/onboarding_service.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntroductionScreen(
      globalBackgroundColor: TrayTrailColors.white,
      pages: [
        _buildWelcomePage(context),
        _buildMenuPollsPage(context),
        _buildTomorrowPreferencesPage(context),
        _buildSettingsPage(context),
        _buildAIFeaturesPage(context),
      ],
      onDone: () => _completeOnboarding(context, ref),
      onSkip: () => _completeOnboarding(context, ref),
      showSkipButton: true,
      skip: const Text(
        'Skip',
        style: const TextStyle(
          color: TrayTrailColors.tomatoSaturated,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      next: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: TrayTrailColors.champagnePinkSaturated,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: TrayTrailColors.champagnePinkSaturated.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_forward,
          color: TrayTrailColors.white,
          size: 20,
        ),
      ),
      done: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: TrayTrailColors.tomatoSaturated,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: TrayTrailColors.tomatoSaturated.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Text(
          'Get Started',
          style: TextStyle(
            color: TrayTrailColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: TrayTrailColors.tomatoSaturated,
        color: TrayTrailColors.champagnePinkSaturated.withValues(alpha: 0.5),
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      curve: Curves.easeInOut,
      controlsMargin: const EdgeInsets.all(16),
    );
  }

  PageViewModel _buildWelcomePage(BuildContext context) {
    return PageViewModel(
      title: 'Welcome to TrayTrail! 🍽️',
      body: 'Your smart dining companion that helps reduce food waste while ensuring you get the meals you love.',
      image: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: TrayTrailColors.champagnePinkLight,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: TrayTrailColors.champagnePinkSaturated.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.restaurant_menu,
            size: 80,
            color: TrayTrailColors.tomatoSaturated,
          ),
        ),
      ),
      decoration: _getPageDecoration(),
    );
  }

  PageViewModel _buildMenuPollsPage(BuildContext context) {
    return PageViewModel(
      title: 'Vote on Menu Items 🗳️',
      body: 'Have a say in what gets added to next month\'s menu! Vote for your favorite dishes and see real-time results.',
      image: Center(
        child: Container(
          width: 250,
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: TrayTrailColors.mintLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: TrayTrailColors.mintSaturated.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.poll,
                size: 60,
                color: TrayTrailColors.mintSaturated,
              ),
              const SizedBox(height: 16),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: TrayTrailColors.mintSaturated,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 8,
                width: 150,
                decoration: BoxDecoration(
                  color: TrayTrailColors.mintSaturated.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
      decoration: _getPageDecoration(),
    );
  }

  PageViewModel _buildTomorrowPreferencesPage(BuildContext context) {
    return PageViewModel(
      title: 'Tomorrow\'s Preferences 📋',
      body: 'Select what you\'d like to eat tomorrow to help the kitchen prepare better and reduce waste. You can submit once per day!',
      image: Center(
        child: Container(
          width: 250,
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: TrayTrailColors.tomatoLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: TrayTrailColors.tomatoSaturated.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.schedule,
                size: 60,
                color: TrayTrailColors.tomatoSaturated,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMiniCard(Icons.wb_sunny, TrayTrailColors.champagnePinkSaturated),
                  _buildMiniCard(Icons.wb_sunny_outlined, TrayTrailColors.mintSaturated),
                ],
              ),
            ],
          ),
        ),
      ),
      decoration: _getPageDecoration(),
    );
  }

  PageViewModel _buildSettingsPage(BuildContext context) {
    return PageViewModel(
      title: 'Customize Your Experience ⚙️',
      body: 'Personalize your dietary preferences, notification settings, and more in the settings menu.',
      image: Center(
        child: Container(
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: TrayTrailColors.paynesGrayLight,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: TrayTrailColors.paynesGraySaturated.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.settings,
                size: 60,
                color: TrayTrailColors.paynesGraySaturated,
              ),
              const SizedBox(height: 16),
              Container(
                height: 4,
                width: 80,
                decoration: BoxDecoration(
                  color: TrayTrailColors.tomatoSaturated,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
      decoration: _getPageDecoration(),
    );
  }

  PageViewModel _buildAIFeaturesPage(BuildContext context) {
    return PageViewModel(
      title: 'AI-Powered Insights 🤖',
      body: 'Get smart recommendations and insights powered by AI to make better dining choices and reduce food waste.',
      image: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TrayTrailColors.champagnePinkLight,
                TrayTrailColors.mintLight,
                TrayTrailColors.tomatoLight,
              ],
            ),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: TrayTrailColors.tomatoSaturated.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 80,
            color: TrayTrailColors.white,
          ),
        ),
      ),
      decoration: _getPageDecoration(),
    );
  }

  Widget _buildMiniCard(IconData icon, Color color) {
    return Container(
      width: 50,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  PageDecoration _getPageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: TrayTrailColors.paynesGraySaturated,
        fontFamily: 'Epilogue',
      ),
      bodyTextStyle: TextStyle(
        fontSize: 18,
        color: TrayTrailColors.paynesGray,
        height: 1.5,
        fontFamily: 'Epilogue',
      ),
      imagePadding: EdgeInsets.only(top: 40, bottom: 40),
      bodyPadding: EdgeInsets.symmetric(horizontal: 32),
      titlePadding: EdgeInsets.only(top: 20, bottom: 16),
      contentMargin: EdgeInsets.symmetric(horizontal: 16),
    );
  }

  void _completeOnboarding(BuildContext context, WidgetRef ref) async {
    // Mark onboarding as completed
    await OnboardingService.completeOnboarding();
    
    if (context.mounted) {
      // Navigate back to the main app, which will now show the home screen
      Navigator.of(context).pushReplacementNamed('/');
    }
  }
}
