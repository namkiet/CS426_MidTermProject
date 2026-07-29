import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/domain/models/product.dart';

void main() {
  group('Product', () {
    final validCustomizations = {
      'size': {'Small': 0.0, 'Large': 5000.0},
      'shot': {'Single': 0.0, 'Double': 10000.0},
      'ice': {'Hot': 0.0, 'Iced': 0.0},
    };

    test('create product with valid data', () {
      final product = Product(
        name: 'Espresso',
        basePrice: 25000,
        availableCustomizations: validCustomizations,
      );
      expect(product.name, 'Espresso');
      expect(product.basePrice, 25000);
      expect(product.description, isNull);
      expect(product.imageUrl, isNull);
      expect(product.availableCustomizations, validCustomizations);
    });

    test('calculate unit price from base price', () {
      final product = Product(
        name: 'Espresso',
        basePrice: 25000,
        availableCustomizations: validCustomizations,
      );
      final price = product.calculateUnitPrice({});
      expect(price, 25000);
    });

    test('calculate unit price with customization adjustments', () {
      final product = Product(
        name: 'Espresso',
        basePrice: 25000,
        availableCustomizations: validCustomizations,
      );
      final price = product.calculateUnitPrice({
        'size': 'Large',
        'shot': 'Double',
      });
      expect(price, 25000 + 5000 + 10000);
    });

    test('reject zero base price', () {
      expect(
        () => Product(
          name: 'Espresso',
          basePrice: 0,
          availableCustomizations: validCustomizations,
        ),
        throwsArgumentError,
      );
    });

    test('reject negative base price', () {
      expect(
        () => Product(
          name: 'Espresso',
          basePrice: -1000,
          availableCustomizations: validCustomizations,
        ),
        throwsArgumentError,
      );
    });

    test('reject empty name', () {
      expect(
        () => Product(
          name: '',
          basePrice: 25000,
          availableCustomizations: validCustomizations,
        ),
        throwsArgumentError,
      );
    });

    test('accept name with maximum length', () {
      final longName = 'A' * 100;
      final product = Product(
        name: longName,
        basePrice: 25000,
        availableCustomizations: validCustomizations,
      );
      expect(product.name.length, 100);
    });

    test('accept name with special characters', () {
      final product = Product(
        name: 'Cà Phê Sữa #1!',
        basePrice: 25000,
        availableCustomizations: validCustomizations,
      );
      expect(product.name, 'Cà Phê Sữa #1!');
    });
  });
}
