import 'package:the_code_cup/repositories/app_repository.dart';
import 'package:the_code_cup/viewmodels/cart_viewmodel.dart';
import 'package:the_code_cup/viewmodels/home_viewmodel.dart';
import 'package:the_code_cup/viewmodels/orders_viewmodel.dart';
import 'package:the_code_cup/viewmodels/profile_viewmodel.dart';
import 'package:the_code_cup/viewmodels/rewards_viewmodel.dart';

/// Wires feature ViewModels to one shared repository.
class AppViewModels {
  final AppRepository repo;
  late final HomeViewModel home;
  late final CartViewModel cart;
  late final OrdersViewModel orders;
  late final RewardsViewModel rewards;
  late final ProfileViewModel profile;

  AppViewModels(this.repo) {
    home = HomeViewModel(repo);
    cart = CartViewModel(repo);
    orders = OrdersViewModel(repo);
    rewards = RewardsViewModel(repo);
    profile = ProfileViewModel(repo);
  }

  /// In-memory defaults (no Hive). Useful for widget tests.
  factory AppViewModels.create() => AppViewModels(AppRepository());

  void dispose() {
    home.dispose();
    cart.dispose();
    orders.dispose();
    rewards.dispose();
    profile.dispose();
    repo.dispose();
  }
}
