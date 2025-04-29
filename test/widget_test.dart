// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bhukk1/main.dart';

void main() {
  testWidgets('Splash screen test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify that splash screen shows app name
    expect(find.text('Bhukk'), findsOneWidget);
    expect(find.text('Food Delivery App'), findsOneWidget);
    
    // Verify that splash screen shows icon
    expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
  });
}
