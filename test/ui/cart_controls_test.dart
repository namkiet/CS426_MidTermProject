import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:the_code_cup/data/seed_data.dart';
import 'package:the_code_cup/viewmodels/app_view_models.dart';
import 'package:the_code_cup/widgets/common_blocks.dart';

void main() {
  late AppViewModels app;

  setUp(() async {
    Hive.init(
      '${Directory.systemTemp.path}/cart_edit_test_${DateTime.now().microsecondsSinceEpoch}',
    );
    await Hive.openBox('the_code_cup');
    app = AppViewModels.create();
  });

  group('EmptyStateText icon', () {
    testWidgets('shows icon and text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateText(
              'Your cart is empty',
              icon: Icons.shopping_cart_outlined,
            ),
          ),
        ),
      );
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });
  });

  group('CartViewModel quantity controls', () {
    test('incrementGroup adds one item to the group', () async {
      await app.cart.addToCart(
        SeedData.products[0].id,
        {'size': 'Large'},
        2,
      );

      expect(app.cart.lines.first.quantity, 2);
      await app.cart.incrementGroup(0);
      expect(app.cart.lines.first.quantity, 3);
    });

    test('decrementGroup removes one item from the group', () async {
      await app.cart.addToCart(
        SeedData.products[0].id,
        {'size': 'Large'},
        3,
      );

      expect(app.cart.lines.first.quantity, 3);
      await app.cart.decrementGroup(0);
      expect(app.cart.lines.first.quantity, 2);
    });

    test('decrementGroup is no-op when quantity is 1', () async {
      await app.cart.addToCart(
        SeedData.products[0].id,
        {'size': 'Large'},
        1,
      );

      await app.cart.decrementGroup(0);
      expect(app.cart.lines.length, 1);
      expect(app.cart.lines.first.quantity, 1);
    });
  });
}
