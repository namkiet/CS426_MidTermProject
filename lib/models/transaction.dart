import 'package:the_code_cup/models/order.dart';
import 'package:the_code_cup/models/redeemable_item.dart';

enum TransactionType { earn, redeem }

class Transaction {
  final TransactionType type;
  final int amount;
  final Order? order;
  final RedeemableItem? redeemableItem;
  final DateTime createdAt;

  Transaction({
    required this.type,
    required this.amount,
    this.order,
    this.redeemableItem,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now() {
    if (amount <= 0) {
      throw ArgumentError.value(amount, 'amount', 'Must be positive');
    }
  }

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'amount': amount,
    'order': order?.toJson(),
    'redeemableItem': redeemableItem?.toJson(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    type: TransactionType.values.firstWhere(
      (t) => t.name == json['type'] as String,
    ),
    amount: json['amount'] as int,
    order: json['order'] != null
        ? Order.fromJson(Map<String, dynamic>.from(json['order']))
        : null,
    redeemableItem: json['redeemableItem'] != null
        ? RedeemableItem.fromJson(
            Map<String, dynamic>.from(json['redeemableItem']),
          )
        : null,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
