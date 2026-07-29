import 'package:the_code_cup/data/repositories/cart_repository.dart';
import 'package:the_code_cup/data/repositories/order_repository.dart';
import 'package:the_code_cup/data/repositories/reward_repository.dart';
import 'package:the_code_cup/data/repositories/profile_repository.dart';
import 'package:the_code_cup/presentation/viewmodels/cart_viewmodel.dart';
import 'package:the_code_cup/presentation/viewmodels/home_viewmodel.dart';
import 'package:the_code_cup/presentation/viewmodels/orders_viewmodel.dart';
import 'package:the_code_cup/presentation/viewmodels/profile_viewmodel.dart';
import 'package:the_code_cup/presentation/viewmodels/rewards_viewmodel.dart';
import 'package:the_code_cup/domain/services/order_service.dart';
import 'package:the_code_cup/domain/services/reward_service.dart';

/// Composition root: wires repositories → ViewModels.
class AppViewModels {
  final CartRepository cartRepo;
  final OrderRepository orderRepo;
  final RewardRepository rewardRepo;
  final ProfileRepository profileRepo;
  final OrderService orderService;

  late final HomeViewModel home;
  late final CartViewModel cart;
  late final OrdersViewModel orders;
  late final RewardsViewModel rewards;
  late final ProfileViewModel profile;

  AppViewModels({
    CartRepository? cartRepo,
    OrderRepository? orderRepo,
    RewardRepository? rewardRepo,
    ProfileRepository? profileRepo,
    OrderService? orderService,
    RewardService? rewardService,
  })  : cartRepo = cartRepo ?? CartRepository(),
        orderRepo = orderRepo ?? OrderRepository(),
        rewardRepo = rewardRepo ??
            RewardRepository(rewardService: rewardService ?? RewardService()),
        profileRepo = profileRepo ?? ProfileRepository(),
        orderService = orderService ?? OrderService() {
    home = HomeViewModel(
      cartRepo: this.cartRepo,
      rewardRepo: this.rewardRepo,
      profileRepo: this.profileRepo,
    );
    cart = CartViewModel(cartRepo: this.cartRepo);
    orders = OrdersViewModel(orderRepo: this.orderRepo);
    rewards = RewardsViewModel(rewardRepo: this.rewardRepo);
    profile = ProfileViewModel(profileRepo: this.profileRepo);
  }

  /// In-memory defaults — no persistence loaded. Useful for tests.
  factory AppViewModels.create() => AppViewModels();

  void loadPersisted() {
    cartRepo.load();
    orderRepo.load();
    rewardRepo.load();
    profileRepo.load();
  }

  Future<void> persistAll() => Future.wait([
    cartRepo.persist(),
    orderRepo.persist(),
    rewardRepo.persistStamps(),
    rewardRepo.persistPoints(),
    profileRepo.persist(),
  ]);

  Future<void> checkout() async {
    if (cartRepo.items.isEmpty) return;
    final order = orderService.createOrder(cartRepo.items, rewardRepo);
    await orderRepo.add(order);
    await cartRepo.clearItems();
  }

  void dispose() {
    home.dispose();
    cart.dispose();
    orders.dispose();
    rewards.dispose();
    profile.dispose();
    cartRepo.dispose();
    orderRepo.dispose();
    rewardRepo.dispose();
    profileRepo.dispose();
  }
}
