import 'package:the_code_cup/models/order.dart';
import 'package:the_code_cup/models/redeemable_item.dart';
import 'package:the_code_cup/models/transaction.dart';

class RewardPoints {
  int balance;
  final List<Transaction> transactions;

  RewardPoints({this.balance = 0}) : transactions = [];

  void award(int amount, {Order? order}) {
    balance += amount;
    transactions.add(
      Transaction(type: TransactionType.earn, amount: amount, order: order),
    );
  }

  void redeem(int amount, {required RedeemableItem redeemableItem}) {
    if (amount <= 0) {
      throw ArgumentError.value(amount, 'amount', 'Must be positive');
    }
    if (amount > balance) {
      throw StateError('Insufficient points');
    }
    balance -= amount;
    transactions.add(
      Transaction(
        type: TransactionType.redeem,
        amount: amount,
        redeemableItem: redeemableItem,
      ),
    );
  }

  int calculateTotalEarned() {
    return transactions
        .where((t) => t.type == TransactionType.earn)
        .fold(0, (sum, t) => sum + t.amount);
  }

  Map<String, dynamic> toJson() => {
    'balance': balance,
    'transactions': transactions.map((t) => t.toJson()).toList(),
  };

  factory RewardPoints.fromJson(Map<String, dynamic> json) {
    final rp = RewardPoints(balance: json['balance'] as int);
    rp.transactions.addAll(
      (json['transactions'] as List<dynamic>).map(
        (t) => Transaction.fromJson(Map<String, dynamic>.from(t)),
      ),
    );
    return rp;
  }
}
