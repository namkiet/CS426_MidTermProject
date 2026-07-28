import 'package:the_code_cup/utils/format.dart';

class ProductCardUi {
  final String id;
  final String name;
  final String? imageUrl;

  const ProductCardUi({
    required this.id,
    required this.name,
    this.imageUrl,
  });
}

class LoyaltyCardUi {
  final int stampCount;
  final String countLabel;
  final String subtitle;
  final bool canReset;

  const LoyaltyCardUi({
    required this.stampCount,
    required this.countLabel,
    required this.subtitle,
    required this.canReset,
  });
}

class CartLineUi {
  final int index;
  final String dismissKey;
  final String name;
  final String customizations;
  final String quantityLabel;

  const CartLineUi({
    required this.index,
    required this.dismissKey,
    required this.name,
    required this.customizations,
    required this.quantityLabel,
  });
}

class OrderRowUi {
  final String id;
  final String statusLabel;
  final bool isOngoing;
  final String itemsSummary;
  final String priceLabel;
  final String dateLabel;

  const OrderRowUi({
    required this.id,
    required this.statusLabel,
    required this.isOngoing,
    required this.itemsSummary,
    required this.priceLabel,
    required this.dateLabel,
  });
}

class TransactionRowUi {
  final String title;
  final String dateLabel;
  final String pointsLabel;
  final bool isEarn;

  const TransactionRowUi({
    required this.title,
    required this.dateLabel,
    required this.pointsLabel,
    required this.isEarn,
  });
}

class RedeemItemUi {
  final String id;
  final String name;
  final String costLabel;
  final bool canAfford;

  const RedeemItemUi({
    required this.id,
    required this.name,
    required this.costLabel,
    required this.canAfford,
  });
}

class ProfileUi {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? avatarUrl;
  final String initial;

  const ProfileUi({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatarUrl,
    required this.initial,
  });
}

class CustomizationOptionUi {
  final String label;
  final String chipLabel;

  const CustomizationOptionUi({
    required this.label,
    required this.chipLabel,
  });
}

class CustomizationGroupUi {
  final String key;
  final String title;
  final List<CustomizationOptionUi> options;

  const CustomizationGroupUi({
    required this.key,
    required this.title,
    required this.options,
  });
}

class ProductDetailsUi {
  final String id;
  final String name;
  final String? description;
  final String basePriceLabel;
  final String? imageUrl;
  final List<CustomizationGroupUi> groups;
  final Map<String, String> defaultSelections;

  const ProductDetailsUi({
    required this.id,
    required this.name,
    required this.description,
    required this.basePriceLabel,
    required this.imageUrl,
    required this.groups,
    required this.defaultSelections,
  });
}

String money(double price) => formatPrice(price);
