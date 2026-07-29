import 'package:the_code_cup/domain/models/cart_item.dart';
import 'package:the_code_cup/domain/models/order.dart';
import 'package:the_code_cup/domain/services/cart_service.dart';
import 'package:the_code_cup/data/repositories/reward_repository.dart';

class OrderService {
  final CartService _cartService;

  OrderService({CartService? cartService})
      : _cartService = cartService ?? CartService();

  /// Create an order from cart items, award stamps and points.
  Order createOrder(List<CartItem> items, RewardRepository rewardRepo) {
    final order = Order(items: List.from(items));
    final points = _cartService.calculateSubtotal(items) ~/ 10000;
    rewardRepo.addStamp();
    rewardRepo.awardPoints(points, order: order);
    return order;
  }

  double calculateTotal(Order order) {
    return order.items.fold<double>(
      0.0,
      (sum, item) => sum + _cartService.calculateItemTotal(item),
    );
  }
}
