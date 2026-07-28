import 'package:flutter/foundation.dart';
import 'package:the_code_cup/data/seed_data.dart';
import 'package:the_code_cup/models/cart_item.dart';
import 'package:the_code_cup/models/loyalty_card.dart';
import 'package:the_code_cup/models/order.dart';
import 'package:the_code_cup/models/product.dart';
import 'package:the_code_cup/models/redeemable_item.dart';
import 'package:the_code_cup/models/reward_points.dart';
import 'package:the_code_cup/models/user_profile.dart';
import 'package:the_code_cup/services/local_storage.dart';

/// Single source of runtime app state. Views never touch this — ViewModels do.
class AppRepository extends ChangeNotifier {
  UserProfile userProfile = SeedData.defaultProfile;
  final LoyaltyCard loyaltyCard = LoyaltyCard(
    stampCount: SeedData.defaultStampCount,
  );
  final List<Order> orders = [];
  final List<CartItem> cartItems = [];
  RewardPoints rewardPoints = RewardPoints();

  List<Product> get products => SeedData.products;
  List<RedeemableItem> get redeemableItems => SeedData.redeemableItems;

  Product? productById(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  RedeemableItem? redeemableById(String id) {
    for (final i in redeemableItems) {
      if (i.id == id) return i;
    }
    return null;
  }

  void loadPersisted() {
    userProfile = LocalStorage.loadUserProfile() ?? SeedData.defaultProfile;
    loyaltyCard.stampCount = LocalStorage.loadStampCount();
    orders
      ..clear()
      ..addAll(LocalStorage.loadOrders());
    rewardPoints = LocalStorage.loadRewardPoints();
    cartItems
      ..clear()
      ..addAll(LocalStorage.loadCartItems());
    notifyListeners();
  }

  /// Best-effort persistence for app lifecycle transitions.
  ///
  /// The repository already persists after each user action, but the spec
  /// expects pause/resume/stop handling, so we also flush the full state when
  /// the app is backgrounded or about to detach.
  Future<void> persistAll() {
    return Future.wait([
      LocalStorage.saveUserProfile(userProfile),
      LocalStorage.saveStampCount(loyaltyCard.stampCount),
      LocalStorage.saveOrders(orders),
      LocalStorage.saveRewardPoints(rewardPoints),
      LocalStorage.saveCartItems(cartItems),
    ]);
  }

  // ── Profile ──

  Future<String?> updateName(String value) => _updateProfile(
    UserProfile(
      name: value,
      email: userProfile.email,
      phone: userProfile.phone,
      avatarUrl: userProfile.avatarUrl,
      address: userProfile.address,
    ),
  );

  Future<String?> updatePhone(String value) => _updateProfile(
    UserProfile(
      name: userProfile.name,
      email: userProfile.email,
      phone: value,
      avatarUrl: userProfile.avatarUrl,
      address: userProfile.address,
    ),
  );

  Future<String?> updateEmail(String value) => _updateProfile(
    UserProfile(
      name: userProfile.name,
      email: value,
      phone: userProfile.phone,
      avatarUrl: userProfile.avatarUrl,
      address: userProfile.address,
    ),
  );

  Future<String?> updateAddress(String value) => _updateProfile(
    UserProfile(
      name: userProfile.name,
      email: userProfile.email,
      phone: userProfile.phone,
      avatarUrl: userProfile.avatarUrl,
      address: value,
    ),
  );

  Future<String?> updateAvatar(String value) => _updateProfile(
    UserProfile(
      name: userProfile.name,
      email: userProfile.email,
      phone: userProfile.phone,
      avatarUrl: value,
      address: userProfile.address,
    ),
  );

  Future<String?> _updateProfile(UserProfile updated) async {
    try {
      userProfile = updated;
      await LocalStorage.saveUserProfile(updated);
      notifyListeners();
      return null;
    } on ArgumentError {
      return 'Invalid value for this field';
    }
  }

  // ── Cart ──

  Future<void> addToCart(CartItem item) async {
    cartItems.add(item);
    await LocalStorage.saveCartItems(cartItems);
    notifyListeners();
  }

  Future<void> removeFromCart(int index) async {
    if (index < 0 || index >= cartItems.length) return;
    cartItems.removeAt(index);
    await LocalStorage.saveCartItems(cartItems);
    notifyListeners();
  }

  Future<void> clearCart() async {
    cartItems.clear();
    await LocalStorage.saveCartItems(cartItems);
    notifyListeners();
  }

  Future<void> checkout() async {
    if (cartItems.isEmpty) return;
    final order = Order(items: List.from(cartItems));
    orders.add(order);
    await LocalStorage.saveOrders(orders);
    loyaltyCard.increment();
    await LocalStorage.saveStampCount(loyaltyCard.stampCount);
    rewardPoints.award(order.calculatePointsEarned(), order: order);
    await LocalStorage.saveRewardPoints(rewardPoints);
    cartItems.clear();
    await LocalStorage.saveCartItems(cartItems);
    notifyListeners();
  }

  // ── Orders ──

  Future<void> toggleOrderStatus(String orderId) async {
    final order = orders.where((o) => o.id == orderId).firstOrNull;
    if (order == null) return;
    order.toggleStatus();
    await LocalStorage.saveOrders(orders);
    notifyListeners();
  }

  // ── Rewards ──

  Future<void> resetLoyaltyCard() async {
    loyaltyCard.reset();
    await LocalStorage.saveStampCount(loyaltyCard.stampCount);
    notifyListeners();
  }

  Future<String?> redeemItem(String redeemableId) async {
    final item = redeemableById(redeemableId);
    if (item == null) return 'Item not found';
    try {
      rewardPoints.redeem(item.pointCost, redeemableItem: item);
      await LocalStorage.saveRewardPoints(rewardPoints);
      notifyListeners();
      return null;
    } on StateError catch (e) {
      return e.message;
    } on ArgumentError {
      return 'Invalid redemption';
    }
  }
}
