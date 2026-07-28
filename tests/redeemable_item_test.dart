import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/models/redeemable_item.dart';

void main() {
  group('RedeemableItem', () {
    test('create item with valid name and positive point cost', () {
      final item = RedeemableItem(name: 'Free Coffee', pointCost: 50);
      expect(item.name, 'Free Coffee');
      expect(item.pointCost, 50);
      expect(item.imageUrl, isNull);
    });

    test('create item with imageUrl', () {
      final item = RedeemableItem(
        name: 'Free Coffee',
        pointCost: 50,
        imageUrl: 'https://example.com/coffee.png',
      );
      expect(item.imageUrl, 'https://example.com/coffee.png');
    });

    test('reject zero point cost', () {
      expect(
        () => RedeemableItem(name: 'Free Coffee', pointCost: 0),
        throwsAssertionError,
      );
    });

    test('reject negative point cost', () {
      expect(
        () => RedeemableItem(name: 'Free Coffee', pointCost: -10),
        throwsAssertionError,
      );
    });
  });
}
