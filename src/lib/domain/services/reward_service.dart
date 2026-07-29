import 'package:the_code_cup/domain/models/loyalty_card.dart';
import 'package:the_code_cup/domain/models/order.dart';
import 'package:the_code_cup/domain/models/redeemable_item.dart';
import 'package:the_code_cup/domain/models/reward_points.dart';
import 'package:the_code_cup/domain/models/transaction.dart';

class RewardService {
  void awardPoints(RewardPoints points, int amount, {Order? order}) {
    points.balance += amount;
    points.transactions.add(
      Transaction(type: TransactionType.earn, amount: amount, order: order),
    );
  }

  /// Returns null on success, error message on failure.
  String? redeemPoints(
    RewardPoints points,
    int amount, {
    required RedeemableItem redeemableItem,
  }) {
    if (amount <= 0) return 'Invalid amount';
    if (amount > points.balance) return 'Insufficient points';

    points.balance -= amount;
    points.transactions.add(
      Transaction(
        type: TransactionType.redeem,
        amount: amount,
        redeemableItem: redeemableItem,
      ),
    );
    return null;
  }

  bool canRedeem(RewardPoints points, int required) =>
      points.balance >= required;

  int calculateTotalEarned(RewardPoints points) {
    return points.transactions
        .where((t) => t.type == TransactionType.earn)
        .fold(0, (sum, t) => sum + t.amount);
  }

  void addStamp(LoyaltyCard card) {
    if (card.stampCount < 8) card.stampCount++;
  }

  void resetCard(LoyaltyCard card) {
    if (card.stampCount == 8) card.stampCount = 0;
  }
}
