import 'package:the_code_cup/models/product.dart';

class CartItem {
  final Product product;
  final Map<String, String> selectedCustomizations;
  final int quantity;

  CartItem({
    required this.product,
    required this.selectedCustomizations,
    required this.quantity,
  }) : assert(quantity >= 1);

  double calculateSubtotal() {
    return product.calculateUnitPrice(selectedCustomizations) * quantity;
  }

}
