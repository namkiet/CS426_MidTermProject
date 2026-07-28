import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/models/user_profile.dart';
import 'package:the_code_cup/viewmodels/home_viewmodel.dart';
import 'package:the_code_cup/views/profile_screen.dart';

void main() {
  late HomeViewModel viewModel;

  setUp(() async {
    Hive.init('${Directory.systemTemp.path}/profile_screen_test');
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
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
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

    testWidgets('label text uses muted grey color', (tester) async {
      await tester.pumpWidget(buildApp());
      for (final label in ['Full name', 'Phone number', 'Email', 'Address']) {
        final text = tester.widget<Text>(find.text(label));
        expect(text.style?.color, AppColors.textSecondary);
        expect(text.style?.fontSize, 12);
      }
    });

    testWidgets('value text uses primary dark color', (tester) async {
      await tester.pumpWidget(buildApp());
      for (final value in ['Anderson', '0912345678', 'Anderson@email.com']) {
        final text = tester.widget<Text>(find.text(value));
        expect(text.style?.color, AppColors.textPrimary);
        expect(text.style?.fontSize, 16);
        expect(text.style?.fontWeight, FontWeight.bold);
      }
    });

    testWidgets('leading icons are in circular containers', (tester) async {
      await tester.pumpWidget(buildApp());
      final circles = find.byType(Container).evaluate().where((c) {
        final container = c.widget as Container;
        final decoration = container.decoration;
        if (decoration is BoxDecoration) {
          return decoration.color == AppColors.surface &&
              decoration.shape == BoxShape.circle;
        }
        return false;
      });
      expect(circles.length, 5);
    });

    testWidgets('address shows in one line', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.textContaining('Addersion'), findsOneWidget);
    });

    testWidgets('screen uses ListView as body', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('body has horizontal padding of 24 per side', (tester) async {
      await tester.pumpWidget(buildApp());
      final listView = tester.widget<ListView>(find.byType(ListView));
      final EdgeInsetsGeometry padding = listView.padding!;
      expect(padding.horizontal, 48);
    });

    testWidgets('shows avatar initial letter when no avatarUrl', (tester) async {
      await tester.pumpWidget(buildApp());
      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar).first);
      expect(avatar.backgroundImage, isNull);
      expect(avatar.child, isA<Text>());
      expect((avatar.child as Text).data, 'A');
    });

    testWidgets('shows avatar image when avatarUrl is set', (tester) async {
      viewModel.updateProfileField(4, '/tmp/test_avatar.png');
      await tester.pumpWidget(buildApp());
      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar).first);
      expect(avatar.backgroundImage, isA<FileImage>());
    });

    group('bottom navigation bar', () {
      testWidgets('shows bottom nav with Home, Rewards, Orders, Profile tabs',
          (tester) async {
        await tester.pumpWidget(buildApp());
        final navBar = find.byType(BottomNavigationBar);
        expect(navBar, findsOneWidget);
        final items =
            (tester.widget(navBar) as BottomNavigationBar).items;
        expect(items[0].label, 'Home');
        expect(items[1].label, 'Rewards');
        expect(items[2].label, 'Orders');
        expect(items[3].label, 'Profile');
      });

      testWidgets('profile icon uses person icon in bottom nav',
          (tester) async {
        await tester.pumpWidget(buildApp());
        expect(find.byIcon(Icons.person_rounded), findsOneWidget);
      });
    });
  });
}
