// Integration tests verifying the interaction between multiple entities.
//
// These tests exercise real workflows that span multiple models, without
// mocking individual dependencies. For full end-to-end scenarios see E2E tests.
import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/models/product.dart';
import 'package:the_code_cup/models/cart_item.dart';
import 'package:the_code_cup/models/order.dart';
import 'package:the_code_cup/models/loyalty_card.dart';
import 'package:the_code_cup/models/reward_points.dart';
import 'package:the_code_cup/models/redeemable_item.dart';

void main() {
  final espresso = Product(
    name: 'Espresso',
    basePrice: 25000,
    availableCustomizations: {
      'size': {'Small': 0.0, 'Large': 5000.0},
      'shot': {'Single': 0.0, 'Double': 10000.0},
      'ice': {'Hot': 0.0, 'Iced': 0.0},
    },
  );

  final latte = Product(
    name: 'Latte',
    basePrice: 35000,
    availableCustomizations: {
      'size': {'Small': 0.0, 'Large': 5000.0},
      'ice': {'Hot': 0.0, 'Iced': 0.0},
    },
  );

  group('Add to Cart → Checkout → Order', () {
    test('add items to cart, calculate totals, checkout creates order', () {
      final cart = [
        CartItem(product: espresso, selectedCustomizations: {}, quantity: 2),
        CartItem(
          product: latte,
          selectedCustomizations: {'size': 'Large'},
          quantity: 1,
        ),
      ];

      expect(cart.length, 2);
      expect(cart[0].calculateSubtotal(), 50000);
      expect(cart[1].calculateSubtotal(), 40000);
      final cartTotal = cart.fold(
        0.0,
        (sum, item) => sum + item.calculateSubtotal(),
      );
      expect(cartTotal, 90000);

      final order = Order(items: cart);
      expect(order.status, OrderStatus.ongoing);
      expect(order.calculateTotalPrice(), 90000);
      expect(order.calculatePointsEarned(), 9);
    });

    test('modify cart before checkout reflects in order', () {
      final cart = [
        CartItem(product: espresso, selectedCustomizations: {}, quantity: 1),
      ];
      expect(cart.fold(0.0, (s, i) => s + i.calculateSubtotal()), 25000);

      cart.add(
        CartItem(
          product: latte,
          selectedCustomizations: {'size': 'Large'},
          quantity: 2,
        ),
      );
      expect(cart.fold(0.0, (s, i) => s + i.calculateSubtotal()), 105000);

      cart.removeAt(0);
      expect(cart.fold(0.0, (s, i) => s + i.calculateSubtotal()), 80000);

      final order = Order(items: cart);
      expect(order.calculateTotalPrice(), 80000);
    });

    test('empty cart cannot create order', () {
      expect(() => Order(items: []), throwsArgumentError);
    });

    test('order toggles from ongoing to history on completion', () {
      final cart = [
        CartItem(product: espresso, selectedCustomizations: {}, quantity: 1),
      ];
      final order = Order(items: cart);
      expect(order.status, OrderStatus.ongoing);

      order.toggleStatus();
      expect(order.status, OrderStatus.history);
    });
  });

  group('Complete Order → Loyalty Stamps → Reward Points', () {
    late final RedeemableItem freeCoffee;
    late final RedeemableItem muffin;

    setUpAll(() {
      freeCoffee = RedeemableItem(name: 'Free Coffee', pointCost: 50);
      muffin = RedeemableItem(name: 'Muffin', pointCost: 25);
    });

    test('completing an order awards stamps and points', () {
      final card = LoyaltyCard();
      final rp = RewardPoints();

      final order1 = Order(
        items: [
          CartItem(product: espresso, selectedCustomizations: {}, quantity: 2),
        ],
      );
      order1.toggleStatus();
      card.increment();
      rp.award(order1.calculatePointsEarned(), order: order1);

      expect(card.stampCount, 1);
      expect(rp.balance, 5);

      final order2 = Order(
        items: [
          CartItem(
            product: latte,
            selectedCustomizations: {'size': 'Large'},
            quantity: 1,
          ),
        ],
      );
      order2.toggleStatus();
      card.increment();
      rp.award(order2.calculatePointsEarned(), order: order2);

      expect(card.stampCount, 2);
      expect(rp.balance, 9);
    });

    test('8 stamps triggers loyalty card reset', () {
      final card = LoyaltyCard();
      final rp = RewardPoints();

      for (int i = 0; i < 8; i++) {
        final order = Order(
          items: [
            CartItem(
              product: espresso,
              selectedCustomizations: {},
              quantity: 1,
            ),
          ],
        );
        order.toggleStatus();
        card.increment();
        rp.award(order.calculatePointsEarned(), order: order);
      }

      expect(card.stampCount, 8);
      expect(rp.balance, 16);

      card.reset();
      expect(card.stampCount, 0);
    });

    test('redeem points reduces balance and records transaction', () {
      final rp = RewardPoints();
      rp.award(
        100,
        order: Order(
          items: [
            CartItem(
              product: espresso,
              selectedCustomizations: {},
              quantity: 1,
            ),
          ],
        ),
      );
      rp.award(
        50,
        order: Order(
          items: [
            CartItem(
              product: espresso,
              selectedCustomizations: {},
              quantity: 1,
            ),
          ],
        ),
      );

      rp.redeem(30, redeemableItem: freeCoffee);
      expect(rp.balance, 120);
      expect(rp.calculateTotalEarned(), 150);

      rp.redeem(50, redeemableItem: muffin);
      expect(rp.balance, 70);

      expect(rp.transactions.length, 4);
      expect(rp.transactions.where((t) => t.type.name == 'redeem').length, 2);
    });

    test('cannot redeem more points than earned', () {
      final rp = RewardPoints();
      rp.award(
        30,
        order: Order(
          items: [
            CartItem(
              product: espresso,
              selectedCustomizations: {},
              quantity: 1,
            ),
          ],
        ),
      );

      expect(() => rp.redeem(50, redeemableItem: freeCoffee), throwsStateError);
      expect(rp.balance, 30);
    });
  });

  group('Loyalty Card Reset', () {
    test('loyalty card reset is only allowed at 8 stamps', () {
      final card = LoyaltyCard();
      card.increment();
      card.increment();
      card.reset();
      expect(card.stampCount, 2);

      for (int i = 2; i < 8; i++) {
        card.increment();
      }
      expect(card.stampCount, 8);

      card.reset();
      expect(card.stampCount, 0);
    });
  });

  group('Stamps Capped at 8 — Points Still Earn', () {
    test('stamps stop at 8 but points continue earning', () {
      final card = LoyaltyCard();
      final rp = RewardPoints();

      for (int i = 0; i < 10; i++) {
        final order = Order(
          items: [
            CartItem(
              product: Product(
                name: 'Espresso',
                basePrice: 25000,
                availableCustomizations: {},
              ),
              selectedCustomizations: {},
              quantity: 1,
            ),
          ],
        );
        order.toggleStatus();
        card.increment();
        rp.award(order.calculatePointsEarned(), order: order);
      }

      expect(card.stampCount, 8);
      expect(rp.balance, 20);
    });
  });

  group('Multiple Orders — Mix of Ongoing and History', () {
    test('orders maintain independent statuses', () {
      final allOrders = <Order>[];
      for (int i = 0; i < 5; i++) {
        allOrders.add(
          Order(
            items: [
              CartItem(
                product: Product(
                  name: 'Espresso',
                  basePrice: 25000,
                  availableCustomizations: {},
                ),
                selectedCustomizations: {},
                quantity: 1,
              ),
            ],
          ),
        );
      }

      allOrders[0].toggleStatus();
      allOrders[1].toggleStatus();
      allOrders[2].toggleStatus();

      final ongoing = allOrders
          .where((o) => o.status == OrderStatus.ongoing)
          .length;
      final history = allOrders
          .where((o) => o.status == OrderStatus.history)
          .length;

      expect(ongoing, 2);
      expect(history, 3);
    });
  });
}
