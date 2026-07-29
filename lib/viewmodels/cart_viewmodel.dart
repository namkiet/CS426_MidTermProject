import 'package:the_code_cup/models/cart_item.dart';
import 'package:the_code_cup/viewmodels/repo_view_model.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';

class CartViewModel extends RepoViewModel {
  CartViewModel(super.repo);

  bool get isEmpty => repo.cartItems.isEmpty;

  int get itemCount {
    final seen = <String>{};
    for (final item in repo.cartItems) {
      seen.add(_groupKey(item));
    }
    return seen.length;
  }

  String get totalLabel {
    final total = repo.cartItems.fold<double>(
      0,
      (sum, item) => sum + item.calculateSubtotal(),
    );
    return money(total);
  }

  List<CartLineUi> get lines {
    final groups = _buildGroups();
    final out = <CartLineUi>[];
    for (var gi = 0; gi < groups.length; gi++) {
      final flatIndices = groups[gi];
      final first = repo.cartItems[flatIndices.first];
      final totalQty =
          flatIndices.fold(0, (s, i) => s + repo.cartItems[i].quantity);
      out.add(
        CartLineUi(
          index: gi,
          dismissKey: '${first.product.id}:${_custKey(first)}',
          productId: first.product.id,
          name: first.product.name,
          customizations: first.selectedCustomizations.values.join(', '),
          quantity: totalQty,
          quantityLabel: 'x$totalQty',
          selections: Map.from(first.selectedCustomizations),
        ),
      );
    }
    return out;
  }

  List<List<int>> _buildGroups() {
    final grouped = <String, List<int>>{};
    for (var i = 0; i < repo.cartItems.length; i++) {
      final item = repo.cartItems[i];
      grouped.putIfAbsent(_groupKey(item), () => []).add(i);
    }
    return grouped.values.toList();
  }

  String _groupKey(CartItem item) =>
      '${item.product.id}:${item.selectedCustomizations}';

  String _custKey(CartItem item) => item.selectedCustomizations.toString();

  Future<void> addToCart(
    String productId,
    Map<String, String> selections,
    int quantity,
  ) async {
    final product = repo.productById(productId);
    if (product == null) return;
    await repo.addToCart(
      CartItem(
        product: product,
        selectedCustomizations: Map.from(selections),
        quantity: quantity,
      ),
    );
  }

  Future<void> replaceGroup(
    int groupIndex,
    String productId,
    Map<String, String> selections,
    int quantity,
  ) async {
    final groups = _buildGroups();
    if (groupIndex < 0 || groupIndex >= groups.length) return;
    await repo.removeCartItems(groups[groupIndex]);
    await addToCart(productId, selections, quantity);
  }

  Future<void> incrementGroup(int groupIndex) async {
    final groups = _buildGroups();
    if (groupIndex < 0 || groupIndex >= groups.length) return;
    final first = repo.cartItems[groups[groupIndex].first];
    await addToCart(first.product.id,
        Map.from(first.selectedCustomizations), 1);
  }

  Future<void> decrementGroup(int groupIndex) async {
    final groups = _buildGroups();
    if (groupIndex < 0 || groupIndex >= groups.length) return;
    final flatIndices = groups[groupIndex];
    final i = flatIndices.last;
    final item = repo.cartItems[i];
    if (item.quantity <= 1) return;
    await repo.updateCartItem(
      i,
      CartItem(
        product: item.product,
        selectedCustomizations: item.selectedCustomizations,
        quantity: item.quantity - 1,
      ),
    );
  }

  Future<void> removeAt(int groupIndex) async {
    final groups = _buildGroups();
    if (groupIndex < 0 || groupIndex >= groups.length) return;
    await repo.removeCartItems(groups[groupIndex]);
  }

  Future<void> clear() => repo.clearCart();

  Future<void> checkout() => repo.checkout();
}
