import 'package:flutter/foundation.dart';
import 'package:the_code_cup/domain/models/transaction.dart';
import 'package:the_code_cup/domain/services/reward_service.dart';
import 'package:the_code_cup/core/utils/format.dart';
import 'package:the_code_cup/data/repositories/reward_repository.dart';
import 'package:the_code_cup/data/repositories/catalog_repository.dart';
import 'package:the_code_cup/presentation/viewmodels/ui_models.dart';

class RewardsViewModel extends ChangeNotifier {
  final RewardRepository _rewardRepo;
  final CatalogRepository _catalog;
  final RewardService _rewardService;

  RewardsViewModel({
    required RewardRepository rewardRepo,
    CatalogRepository? catalog,
    RewardService? rewardService,
  })  : _rewardRepo = rewardRepo,
        _catalog = catalog ?? CatalogRepository(),
        _rewardService = rewardService ?? RewardService() {
    _rewardRepo.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _rewardRepo.removeListener(notifyListeners);
    super.dispose();
  }

  String get balanceLabel => '${_rewardRepo.rewardPoints.balance}';

  String get totalEarnedLabel =>
      '${_rewardService.calculateTotalEarned(_rewardRepo.rewardPoints)} total earned';

  String get availablePointsLabel =>
      '${_rewardRepo.rewardPoints.balance} points available';

  LoyaltyCardUi get loyaltyCard {
    final n = _rewardRepo.loyaltyCard.stampCount;
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
    return _rewardRepo.rewardPoints.transactions.reversed.map((t) {
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
    final balance = _rewardRepo.rewardPoints.balance;
    return _catalog.redeemableItems
        .map(
          (i) => RedeemItemUi(
            id: i.id,
            name: i.name,
            costLabel: '${i.pointCost} points',
            canAfford: balance >= i.pointCost,
            imageUrl: i.imageUrl,
          ),
        )
        .toList();
  }

  Future<void> resetLoyaltyCard() => _rewardRepo.resetCard();

  Future<String?> redeem(String redeemableId) {
    final item = _catalog.redeemableById(redeemableId);
    if (item == null) return Future.value('Item not found');
    return _rewardRepo.redeemItem(item);
  }

  String confirmMessage(String redeemableId) {
    final item = _catalog.redeemableById(redeemableId);
    if (item == null) return '';
    return 'Redeem ${item.name} for ${item.pointCost} points?';
  }
}
