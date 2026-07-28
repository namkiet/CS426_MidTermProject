import 'package:the_code_cup/models/transaction.dart';
import 'package:the_code_cup/utils/format.dart';
import 'package:the_code_cup/viewmodels/repo_view_model.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';

class RewardsViewModel extends RepoViewModel {
  RewardsViewModel(super.repo);

  String get balanceLabel => '${repo.rewardPoints.balance}';

  String get totalEarnedLabel =>
      '${repo.rewardPoints.calculateTotalEarned()} total earned';

  String get availablePointsLabel =>
      '${repo.rewardPoints.balance} points available';

  LoyaltyCardUi get loyaltyCard {
    final n = repo.loyaltyCard.stampCount;
    return LoyaltyCardUi(
      stampCount: n,
      countLabel: '$n / 8',
      subtitle: n >= 8
          ? 'Tap to reset and claim your free drink!'
          : '${8 - n} more stamps to a free drink!',
      canReset: n >= 8,
    );
  }

  List<TransactionRowUi> get transactions {
    return repo.rewardPoints.transactions.reversed.map((t) {
      final isEarn = t.type == TransactionType.earn;
      final title = isEarn
          ? 'Earned${t.order != null ? ' (${t.order!.id})' : ''}'
          : 'Redeemed${t.redeemableItem != null ? ' — ${t.redeemableItem!.name}' : ''}';
      return TransactionRowUi(
        title: title,
        dateLabel: formatDate(t.createdAt),
        pointsLabel: '${isEarn ? '+' : '-'}${t.amount} pts',
        isEarn: isEarn,
      );
    }).toList();
  }

  List<RedeemItemUi> get redeemItems {
    final balance = repo.rewardPoints.balance;
    return repo.redeemableItems
        .map(
          (i) => RedeemItemUi(
            id: i.id,
            name: i.name,
            costLabel: '${i.pointCost} points',
            canAfford: balance >= i.pointCost,
          ),
        )
        .toList();
  }

  Future<void> resetLoyaltyCard() => repo.resetLoyaltyCard();

  Future<String?> redeem(String redeemableId) => repo.redeemItem(redeemableId);

  String confirmMessage(String redeemableId) {
    final item = repo.redeemableById(redeemableId);
    if (item == null) return '';
    return 'Redeem ${item.name} for ${item.pointCost} points?';
  }
}
