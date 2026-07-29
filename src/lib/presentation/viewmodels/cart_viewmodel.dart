import 'package:flutter/foundation.dart';
import 'package:the_code_cup/domain/models/cart_item.dart';
import 'package:the_code_cup/domain/services/cart_service.dart';
import 'package:the_code_cup/data/repositories/cart_repository.dart';
import 'package:the_code_cup/data/repositories/catalog_repository.dart';
import 'package:the_code_cup/presentation/viewmodels/ui_models.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository cartRepo;
  final CartService _cartService;

  CartViewModel({
    required CartRepository cartRepo,
    CartService? cartService,
  })  : cartRepo = cartRepo,
        _cartService = cartService ?? CartService() {
    cartRepo.addListener(notifyListeners);
  }

  @override
  void dispose() {
    cartRepo.removeListener(notifyListeners);
    super.dispose();
  }

  bool get isEmpty => cartRepo.items.isEmpty;

  int get itemCount => _cartService.countDistinctItems(cartRepo.items);

  String get totalLabel {
    return money(_cartService.calculateSubtotal(cartRepo.items));
  }

  List<CartLineUi> get lines {
    final groups = _buildGroups();
    final out = <CartLineUi>[];
    for (var gi = 0; gi < groups.length; gi++) {
      final flatIndices = groups[gi];
      final first = cartRepo.items[flatIndices.first];
      final totalQty =
          flatIndices.fold(0, (s, i) => s + cartRepo.items[i].quantity);
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
    for (var i = 0; i < cartRepo.items.length; i++) {
      final item = cartRepo.items[i];
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
    final product = _catalog.productById(productId);
    if (product == null) return;
    await cartRepo.add(
      CartItem(
        product: product,
        selectedCustomizations: Map.from(selections),
        quantity: quantity,
      ),
    );
  }

  // ponytail: static catalog, no ChangeNotifier needed — lazy is fine.
  // ignore: avoid_late_keyword
  late final _catalog = CatalogRepository();

  Future<void> replaceGroup(
    int groupIndex,
    String productId,
    Map<String, String> selections,
    int quantity,
  ) async {
    final groups = _buildGroups();
    if (groupIndex < 0 || groupIndex >= groups.length) return;
    await cartRepo.removeIndices(groups[groupIndex]);
    await addToCart(productId, selections, quantity);
  }

  Future<void> incrementGroup(int groupIndex) async {
    final groups = _buildGroups();
    if (groupIndex < 0 || groupIndex >= groups.length) return;
    final first = cartRepo.items[groups[groupIndex].first];
    await addToCart(first.product.id,
        Map.from(first.selectedCustomizations), 1);
  }

  Future<void> decrementGroup(int groupIndex) async {
    final groups = _buildGroups();
    if (groupIndex < 0 || groupIndex >= groups.length) return;
    final flatIndices = groups[groupIndex];
    final i = flatIndices.last;
    final item = cartRepo.items[i];
    if (item.quantity <= 1) {
      await cartRepo.removeIndices([i]);
    } else {
      await cartRepo.update(
        i,
        CartItem(
          product: item.product,
          selectedCustomizations: item.selectedCustomizations,
          quantity: item.quantity - 1,
        ),
      );
    }
  }

  Future<void> removeAt(int groupIndex) async {
    final groups = _buildGroups();
    if (groupIndex < 0 || groupIndex >= groups.length) return;
    await cartRepo.removeIndices(groups[groupIndex]);
  }

  Future<void> clear() => cartRepo.clearItems();
}
