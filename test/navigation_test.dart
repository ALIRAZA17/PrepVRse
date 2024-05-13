import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:prepvrse/screens/login/ui_login_screen.dart';

void main() {
  setUpAll(() {
    Get.testMode = true;
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        home: LoginScreen(),
        navigatorKey: Get.key,
      ),
    );
  }

  testWidgets('Navigates to SignUp screen when "Sign Up" is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final signUpLinkFinder = find.byWidgetPredicate(
      (Widget widget) => widget is GestureDetector && (widget.child is RichText) && 
        (widget.child as RichText).text.toPlainText().contains('Sign Up'),
      description: 'GestureDetector with "Sign Up" text'
    );

    expect(signUpLinkFinder, findsOneWidget);

    await tester.tap(signUpLinkFinder);
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/signup');
  });
}
