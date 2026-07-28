import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:the_code_cup/viewmodels/home_viewmodel.dart';
import 'package:the_code_cup/views/profile_screen.dart';

void main() {
  late HomeViewModel viewModel;

  setUp(() async {
    Hive.init('${Directory.systemTemp.path}/profile_edit_test');
    await Hive.openBox('the_code_cup');
    viewModel = HomeViewModel();
    viewModel.updateProfileField(0, 'Anderson');
    viewModel.updateProfileField(1, '0912345678');
    viewModel.updateProfileField(2, 'Anderson@email.com');
  });

  Widget buildApp() {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: ProfileScreen(viewModel: viewModel),
    );
  }

  group('ProfileScreen editing', () {
    testWidgets('tapping edit on Full name shows text field with current value',
        (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.tap(find.byIcon(Icons.edit_outlined).first);
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(
        (tester.widget<TextField>(find.byType(TextField)).controller?.text),
        'Anderson',
      );
    });

    testWidgets('tapping edit on Phone number shows text field with current value',
        (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.tap(find.byIcon(Icons.edit_outlined).at(1));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(
        (tester.widget<TextField>(find.byType(TextField)).controller?.text),
        '0912345678',
      );
    });

    testWidgets('tapping edit on Email shows text field with current value',
        (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.tap(find.byIcon(Icons.edit_outlined).at(2));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(
        (tester.widget<TextField>(find.byType(TextField)).controller?.text),
        'Anderson@email.com',
      );
    });

    testWidgets('changing name and saving updates the displayed value',
        (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.tap(find.byIcon(Icons.edit_outlined).first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'New Name');
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();
      expect(find.text('New Name'), findsOneWidget);
    });

    testWidgets('tapping cancel discards changes and keeps old value',
        (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.tap(find.byIcon(Icons.edit_outlined).first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Cancelled Name');
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('Anderson'), findsOneWidget);
      expect(find.text('Cancelled Name'), findsNothing);
    });

    testWidgets('editing one field does not affect other fields',
        (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.tap(find.byIcon(Icons.edit_outlined).first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'New Name');
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();
      expect(find.text('0912345678'), findsOneWidget);
      expect(find.text('Anderson@email.com'), findsOneWidget);
    });

    testWidgets('editing phone number and saving triggers callback',
        (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.tap(find.byIcon(Icons.edit_outlined).at(1));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '0861234567');
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();
      expect(find.text('0861234567'), findsOneWidget);
    });
  });
}
