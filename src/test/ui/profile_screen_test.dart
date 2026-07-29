import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:the_code_cup/core/constants/app_colors.dart';
import 'package:the_code_cup/presentation/viewmodels/app_view_models.dart';
import 'test_app.dart';

void main() {
  late AppViewModels app;

  setUp(() async {
    Hive.init(
      '${Directory.systemTemp.path}/profile_screen_test_${DateTime.now().microsecondsSinceEpoch}',
    );
    await Hive.openBox('the_code_cup');
    app = createTestApp();
    app.profile.updateName('Anderson');
    app.profile.updatePhone('0912345678');
    app.profile.updateEmail('Anderson@email.com');
  });

  Widget buildApp() => wrapWithApp(app, testProfile(app));

  group('ProfileScreen UI', () {
    testWidgets('has centered AppBar with Profile title', (tester) async {
      await tester.pumpWidget(buildApp());
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.title, isA<Text>());
      expect((appBar.title as Text).data, 'Profile');
      expect(appBar.centerTitle, true);
      expect(appBar.backgroundColor, AppColors.background);
      expect(appBar.elevation, 0);
    });

    testWidgets('shows Full name field with person icon', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Full name'), findsOneWidget);
      expect(find.text('Anderson'), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('shows Phone number field with phone icon', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Phone number'), findsOneWidget);
      expect(find.text('0912345678'), findsOneWidget);
      expect(find.byIcon(Icons.phone_outlined), findsOneWidget);
    });

    testWidgets('shows Email field with email icon', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Anderson@email.com'), findsOneWidget);
    });

    testWidgets('shows Address field with location icon', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Address'), findsOneWidget);
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });

    testWidgets('each field has an edit pencil icon', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.byIcon(Icons.edit_outlined), findsNWidgets(4));
    });

    testWidgets('address empty shows dash', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('—'), findsOneWidget);
    });

    testWidgets('shows avatar initial letter when no avatarUrl', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      final avatar = tester.widget<CircleAvatar>(
        find.byType(CircleAvatar).first,
      );
      expect(avatar.backgroundImage, isNull);
      expect(avatar.child, isA<Text>());
      expect((avatar.child as Text).data, 'A');
    });

    testWidgets('shows avatar image when avatarUrl is set', (tester) async {
      app.profile.updateAvatar(
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
      );
      await tester.pumpWidget(buildApp());
      final avatar = tester.widget<CircleAvatar>(
        find.byType(CircleAvatar).first,
      );
      expect(avatar.backgroundImage, isA<MemoryImage>());
    });

    testWidgets('shows bottom nav with Home, Rewards, Orders, Profile tabs', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      final navBar = find.byType(BottomNavigationBar);
      expect(navBar, findsOneWidget);
      final items = (tester.widget(navBar) as BottomNavigationBar).items;
      expect(items[0].label, 'Home');
      expect(items[1].label, 'Rewards');
      expect(items[2].label, 'Orders');
      expect(items[3].label, 'Profile');
    });
  });
}
