import 'package:the_code_cup/models/order.dart';
import 'package:the_code_cup/utils/format.dart';
import 'package:the_code_cup/viewmodels/repo_view_model.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';

class OrdersViewModel extends RepoViewModel {
  OrdersViewModel(super.repo);

  List<OrderRowUi> get ongoing => _map(
    repo.orders.where((o) => o.status == OrderStatus.ongoing),
  );

  List<OrderRowUi> get history => _map(
    repo.orders.where((o) => o.status == OrderStatus.history),
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

  String toggleStatus(String orderId) {
    repo.toggleOrderStatus(orderId);
    final after = repo.orders.where((o) => o.id == orderId).firstOrNull;
    if (after == null) return '';
    return after.status == OrderStatus.ongoing
        ? 'Moved to Ongoing'
        : 'Moved to History';
  }
}
