import 'package:the_code_cup/domain/models/product.dart';
import 'package:the_code_cup/domain/models/redeemable_item.dart';
import 'package:the_code_cup/domain/models/user_profile.dart';

/// Immutable catalog + first-launch defaults. Never mutate at runtime.
class SeedData {
  SeedData._();

  static final List<Product> products = List.unmodifiable([
    Product(
      id: 'espresso',
      name: 'Espresso',
      description: 'Strong and bold classic espresso shot',
      basePrice: 25000,
      imageUrl: 'assets/images/espresso.jpeg',
      availableCustomizations: {
        'size': {'Small': 0.0, 'Large': 5000.0},
        'shot': {'Single': 0.0, 'Double': 10000.0},
        'ice': {'Hot': 0.0, 'Iced': 0.0},
      },
    ),
    Product(
      id: 'latte',
      name: 'Latte',
      description: 'Smooth espresso with steamed milk',
      basePrice: 35000,
      imageUrl: 'assets/images/latte.jpg',
      availableCustomizations: {
        'size': {'Small': 0.0, 'Large': 5000.0},
        'ice': {'Hot': 0.0, 'Iced': 0.0},
      },
    ),
    Product(
      id: 'cappuccino',
      name: 'Cappuccino',
      description: 'Espresso with foamy milk topping',
      basePrice: 30000,
      imageUrl: 'assets/images/cappuccino.jpg',
      availableCustomizations: {
        'size': {'Small': 0.0, 'Large': 5000.0},
        'shot': {'Single': 0.0, 'Double': 10000.0},
        'ice': {'Hot': 0.0, 'Iced': 0.0},
      },
    ),
    Product(
      id: 'americano',
      name: 'Americano',
      description: 'Espresso diluted with hot water',
      basePrice: 28000,
      imageUrl: 'assets/images/americano.jpeg',
      availableCustomizations: {
        'size': {'Small': 0.0, 'Large': 4000.0},
        'shot': {'Single': 0.0, 'Double': 10000.0},
        'ice': {'Hot': 0.0, 'Iced': 0.0},
      },
    ),
    Product(
      id: 'mocha',
      name: 'Mocha',
      description: 'Espresso with chocolate and milk',
      basePrice: 40000,
      imageUrl: 'assets/images/mocha.jpeg',
      availableCustomizations: {
        'size': {'Small': 0.0, 'Large': 5000.0},
        'shot': {'Single': 0.0, 'Double': 10000.0},
        'ice': {'Hot': 0.0, 'Iced': 0.0},
      },
    ),
    Product(
      id: 'flat-white',
      name: 'Flat White',
      description: 'Smooth espresso with velvety milk',
      basePrice: 38000,
      imageUrl: 'assets/images/flatwhite.jpg',
      availableCustomizations: {
        'size': {'Small': 0.0, 'Large': 5000.0},
        'ice': {'Hot': 0.0, 'Iced': 0.0},
      },
    ),
  ]);

  static final List<RedeemableItem> redeemableItems = List.unmodifiable([
    RedeemableItem(
      id: 'free-espresso',
      name: 'Free Espresso',
      pointCost: 50,
      imageUrl: 'assets/images/espresso.jpeg',
    ),
    RedeemableItem(
      id: 'free-latte',
      name: 'Free Latte',
      pointCost: 70,
      imageUrl: 'assets/images/latte.jpg',
    ),
    RedeemableItem(
      id: 'coffee-mug',
      name: 'Coffee Mug',
      pointCost: 150,
      imageUrl: 'assets/images/coffee_mug.jpeg',
    ),
    RedeemableItem(
      id: 'coffee-beans',
      name: 'Coffee Beans (500g)',
      pointCost: 300,
      imageUrl: 'assets/images/coffee_beans.jpeg',
    ),
  ]);

  /// First-launch template only — copy into repository, do not mutate.
  static UserProfile get defaultProfile => UserProfile(
    name: 'Nam Kiet',
    email: 'namkiet@example.com',
    phone: '0912345678',
  );

  static const int defaultStampCount = 0;
}
