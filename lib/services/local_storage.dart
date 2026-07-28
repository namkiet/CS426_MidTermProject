import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_code_cup/models/cart_item.dart';
import 'package:the_code_cup/models/loyalty_card.dart';
import 'package:the_code_cup/models/order.dart';
import 'package:the_code_cup/models/reward_points.dart';
import 'package:the_code_cup/models/user_profile.dart';

class LocalStorage {
  static const _boxName = 'the_code_cup';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  // ── User Profile ──

  static Future<void> saveUserProfile(UserProfile profile) async {
    await _box.put('userProfile', profile.toJson());
  }

  static UserProfile? loadUserProfile() {
    final data = _box.get('userProfile');
    if (data == null) return null;
    return UserProfile.fromJson(Map<String, dynamic>.from(data));
  }

  // ── Loyalty Stamps ──

  static Future<void> saveStampCount(int count) async {
    await _box.put('stampCount', count);
  }

  static int loadStampCount() => _box.get('stampCount', defaultValue: 0) as int;

  // ── Orders ──

  static Future<void> saveOrders(List<Order> orders) async {
    await _box.put('orders',
        orders.map((o) => o.toJson()).toList());
  }

  static List<Order> loadOrders() {
    final data = _box.get('orders') as List<dynamic>?;
    if (data == null) return [];
    return data
        .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // ── Reward Points ──

  static Future<void> saveRewardPoints(RewardPoints rp) async {
    await _box.put('rewardPoints', rp.toJson());
  }

  static RewardPoints loadRewardPoints() {
    final data = _box.get('rewardPoints');
    if (data == null) return RewardPoints();
    return RewardPoints.fromJson(Map<String, dynamic>.from(data));
  }

  // ── Cart Items ──

  static Future<void> saveCartItems(List<CartItem> items) async {
    await _box.put('cartItems',
        items.map((i) => i.toJson()).toList());
  }

  static List<CartItem> loadCartItems() {
    final data = _box.get('cartItems') as List<dynamic>?;
    if (data == null) return [];
    return data
        .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
