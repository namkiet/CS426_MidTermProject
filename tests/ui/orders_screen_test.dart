import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/data/seed_data.dart';
import 'package:the_code_cup/models/user_profile.dart';
import 'package:the_code_cup/views/orders_screen.dart';

void main() {
  late UserProfile userProfile;

  setUp(() {
    userProfile = SeedData.userProfile;
  });

  Widget buildApp() {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: OrdersScreen(userProfile: userProfile),
    );
  }

  group('OrdersScreen bottom navigation bar', () {
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

    testWidgets('orders icon uses receipt icon in bottom nav',
        (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.byIcon(Icons.receipt_rounded), findsOneWidget);
    });
  });
}
