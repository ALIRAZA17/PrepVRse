import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:prepvrse/screens/login/ui_login_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  testWidgets('LoginScreen has email and password text fields and can enter text', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final emailTextFieldFinder = find.byKey(ValueKey('emailTextField'));
    final passwordTextFieldFinder = find.byKey(ValueKey('passwordTextField'));
    expect(emailTextFieldFinder, findsOneWidget);
    expect(passwordTextFieldFinder, findsOneWidget);

    await tester.enterText(emailTextFieldFinder, 'test@example.com');
    await tester.pumpAndSettle();
    expect(find.text('test@example.com'), findsOneWidget);

    await tester.enterText(passwordTextFieldFinder, 'password123');
    await tester.pumpAndSettle();
    expect(find.text('password123'), findsOneWidget);
  });
}
