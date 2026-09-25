import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:farra_app/splash_screen.dart';

void main() {
  testWidgets('Splash screen shows Farra text and taxi icon', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen(enableTimer: false)));

    expect(find.text('Farra'), findsOneWidget);
    expect(find.byIcon(Icons.local_taxi), findsOneWidget);
  });
}