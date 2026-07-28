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
  void persistAll() {
    LocalStorage.saveUserProfile(userProfile);
    LocalStorage.saveStampCount(loyaltyCard.stampCount);
    LocalStorage.saveOrders(orders);
    LocalStorage.saveRewardPoints(rewardPoints);
    LocalStorage.saveCartItems(cartItems);
  }

  // ── Profile ──

  String? updateName(String value) => _updateProfile(
    UserProfile(
      name: value,
      email: userProfile.email,
      phone: userProfile.phone,
      avatarUrl: userProfile.avatarUrl,
      address: userProfile.address,
    ),
  );

  String? updatePhone(String value) => _updateProfile(
    UserProfile(
      name: userProfile.name,
      email: userProfile.email,
      phone: value,
      avatarUrl: userProfile.avatarUrl,
      address: userProfile.address,
    ),
  );

  String? updateEmail(String value) => _updateProfile(
    UserProfile(
      name: userProfile.name,
      email: value,
      phone: userProfile.phone,
      avatarUrl: userProfile.avatarUrl,
      address: userProfile.address,
    ),
  );

  String? updateAddress(String value) => _updateProfile(
    UserProfile(
      name: userProfile.name,
      email: userProfile.email,
      phone: userProfile.phone,
      avatarUrl: userProfile.avatarUrl,
      address: value,
    ),
  );

  String? updateAvatar(String value) => _updateProfile(
    UserProfile(
      name: userProfile.name,
      email: userProfile.email,
      phone: userProfile.phone,
      avatarUrl: value,
      address: userProfile.address,
    ),
  );

  String? _updateProfile(UserProfile updated) {
    try {
      userProfile = updated;
      LocalStorage.saveUserProfile(updated);
      notifyListeners();
      return null;
    } on AssertionError {
      return 'Invalid value for this field';
    }
  }

  // ── Cart ──

  void addToCart(CartItem item) {
    cartItems.add(item);
    LocalStorage.saveCartItems(cartItems);
    notifyListeners();
  }

  void removeFromCart(int index) {
    if (index < 0 || index >= cartItems.length) return;
    cartItems.removeAt(index);
    LocalStorage.saveCartItems(cartItems);
    notifyListeners();
  }

  void clearCart() {
    cartItems.clear();
    LocalStorage.saveCartItems(cartItems);
    notifyListeners();
  }

  void checkout() {
    if (cartItems.isEmpty) return;
    final order = Order(items: List.from(cartItems));
    orders.add(order);
    LocalStorage.saveOrders(orders);
    loyaltyCard.increment();
    LocalStorage.saveStampCount(loyaltyCard.stampCount);
    rewardPoints.award(order.calculatePointsEarned(), order: order);
    LocalStorage.saveRewardPoints(rewardPoints);
    cartItems.clear();
    LocalStorage.saveCartItems(cartItems);
    notifyListeners();
  }

  // ── Orders ──

  void toggleOrderStatus(String orderId) {
    final order = orders.where((o) => o.id == orderId).firstOrNull;
    if (order == null) return;
    order.toggleStatus();
    LocalStorage.saveOrders(orders);
    notifyListeners();
  }

  // ── Rewards ──

  void resetLoyaltyCard() {
    loyaltyCard.reset();
    LocalStorage.saveStampCount(loyaltyCard.stampCount);
    notifyListeners();
  }

  String? redeemItem(String redeemableId) {
    final item = redeemableById(redeemableId);
    if (item == null) return 'Item not found';
    try {
      rewardPoints.redeem(item.pointCost, redeemableItem: item);
      LocalStorage.saveRewardPoints(rewardPoints);
      notifyListeners();
      return null;
    } on StateError catch (e) {
      return e.message;
    } on AssertionError {
      return 'Invalid redemption';
    }
  }
}
