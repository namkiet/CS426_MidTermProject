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
}
