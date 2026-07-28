import 'package:the_code_cup/models/product.dart';
import 'package:the_code_cup/models/redeemable_item.dart';
import 'package:the_code_cup/models/user_profile.dart';

/// Immutable catalog + first-launch defaults. Never mutate at runtime.
class SeedData {
  SeedData._();

  static final List<Product> products = List.unmodifiable([
    Product(
      id: 'espresso',
      name: 'Espresso',
      description: 'Strong and bold classic espresso shot',
      basePrice: 25000,
      imageUrl:
          'https://images.unsplash.com/photo-1510707577719-ae7c14805e3a?w=400&h=400&fit=crop',
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
      imageUrl:
          'https://images.unsplash.com/photo-1561882468-9110e97e5c52?w=400&h=400&fit=crop',
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
      imageUrl:
          'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400&h=400&fit=crop',
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
      imageUrl:
          'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400&h=400&fit=crop',
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
      imageUrl:
          'https://images.unsplash.com/photo-1578314675249-a6910f80cc39?w=400&h=400&fit=crop',
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
      imageUrl:
          'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400&h=400&fit=crop',
      availableCustomizations: {
        'size': {'Small': 0.0, 'Large': 5000.0},
        'ice': {'Hot': 0.0, 'Iced': 0.0},
      },
    ),
  ]);

  static final List<RedeemableItem> redeemableItems = List.unmodifiable([
    RedeemableItem(id: 'free-espresso', name: 'Free Espresso', pointCost: 50),
    RedeemableItem(id: 'free-latte', name: 'Free Latte', pointCost: 70),
    RedeemableItem(id: 'coffee-mug', name: 'Coffee Mug', pointCost: 150),
    RedeemableItem(
      id: 'coffee-beans',
      name: 'Coffee Beans (500g)',
      pointCost: 300,
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
