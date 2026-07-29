import 'package:flutter/foundation.dart';
import 'package:the_code_cup/domain/models/order.dart';
import 'package:the_code_cup/core/utils/format.dart';
import 'package:the_code_cup/data/repositories/order_repository.dart';
import 'package:the_code_cup/presentation/viewmodels/ui_models.dart';

class OrdersViewModel extends ChangeNotifier {
  final OrderRepository _orderRepo;

  OrdersViewModel({required OrderRepository orderRepo})
      : _orderRepo = orderRepo {
    _orderRepo.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _orderRepo.removeListener(notifyListeners);
    super.dispose();
  }

  List<OrderRowUi> get ongoing => _map(
    _orderRepo.orders.where((o) => o.status == OrderStatus.ongoing),
  );

  List<OrderRowUi> get history => _map(
    _orderRepo.orders.where((o) => o.status == OrderStatus.history),
  );

  List<OrderRowUi> _map(Iterable<Order> orders) => orders
      .map(
        (o) => OrderRowUi(
          id: o.id,
          statusLabel:
              o.status == OrderStatus.ongoing ? 'Ongoing' : 'History',
          isOngoing: o.status == OrderStatus.ongoing,
          itemsSummary: o.items.map((i) => i.product.name).join(', '),
          priceLabel: money(o.calculateTotalPrice()),
          dateLabel: formatDate(o.createdAt),
        ),
      )
      .toList();

  Future<String> toggleStatus(String orderId) async {
    final wasOngoing = _orderRepo.orders
        .where((o) => o.id == orderId)
        .firstOrNull
        ?.status == OrderStatus.ongoing;
    await _orderRepo.toggleStatus(orderId);
    return wasOngoing ? 'Moved to History' : 'Moved to Ongoing';
  }
}
