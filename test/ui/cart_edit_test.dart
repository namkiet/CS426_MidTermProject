import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:the_code_cup/data/seed_data.dart';
import 'package:the_code_cup/viewmodels/app_view_models.dart';

void main() {
  late AppViewModels app;

  setUp(() async {
    Hive.init(
      '${Directory.systemTemp.path}/cart_edit_test_${DateTime.now().microsecondsSinceEpoch}',
    );
    await Hive.openBox('the_code_cup');
    app = AppViewModels.create();
  });

  group('CartViewModel.replaceGroup', () {
    test('removes old group and adds new item', () async {
      await app.cart.addToCart(
        SeedData.products[0].id,
        {'size': 'Large', 'shot': 'Single'},
        2,
      );
      await app.cart.addToCart(
        SeedData.products[0].id,
        {'size': 'Small', 'shot': 'Double'},
        1,
      );

      expect(app.repo.cartItems.length, 2);
      expect(app.cart.lines.length, 2);

      await app.cart.replaceGroup(
        0,
        SeedData.products[0].id,
        {'size': 'Large', 'shot': 'Single'},
        3,
      );

      expect(app.repo.cartItems.length, 2);
      final lines = app.cart.lines;
      expect(lines.length, 2);
      expect(lines[0].quantity, 1);
      expect(lines[1].quantity, 3);
      expect(lines[1].selections['size'], 'Large');
    });

    test('line fields carry correct data for edit navigation', () async {
      await app.cart.addToCart(
        SeedData.products[0].id,
        {'size': 'Large'},
        2,
      );

      final line = app.cart.lines.first;
      expect(line.productId, SeedData.products[0].id);
      expect(line.selections['size'], 'Large');
      expect(line.quantity, 2);
    });
  });
}
