import 'package:the_code_cup/models/cart_item.dart';
import 'package:the_code_cup/viewmodels/repo_view_model.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';

class CartViewModel extends RepoViewModel {
  CartViewModel(super.repo);

  bool get isEmpty => repo.cartItems.isEmpty;

  int get itemCount => repo.cartItems.length;

  String get totalLabel {
    final total = repo.cartItems.fold<double>(
      0,
      (sum, item) => sum + item.calculateSubtotal(),
    );
    return money(total);
  }

  List<CartLineUi> get lines {
    final out = <CartLineUi>[];
    for (var i = 0; i < repo.cartItems.length; i++) {
      final item = repo.cartItems[i];
      out.add(
        CartLineUi(
          index: i,
          dismissKey: '${item.product.id}-$i',
          name: item.product.name,
          customizations: item.selectedCustomizations.values.join(', '),
          quantityLabel: 'x${item.quantity}',
        ),
      );
    }
    return out;
  }

  void addToCart(
    String productId,
    Map<String, String> selections,
    int quantity,
  ) {
    final product = repo.productById(productId);
    if (product == null) return;
    repo.addToCart(
      CartItem(
        product: product,
        selectedCustomizations: Map.from(selections),
        quantity: quantity,
      ),
    );
  }

  void removeAt(int index) => repo.removeFromCart(index);

  void clear() => repo.clearCart();

  void checkout() => repo.checkout();
}
