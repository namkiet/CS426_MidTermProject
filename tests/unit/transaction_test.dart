import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/models/transaction.dart';
import 'package:the_code_cup/models/order.dart';
import 'package:the_code_cup/models/product.dart';
import 'package:the_code_cup/models/cart_item.dart';
import 'package:the_code_cup/models/redeemable_item.dart';

void main() {
  group('Transaction', () {
    final order = Order(items: [
      CartItem(
        product: Product(
          name: 'Espresso',
          basePrice: 25000,
          availableCustomizations: {},
        ),
        selectedCustomizations: {},
        quantity: 1,
      ),
    ]);

    final redeemableItem = RedeemableItem(name: 'Free Coffee', pointCost: 50);

    test('create earn transaction with amount and order', () {
      final tx = Transaction(type: TransactionType.earn, amount: 50, order: order);
      expect(tx.type, TransactionType.earn);
      expect(tx.amount, 50);
      expect(tx.order, order);
      expect(tx.redeemableItem, isNull);
    });

    test('create redeem transaction with amount and redeemableItem', () {
      final tx = Transaction(
        type: TransactionType.redeem,
        amount: 30,
        redeemableItem: redeemableItem,
      );
      expect(tx.type, TransactionType.redeem);
      expect(tx.amount, 30);
      expect(tx.redeemableItem, redeemableItem);
      expect(tx.order, isNull);
    });

    test('createdAt auto-set on creation', () {
      final tx = Transaction(type: TransactionType.earn, amount: 10);
      expect(tx.createdAt.isBefore(DateTime.now()), isTrue);
    });

    test('reject zero amount', () {
      expect(
        () => Transaction(type: TransactionType.earn, amount: 0),
        throwsAssertionError,
      );
    });

    test('reject negative amount', () {
      expect(
        () => Transaction(type: TransactionType.earn, amount: -5),
        throwsAssertionError,
      );
    });
  });
}
