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

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'selectedCustomizations': selectedCustomizations,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: Product.fromJson(json['product'] as Map<String, dynamic>),
        selectedCustomizations:
            (json['selectedCustomizations'] as Map<String, dynamic>)
                .map((k, v) => MapEntry(k, v as String)),
        quantity: json['quantity'] as int,
      );
}
