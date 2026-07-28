import 'package:the_code_cup/models/product.dart';
import 'package:the_code_cup/models/user_profile.dart';
import 'package:the_code_cup/models/loyalty_card.dart';
import 'package:the_code_cup/models/redeemable_item.dart';

class SeedData {
  SeedData._();

  static final List<Product> products = [
    Product(
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
  ];

  static UserProfile userProfile = UserProfile(
    name: 'Nam Kiet',
    email: 'namkiet@example.com',
    phone: '0912345678',
  );

  static LoyaltyCard loyaltyCard = LoyaltyCard(stampCount: 0);

  static final List<RedeemableItem> redeemableItems = [
    RedeemableItem(name: 'Free Espresso', pointCost: 50),
    RedeemableItem(name: 'Free Latte', pointCost: 70),
    RedeemableItem(name: 'Coffee Mug', pointCost: 150),
    RedeemableItem(name: 'Coffee Beans (500g)', pointCost: 300),
  ];
}
