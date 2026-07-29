import 'package:the_code_cup/domain/models/cart_item.dart';

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
  }) : id = id ?? _generateId(),
       createdAt = createdAt ?? DateTime.now() {
    if (items.isEmpty) {
      throw ArgumentError.value(items, 'items', 'Must not be empty');
    }
  }

  // ponytail: timestamp ids avoid restart collisions; UUID if you need offline uniqueness
  static String _generateId() =>
      'ORD-${DateTime.now().millisecondsSinceEpoch}';

  double calculateTotalPrice() {
    return items.fold(0.0, (sum, item) => sum + item.calculateSubtotal());
  }

  int calculatePointsEarned() {
    return (calculateTotalPrice() / 10000).floor();
  }

  void toggleStatus() {
    status = status == OrderStatus.ongoing
        ? OrderStatus.history
        : OrderStatus.ongoing;
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
        .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    status: OrderStatus.values.firstWhere(
      (s) => s.name == json['status'] as String,
    ),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
