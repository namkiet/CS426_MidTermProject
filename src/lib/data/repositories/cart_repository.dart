import 'package:flutter/foundation.dart';
import 'package:the_code_cup/domain/models/cart_item.dart';
import 'package:the_code_cup/data/preferences/local_storage.dart';

class CartRepository extends ChangeNotifier {
  final List<CartItem> items = [];

  Future<void> load() async {
    items
      ..clear()
      ..addAll(LocalStorage.loadCartItems());
    notifyListeners();
  }

  Future<void> persist() => LocalStorage.saveCartItems(items);

  Future<void> add(CartItem item) async {
    items.add(item);
    await persist();
    notifyListeners();
  }

  Future<void> removeIndices(Iterable<int> indices) async {
    final sorted = indices.toList()..sort((a, b) => b.compareTo(a));
    for (final i in sorted) {
      if (i >= 0 && i < items.length) items.removeAt(i);
    }
    await persist();
    notifyListeners();
  }

  Future<void> update(int index, CartItem item) async {
    items[index] = item;
    await persist();
    notifyListeners();
  }

  Future<void> clearItems() async {
    items.clear();
    await persist();
    notifyListeners();
  }
}
