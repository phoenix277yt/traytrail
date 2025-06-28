// This is a basic Flutter widget test for TrayTrail app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:tray_trail/main.dart';

void main() {
  testWidgets('TrayTrail app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TrayTrailApp());

    // Wait for splash screen to complete
    await tester.pump(const Duration(seconds: 3));

    // Verify that our app loads with the logo
    expect(find.text('TrayTrail'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);

    // Verify navigation bar exists
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('Polls'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);
  });
}


