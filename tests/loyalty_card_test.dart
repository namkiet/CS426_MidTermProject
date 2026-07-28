import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/models/loyalty_card.dart';

void main() {
  group('LoyaltyCard', () {
    test('start with 0 stamps', () {
      final card = LoyaltyCard();
      expect(card.stampCount, 0);
    });

    test('increment stamps up to 8', () {
      final card = LoyaltyCard();
      for (int i = 0; i < 8; i++) {
        card.increment();
      }
      expect(card.stampCount, 8);
    });

    test('increment beyond 8 does nothing', () {
      final card = LoyaltyCard();
      for (int i = 0; i < 10; i++) {
        card.increment();
      }
      expect(card.stampCount, 8);
    });

    test('reset at exactly 8 stamps', () {
      final card = LoyaltyCard();
      for (int i = 0; i < 8; i++) {
        card.increment();
      }
      card.reset();
      expect(card.stampCount, 0);
    });

    test('reset when stamps are below 8 does nothing', () {
      final card = LoyaltyCard();
      card.increment();
      card.increment();
      card.reset();
      expect(card.stampCount, 2);
    });
  });
}
