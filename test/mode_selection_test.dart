import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:prepvrse/screens/start_session/widgets/mode_type/ui_mode_type_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        home: ModeTypeScreen(),
      ),
    );
  }

  testWidgets('ModeTypeScreen selects a mode type correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final dropdownFinder = find.byType(DropdownButtonFormField2);
    expect(dropdownFinder, findsOneWidget);

    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    expect(find.text('Interview'), findsOneWidget);
    expect(find.text('Presentation'), findsOneWidget);

    await tester.tap(find.text('Interview').last);
    await tester.pumpAndSettle();

    expect(find.text('Interview'), findsOneWidget);
  });
}
