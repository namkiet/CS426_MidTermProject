import 'package:the_code_cup/models/order.dart';
import 'package:the_code_cup/models/redeemable_item.dart';
import 'package:the_code_cup/models/transaction.dart';

class RewardPoints {
  int balance;
  final List<Transaction> transactions;

  RewardPoints({this.balance = 0}) : transactions = [];

  void award(int amount, {Order? order}) {
    balance += amount;
    transactions.add(Transaction(
      type: TransactionType.earn,
      amount: amount,
      order: order,
    ));
  }

  void redeem(int amount, {required RedeemableItem redeemableItem}) {
    assert(amount > 0);
    if (amount > balance) {
      throw StateError('Insufficient points');
    }
    balance -= amount;
    transactions.add(Transaction(
      type: TransactionType.redeem,
      amount: amount,
      redeemableItem: redeemableItem,
    ));
  }

  int calculateTotalEarned() {
    return transactions
        .where((t) => t.type == TransactionType.earn)
        .fold(0, (sum, t) => sum + t.amount);
  }
}
