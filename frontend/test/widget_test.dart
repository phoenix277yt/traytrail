// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tray_trail/main.dart';

void main() {
  testWidgets('TrayTrail app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TrayTrailApp());

    // Verify that our app shows the splash screen with TrayTrail title
    expect(find.text('TrayTrail'), findsOneWidget);
    expect(find.text('Welcome to your food journey'), findsOneWidget);

    // Verify the splash screen has a loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Wait for the splash screen timer and pump
    await tester.pumpAndSettle(const Duration(seconds: 4));
    
    // After splash screen timeout, should navigate to login screen
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Sign in to continue your food journey'), findsOneWidget);
  });
}
