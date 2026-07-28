import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/models/product.dart';
import 'package:the_code_cup/models/cart_item.dart';
import 'package:the_code_cup/models/order.dart';

void main() {
  group('Order', () {
    final product = Product(
      name: 'Espresso',
      basePrice: 25000,
      availableCustomizations: {
        'size': {'Small': 0.0, 'Large': 5000.0},
        'shot': {'Single': 0.0, 'Double': 10000.0},
        'ice': {'Hot': 0.0, 'Iced': 0.0},
      },
    );

    final items = [
      CartItem(product: product, selectedCustomizations: {}, quantity: 2),
      CartItem(
        product: product,
        selectedCustomizations: {'size': 'Large'},
        quantity: 1,
      ),
    ];

    test('create order from a list of cart items', () {
      final order = Order(items: items);
      expect(order.items.length, 2);
      expect(order.status, OrderStatus.ongoing);
    });

    test('calculate total price', () {
      final order = Order(items: items);
      // item1: 25000 * 2 = 50000, item2: (25000 + 5000) * 1 = 30000
      expect(order.calculateTotalPrice(), 80000);
    });

    test('calculate points earned', () {
      final order = Order(items: items);
      // 80000 / 10000 = 8
      expect(order.calculatePointsEarned(), 8);
    });

    test('toggle order status from ongoing to history and back', () {
      final order = Order(items: items);
      expect(order.status, OrderStatus.ongoing);

      order.toggleStatus();
      expect(order.status, OrderStatus.history);

      order.toggleStatus();
      expect(order.status, OrderStatus.ongoing);
    });

    test('timestamp recorded correctly on creation', () {
      final order = Order(items: items);
      expect(order.createdAt.isBefore(DateTime.now()), isTrue);
    });

    test('reject order with empty items list', () {
      expect(
        () => Order(items: []),
        throwsAssertionError,
      );
    });

    test('toggle already-history order is idempotent', () {
      final order = Order(items: items, status: OrderStatus.history);
      expect(order.status, OrderStatus.history);

      order.toggleStatus();
      expect(order.status, OrderStatus.ongoing);
    });
  });
}
