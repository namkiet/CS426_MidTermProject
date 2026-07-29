import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:the_code_cup/data/seed_data.dart';
import 'package:the_code_cup/viewmodels/app_view_models.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';
import 'package:the_code_cup/views/order_success_screen.dart';
import 'test_app.dart';

void main() {
  late AppViewModels app;

  setUp(() async {
    Hive.init(
      '${Directory.systemTemp.path}/cart_test_${DateTime.now().microsecondsSinceEpoch}',
    );
    await Hive.openBox('the_code_cup');
    app = createTestApp();
    app.cart.addToCart(
      SeedData.products[0].id,
      {'size': 'Large', 'shot': 'Single'},
      2,
    );
  });

  Widget buildApp(VoidCallback onCheckoutSuccess) => wrapWithApp(
        app,
        Builder(
          builder: (context) => testCart(
            app,
            onCheckoutSuccess: onCheckoutSuccess,
          ),
        ),
      );

  group('CartScreen', () {
    testWidgets('shows cart items with product name', (tester) async {
      await tester.pumpWidget(buildApp(() {}));
      expect(find.text('Espresso'), findsOneWidget);
    });

    testWidgets('shows selected customizations', (tester) async {
      await tester.pumpWidget(buildApp(() {}));
      expect(find.textContaining('Large'), findsOneWidget);
    });

    testWidgets('shows quantity for each item', (tester) async {
      await tester.pumpWidget(buildApp(() {}));
      expect(find.text('x2'), findsOneWidget);
    });

    testWidgets('shows total price in bottom bar', (tester) async {
      await tester.pumpWidget(buildApp(() {}));
      expect(find.textContaining('60.000'), findsOneWidget);
    });

    testWidgets('shows checkout button', (tester) async {
      await tester.pumpWidget(buildApp(() {}));
      expect(find.text('Checkout'), findsOneWidget);
    });

    testWidgets('empty cart shows empty message', (tester) async {
      app.cart.clear();
      await tester.pumpWidget(buildApp(() {}));
      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('order success screen shows confirmation', (tester) async {
      await tester.pumpWidget(wrapWithApp(
        app,
        Builder(
          builder: (context) => OrderSuccessScreen(
            viewModel: app.orders,
            onTrackOrder: () {},
          ),
        ),
      ));
      expect(find.text('Order Confirmed!'), findsOneWidget);
    });
  });
}
