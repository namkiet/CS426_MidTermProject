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
  })  : assert(amount > 0),
      createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'amount': amount,
        'order': order?.toJson(),
        'redeemableItem': redeemableItem?.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        type: TransactionType.values.firstWhere(
            (t) => t.name == json['type'] as String),
        amount: json['amount'] as int,
        order: json['order'] != null
            ? Order.fromJson(json['order'] as Map<String, dynamic>)
            : null,
        redeemableItem: json['redeemableItem'] != null
            ? RedeemableItem.fromJson(
                json['redeemableItem'] as Map<String, dynamic>)
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
