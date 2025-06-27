import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Splash screen - app entry point displayed when app starts
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to login screen after 3 seconds using Timer
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Centered "Tray Trail" text in Zen Loop font, Payne's Gray color
            _SplashTitle(),
            SizedBox(height: 48),
            // Tomato-colored CircularProgressIndicator
            _SplashLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}

/// Title widget for splash screen
class _SplashTitle extends StatelessWidget {
  const _SplashTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Tray Trail',
      style: GoogleFonts.zenLoop(
        fontSize: 42,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF495867), // Payne's Gray
      ),
    );
  }
}

/// Loading indicator widget for splash screen
class _SplashLoadingIndicator extends StatelessWidget {
  const _SplashLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: Color(0xFFFE7252), // Tomato color
    );
    
  }
}
