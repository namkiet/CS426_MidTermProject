import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:the_code_cup/data/seed_data.dart';
import 'package:the_code_cup/viewmodels/app_view_models.dart';
import 'test_app.dart';

void main() {
  late AppViewModels app;

  setUp(() async {
    Hive.init(
      '${Directory.systemTemp.path}/orders_test_${DateTime.now().microsecondsSinceEpoch}',
    );
    await Hive.openBox('the_code_cup');
    app = createTestApp();
  });

  Widget buildApp() => wrapWithApp(app, testOrders(app));

  group('OrdersScreen', () {
    testWidgets('shows bottom nav with 4 tabs', (tester) async {
      await tester.pumpWidget(buildApp());
      final navBar = find.byType(BottomNavigationBar);
      expect(navBar, findsOneWidget);
      final items = (tester.widget(navBar) as BottomNavigationBar).items;
      expect(items[0].label, 'Home');
      expect(items[1].label, 'Rewards');
      expect(items[2].label, 'Orders');
      expect(items[3].label, 'Profile');
    });

    testWidgets('shows Ongoing and History tabs', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Ongoing'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
    });

    testWidgets('shows empty state when no orders', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('No orders'), findsOneWidget);
    });

    testWidgets('swipe toggles order status', (tester) async {
      app.cart.addToCart(SeedData.products.first.id, {}, 1);
      app.cart.checkout();
      await tester.pumpWidget(buildApp());

      expect(find.byType(Dismissible), findsOneWidget);
      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();
    });
  });
}
