import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/domain/models/product.dart';
import 'package:the_code_cup/domain/models/cart_item.dart';
import 'package:the_code_cup/domain/models/order.dart';
import 'package:the_code_cup/domain/models/redeemable_item.dart';
import 'package:the_code_cup/domain/models/reward_points.dart';
import 'package:the_code_cup/domain/models/transaction.dart';

void main() {
  group('RewardPoints', () {
    final espresso = Product(
      name: 'Espresso',
      basePrice: 25000,
      availableCustomizations: {},
    );
    final freeCoffee = RedeemableItem(name: 'Free Coffee', pointCost: 50);
    final muffin = RedeemableItem(name: 'Muffin', pointCost: 25);

    Order makeOrder({int quantity = 1}) => Order(
      items: [
        CartItem(
          product: espresso,
          selectedCustomizations: {},
          quantity: quantity,
        ),
      ],
    );

    test('start with balance 0', () {
      final rp = RewardPoints();
      expect(rp.balance, 0);
    });

    test('award points based on order monetary value', () {
      final rp = RewardPoints();
      rp.award(50, order: makeOrder());
      expect(rp.balance, 50);
    });

    test('deduct points on successful redemption', () {
      final rp = RewardPoints();
      rp.award(100, order: makeOrder());
      rp.redeem(30, redeemableItem: freeCoffee);
      expect(rp.balance, 70);
    });

    test('track earn transactions', () {
      final rp = RewardPoints();
      rp.award(50, order: makeOrder());
      rp.award(30, order: makeOrder());
      expect(rp.transactions.length, 2);
    });

    test('track redeem transactions', () {
      final rp = RewardPoints();
      rp.award(100, order: makeOrder());
      rp.redeem(30, redeemableItem: freeCoffee);
      rp.redeem(20, redeemableItem: muffin);
      expect(
        rp.transactions.where((t) => t.type == TransactionType.redeem).length,
        2,
      );
    });

    test('verify transaction amounts are recorded correctly', () {
      final rp = RewardPoints();
      rp.award(50, order: makeOrder());
      rp.redeem(20, redeemableItem: muffin);
      expect(rp.transactions[0].amount, 50);
      expect(rp.transactions[1].amount, 20);
    });

    test('calculateTotalEarned() sums all earn transactions', () {
      final rp = RewardPoints();
      rp.award(50, order: makeOrder());
      rp.award(30, order: makeOrder());
      rp.redeem(20, redeemableItem: muffin);
      expect(rp.calculateTotalEarned(), 80);
    });

    test('reject redeem with insufficient balance', () {
      final rp = RewardPoints();
      rp.award(10, order: makeOrder());
      expect(() => rp.redeem(20, redeemableItem: freeCoffee), throwsStateError);
      expect(rp.balance, 10);
    });

    test('reject redeem with zero points', () {
      final rp = RewardPoints();
      expect(
        () => rp.redeem(0, redeemableItem: freeCoffee),
        throwsArgumentError,
      );
    });

    test('reject redeem with negative points', () {
      final rp = RewardPoints();
      expect(
        () => rp.redeem(-5, redeemableItem: freeCoffee),
        throwsArgumentError,
      );
    });
  });
}
