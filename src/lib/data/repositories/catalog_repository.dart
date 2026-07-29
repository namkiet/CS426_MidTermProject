import 'package:the_code_cup/domain/models/product.dart';
import 'package:the_code_cup/domain/models/redeemable_item.dart';
import 'package:the_code_cup/data/datasources/seed_data.dart';

/// Static catalog — never changes at runtime. No ChangeNotifier needed.
class CatalogRepository {
  List<Product> get products => SeedData.products;
  List<RedeemableItem> get redeemableItems => SeedData.redeemableItems;

  Product? productById(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  RedeemableItem? redeemableById(String id) {
    for (final i in redeemableItems) {
      if (i.id == id) return i;
    }
    return null;
  }
}
