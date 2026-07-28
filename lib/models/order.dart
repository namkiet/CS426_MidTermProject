import 'package:the_code_cup/models/cart_item.dart';

enum OrderStatus { ongoing, history }

class Order {
  final String id;
  final List<CartItem> items;
  OrderStatus status;
  final DateTime createdAt;

  Order({
    String? id,
    required this.items,
    this.status = OrderStatus.ongoing,
    DateTime? createdAt,
  })  : id = id ?? _generateId(),
        assert(items.isNotEmpty),
        createdAt = createdAt ?? DateTime.now();

  static int _counter = 0;
  static String _generateId() => 'ORD-${++_counter}';

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((e) => e.toJson()).toList(),
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String,
        items: (json['items'] as List<dynamic>)
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        status: OrderStatus.values.firstWhere(
            (s) => s.name == json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
