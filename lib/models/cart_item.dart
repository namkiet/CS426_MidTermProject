import 'package:the_code_cup/models/product.dart';

class CartItem {
  final Product product;
  final Map<String, String> selectedCustomizations;
  final int quantity;

  CartItem({
    required this.product,
    required this.selectedCustomizations,
    required this.quantity,
  }) {
    if (quantity < 1) {
      throw ArgumentError.value(quantity, 'quantity', 'Must be at least 1');
    }
  }

  double calculateSubtotal() {
    return product.calculateUnitPrice(selectedCustomizations) * quantity;
  }

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'selectedCustomizations': selectedCustomizations,
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    product: Product.fromJson(Map<String, dynamic>.from(json['product'])),
    selectedCustomizations:
        (Map<String, dynamic>.from(json['selectedCustomizations'])).map(
          (k, v) => MapEntry(k, v as String),
        ),
    quantity: json['quantity'] as int,
  );
}
