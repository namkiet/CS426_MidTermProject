import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/models/product.dart';
import 'package:the_code_cup/models/cart_item.dart';
import 'package:the_code_cup/models/order.dart';
import 'package:the_code_cup/models/loyalty_card.dart';
import 'package:the_code_cup/models/reward_points.dart';
import 'package:the_code_cup/models/redeemable_item.dart';

void main() {
  final product = Product(
    name: 'Espresso',
    basePrice: 25000,
    availableCustomizations: {
      'size': {'Small': 0.0, 'Large': 5000.0},
      'shot': {'Single': 0.0, 'Double': 10000.0},
      'ice': {'Hot': 0.0, 'Iced': 0.0},
    },
  );

  group('Dynamic Price Calculation', () {
    test('compute total from base price alone', () {
      expect(product.calculateUnitPrice({}), 25000);
    });

    test('compute total with customization adjustments added', () {
      expect(product.calculateUnitPrice({'size': 'Large', 'shot': 'Double'}), 40000);
    });

    test('multiply by quantity for correct aggregate', () {
      final item = CartItem(product: product, selectedCustomizations: {}, quantity: 3);
      expect(item.calculateSubtotal(), 75000);
    });

    test('update total when customization option changes', () {
      final item = CartItem(product: product, selectedCustomizations: {}, quantity: 1);
      final unchanged = item.calculateSubtotal();
      final changed = CartItem(
        product: product,
        selectedCustomizations: {'size': 'Large', 'shot': 'Double'},
        quantity: 1,
      ).calculateSubtotal();
      expect(unchanged, 25000);
      expect(changed, 40000);
    });
  });

  group('Total Price Display', () {
    test('compute total for a single item', () {
      final order = Order(items: [
        CartItem(product: product, selectedCustomizations: {}, quantity: 2),
      ]);
      expect(order.calculateTotalPrice(), 50000);
    });

    test('compute aggregate total for multiple items', () {
      final order = Order(items: [
        CartItem(product: product, selectedCustomizations: {}, quantity: 2),
        CartItem(
          product: product,
          selectedCustomizations: {'size': 'Large'},
          quantity: 1,
        ),
      ]);
      expect(order.calculateTotalPrice(), 80000);
    });

    test('recalculate total after item removal', () {
      final withBoth = Order(items: [
        CartItem(product: product, selectedCustomizations: {}, quantity: 2),
        CartItem(
          product: product,
          selectedCustomizations: {'size': 'Large'},
          quantity: 1,
        ),
      ]);
      final afterRemoval = Order(items: [
        CartItem(product: product, selectedCustomizations: {}, quantity: 2),
      ]);
      expect(withBoth.calculateTotalPrice(), 80000);
      expect(afterRemoval.calculateTotalPrice(), 50000);
    });
  });

  group('Points Calculation', () {
    test('award correct points based on order monetary value', () {
      final order = Order(items: [
        CartItem(product: product, selectedCustomizations: {}, quantity: 2),
      ]);
      expect(order.calculatePointsEarned(), 5); // 50000 / 10000
    });

    test('Order.calculateTotalPrice() returns sum of all cart items', () {
      final order = Order(items: [
        CartItem(product: product, selectedCustomizations: {}, quantity: 1),
        CartItem(product: product, selectedCustomizations: {'size': 'Large'}, quantity: 2),
      ]);
      expect(order.calculateTotalPrice(), 85000);
    });

    test('Order.calculatePointsEarned() returns correct points from total price', () {
      final order = Order(items: [
        CartItem(product: product, selectedCustomizations: {}, quantity: 3),
      ]);
      expect(order.calculatePointsEarned(), 7); // 75000 / 10000
    });

    test('very large order value does not overflow', () {
      final manyItems = List.generate(
        1000,
        (_) => CartItem(product: product, selectedCustomizations: {}, quantity: 100),
      );
      final order = Order(items: manyItems);
      expect(order.calculateTotalPrice(), 25000 * 100 * 1000);
      expect(order.calculatePointsEarned(), (25000 * 100 * 1000) ~/ 10000);
    });
  });

  group('Points Aggregation', () {
    test('sum points from multiple earn transactions', () {
      final rp = RewardPoints();
      rp.award(50, order: Order(items: [CartItem(product: product, selectedCustomizations: {}, quantity: 1)]));
      rp.award(30, order: Order(items: [CartItem(product: product, selectedCustomizations: {}, quantity: 1)]));
      rp.award(20, order: Order(items: [CartItem(product: product, selectedCustomizations: {}, quantity: 1)]));
      expect(rp.calculateTotalEarned(), 100);
    });

    test('deduct points on partial redemption', () {
      final rp = RewardPoints();
      rp.award(100, order: Order(items: [CartItem(product: product, selectedCustomizations: {}, quantity: 1)]));
      rp.redeem(30, redeemableItem: RedeemableItem(name: 'Free Coffee', pointCost: 30));
      expect(rp.balance, 70);
    });

    test('calculate remaining balance after partial redemption', () {
      final rp = RewardPoints();
      rp.award(100, order: Order(items: [CartItem(product: product, selectedCustomizations: {}, quantity: 1)]));
      rp.redeem(30, redeemableItem: RedeemableItem(name: 'Free Coffee', pointCost: 30));
      rp.redeem(20, redeemableItem: RedeemableItem(name: 'Muffin', pointCost: 20));
      expect(rp.calculateTotalEarned(), 100);
      expect(rp.balance, 50);
    });

    test('balance of 0 returns 0', () {
      final rp = RewardPoints();
      expect(rp.balance, 0);
      expect(rp.calculateTotalEarned(), 0);
    });

    test('repeated redemptions deplete balance correctly', () {
      final rp = RewardPoints();
      rp.award(100, order: Order(items: [CartItem(product: product, selectedCustomizations: {}, quantity: 1)]));
      for (int i = 0; i < 4; i++) {
        rp.redeem(25, redeemableItem: RedeemableItem(name: 'Item $i', pointCost: 25));
      }
      expect(rp.balance, 0);
    });
  });

  group('Loyalty Stamp Logic', () {
    test('+1 stamp per completed order', () {
      final card = LoyaltyCard();
      card.increment();
      expect(card.stampCount, 1);
      card.increment();
      expect(card.stampCount, 2);
    });

    test('stops incrementing at max 8', () {
      final card = LoyaltyCard();
      for (int i = 0; i < 10; i++) {
        card.increment();
      }
      expect(card.stampCount, 8);
    });

    test('reset at 8 stamps', () {
      final card = LoyaltyCard();
      for (int i = 0; i < 8; i++) {
        card.increment();
      }
      card.reset();
      expect(card.stampCount, 0);
    });

    test('increment from empty loyalty card', () {
      final card = LoyaltyCard();
      card.increment();
      expect(card.stampCount, 1);
    });
  });
}
