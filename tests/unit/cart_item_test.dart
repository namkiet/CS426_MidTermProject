import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/models/product.dart';
import 'package:the_code_cup/models/cart_item.dart';

void main() {
  group('CartItem', () {
    final product = Product(
      name: 'Espresso',
      basePrice: 25000,
      availableCustomizations: {
        'size': {'Small': 0.0, 'Large': 5000.0},
        'shot': {'Single': 0.0, 'Double': 10000.0},
        'ice': {'Hot': 0.0, 'Iced': 0.0},
      },
    );

    test('create cart item with product and selected customizations', () {
      final item = CartItem(
        product: product,
        selectedCustomizations: {'size': 'Large', 'ice': 'Iced'},
        quantity: 1,
      );
      expect(item.product, product);
      expect(item.selectedCustomizations, {'size': 'Large', 'ice': 'Iced'});
      expect(item.quantity, 1);
    });

    test('update quantity', () {
      final item = CartItem(
        product: product,
        selectedCustomizations: {},
        quantity: 3,
      );
      expect(item.quantity, 3);
    });

    test('calculate subtotal', () {
      final item = CartItem(
        product: product,
        selectedCustomizations: {'size': 'Large', 'shot': 'Double'},
        quantity: 2,
      );
      // (25000 + 5000 + 10000) × 2 = 80000
      expect(item.calculateSubtotal(), 80000);
    });

    test('reject quantity zero or negative', () {
      expect(
        () => CartItem(
          product: product,
          selectedCustomizations: {},
          quantity: 0,
        ),
        throwsAssertionError,
      );
      expect(
        () => CartItem(
          product: product,
          selectedCustomizations: {},
          quantity: -1,
        ),
        throwsAssertionError,
      );
    });

    test('create cart item without customizations', () {
      final item = CartItem(
        product: product,
        selectedCustomizations: {},
        quantity: 2,
      );
      expect(item.calculateSubtotal(), 50000);
    });
  });
}
