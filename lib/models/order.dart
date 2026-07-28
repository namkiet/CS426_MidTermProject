import 'package:the_code_cup/models/cart_item.dart';

enum OrderStatus { ongoing, history }

class Order {
  final List<CartItem> items;
  OrderStatus status;
  final DateTime createdAt;

  Order({
    required this.items,
    this.status = OrderStatus.ongoing,
    DateTime? createdAt,
  })  : assert(items.isNotEmpty),
      createdAt = createdAt ?? DateTime.now();

  double calculateTotalPrice() {
    return items.fold(0.0, (sum, item) => sum + item.calculateSubtotal());
  }

  int calculatePointsEarned() {
    return (calculateTotalPrice() / 10000).floor();
  }

  void toggleStatus() {
    status =
        status == OrderStatus.ongoing ? OrderStatus.history : OrderStatus.ongoing;
  }
}
