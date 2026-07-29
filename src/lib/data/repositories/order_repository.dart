import 'package:flutter/foundation.dart';
import 'package:the_code_cup/domain/models/order.dart';
import 'package:the_code_cup/data/preferences/local_storage.dart';

class OrderRepository extends ChangeNotifier {
  final List<Order> orders = [];

  Future<void> load() async {
    orders
      ..clear()
      ..addAll(LocalStorage.loadOrders());
    notifyListeners();
  }

  Future<void> persist() => LocalStorage.saveOrders(orders);

  Future<void> add(Order order) async {
    orders.add(order);
    await persist();
    notifyListeners();
  }

  Future<void> toggleStatus(String orderId) async {
    final order = orders.where((o) => o.id == orderId).firstOrNull;
    if (order == null) return;
    order.toggleStatus();
    await persist();
    notifyListeners();
  }
}
