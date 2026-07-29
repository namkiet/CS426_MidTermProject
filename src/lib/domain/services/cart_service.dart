import 'package:the_code_cup/domain/models/cart_item.dart';
import 'package:the_code_cup/domain/models/product.dart';

class CartService {
  double calculateSubtotal(List<CartItem> items) {
    return items.fold<double>(
      0,
      (sum, item) => sum + calculateItemTotal(item),
    );
  }

  double calculateItemTotal(CartItem item) {
    return calculateUnitPrice(item.product, item.selectedCustomizations) *
        item.quantity;
  }

  double calculateUnitPrice(
    Product product,
    Map<String, String> selections,
  ) {
    double total = product.basePrice;
    for (final entry in selections.entries) {
      total += product.availableCustomizations[entry.key]?[entry.value] ?? 0;
    }
    return total;
  }

  int countDistinctItems(List<CartItem> items) {
    final seen = <String>{};
    for (final item in items) {
      seen.add('${item.product.id}:${item.selectedCustomizations}');
    }
    return seen.length;
  }
}
