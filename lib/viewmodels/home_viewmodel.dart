import 'package:flutter/foundation.dart';
import 'package:the_code_cup/data/seed_data.dart';
import 'package:the_code_cup/models/cart_item.dart';
import 'package:the_code_cup/models/loyalty_card.dart';
import 'package:the_code_cup/models/order.dart';
import 'package:the_code_cup/models/product.dart';
import 'package:the_code_cup/models/reward_points.dart';
import 'package:the_code_cup/models/user_profile.dart';
import 'package:the_code_cup/services/local_storage.dart';

class HomeViewModel extends ChangeNotifier {
  final List<Product> _products = [];
  UserProfile _userProfile = SeedData.userProfile;
  final LoyaltyCard _loyaltyCard = SeedData.loyaltyCard;
  final List<Order> _orders = [];
  final List<CartItem> _cartItems = [];
  late RewardPoints _rewardPoints;

  HomeViewModel() {
    _rewardPoints = RewardPoints();
  }

  List<Product> get products => List.unmodifiable(_products);
  UserProfile get userProfile => _userProfile;
  LoyaltyCard get loyaltyCard => _loyaltyCard;
  List<Order> get orders => List.unmodifiable(_orders);
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  RewardPoints get rewardPoints => _rewardPoints;

  void setProducts(List<Product> products) {
    _products.clear();
    _products.addAll(products);
    notifyListeners();
  }

  /// Updates a profile field. Returns null on success, or an error message.
  String? updateProfileField(int index, String value) {
    if (index < 0 || index > 4) return 'Invalid field';
    try {
      final updated = switch (index) {
        0 => UserProfile(name: value, email: _userProfile.email, phone: _userProfile.phone, avatarUrl: _userProfile.avatarUrl, address: _userProfile.address),
        1 => UserProfile(name: _userProfile.name, email: _userProfile.email, phone: value, avatarUrl: _userProfile.avatarUrl, address: _userProfile.address),
        2 => UserProfile(name: _userProfile.name, email: value, phone: _userProfile.phone, avatarUrl: _userProfile.avatarUrl, address: _userProfile.address),
        3 => UserProfile(name: _userProfile.name, email: _userProfile.email, phone: _userProfile.phone, avatarUrl: _userProfile.avatarUrl, address: value),
        4 => UserProfile(name: _userProfile.name, email: _userProfile.email, phone: _userProfile.phone, avatarUrl: value, address: _userProfile.address),
        _ => _userProfile,
      };
      _userProfile = updated;
      SeedData.userProfile = updated;
      LocalStorage.saveUserProfile(updated);
      notifyListeners();
      return null;
    } on AssertionError {
      return 'Invalid value for this field';
    }
  }

  void loadPersistedState() {
    final savedProfile = LocalStorage.loadUserProfile();
    if (savedProfile != null) {
      _userProfile = savedProfile;
      SeedData.userProfile = savedProfile;
    }

    final savedStamps = LocalStorage.loadStampCount();
    if (savedStamps > 0) {
      SeedData.loyaltyCard = LoyaltyCard(stampCount: savedStamps);
    }
    _loyaltyCard.stampCount = SeedData.loyaltyCard.stampCount;

    final savedOrders = LocalStorage.loadOrders();
    _orders.addAll(savedOrders);

    _rewardPoints = LocalStorage.loadRewardPoints();

    final savedCart = LocalStorage.loadCartItems();
    _cartItems.addAll(savedCart);

    notifyListeners();
  }

  // ── Orders ──

  void addOrder(Order order) {
    _orders.add(order);
    LocalStorage.saveOrders(_orders);
    _loyaltyCard.increment();
    LocalStorage.saveStampCount(_loyaltyCard.stampCount);
    _rewardPoints.award(order.calculatePointsEarned(), order: order);
    LocalStorage.saveRewardPoints(_rewardPoints);
    notifyListeners();
  }

  void toggleOrderStatus(int index) {
    if (index < 0 || index >= _orders.length) return;
    _orders[index].toggleStatus();
    LocalStorage.saveOrders(_orders);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    LocalStorage.saveCartItems(_cartItems);
    notifyListeners();
  }

  // ── Cart ──

  void addToCart(CartItem item) {
    _cartItems.add(item);
    LocalStorage.saveCartItems(_cartItems);
    notifyListeners();
  }

  void removeFromCart(int index) {
    if (index < 0 || index >= _cartItems.length) return;
    _cartItems.removeAt(index);
    LocalStorage.saveCartItems(_cartItems);
    notifyListeners();
  }

  // ── Reward Points ──

  void redeemPoints(RewardPoints Function(RewardPoints) mutate) {
    mutate(_rewardPoints);
    LocalStorage.saveRewardPoints(_rewardPoints);
    notifyListeners();
  }

  void resetLoyaltyCard() {
    _loyaltyCard.reset();
    LocalStorage.saveStampCount(_loyaltyCard.stampCount);
    notifyListeners();
  }
}
