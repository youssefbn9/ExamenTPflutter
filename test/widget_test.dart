import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workshop7/login.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Login()));
    expect(find.text('Login'), findsOneWidget);
  });
}
