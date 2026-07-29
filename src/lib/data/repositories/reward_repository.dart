import 'package:flutter/foundation.dart';
import 'package:the_code_cup/domain/models/loyalty_card.dart';
import 'package:the_code_cup/domain/models/order.dart';
import 'package:the_code_cup/domain/models/redeemable_item.dart';
import 'package:the_code_cup/domain/models/reward_points.dart';
import 'package:the_code_cup/data/preferences/local_storage.dart';
import 'package:the_code_cup/domain/services/reward_service.dart';

class RewardRepository extends ChangeNotifier {
  final RewardService _rewardService;
  final LoyaltyCard loyaltyCard;
  final RewardPoints rewardPoints;

  RewardRepository({
    RewardService? rewardService,
    LoyaltyCard? loyaltyCard,
    RewardPoints? rewardPoints,
  })  : _rewardService = rewardService ?? RewardService(),
        loyaltyCard = loyaltyCard ?? LoyaltyCard(),
        rewardPoints = rewardPoints ?? RewardPoints();

  Future<void> load() async {
    loyaltyCard.stampCount = LocalStorage.loadStampCount();
    final loaded = LocalStorage.loadRewardPoints();
    rewardPoints.balance = loaded.balance;
    rewardPoints.transactions
      ..clear()
      ..addAll(loaded.transactions);
    notifyListeners();
  }

  Future<void> persistStamps() =>
      LocalStorage.saveStampCount(loyaltyCard.stampCount);
  Future<void> persistPoints() => LocalStorage.saveRewardPoints(rewardPoints);

  Future<void> addStamp() async {
    _rewardService.addStamp(loyaltyCard);
    await persistStamps();
    notifyListeners();
  }

  Future<void> resetCard() async {
    _rewardService.resetCard(loyaltyCard);
    await persistStamps();
    notifyListeners();
  }

  Future<String?> redeemItem(RedeemableItem item) async {
    final error = _rewardService.redeemPoints(
      rewardPoints,
      item.pointCost,
      redeemableItem: item,
    );
    if (error != null) return error;
    await persistPoints();
    notifyListeners();
    return null;
  }

  Future<void> awardPoints(int amount, {Order? order}) async {
    _rewardService.awardPoints(rewardPoints, amount, order: order);
    await persistPoints();
    notifyListeners();
  }
}
