import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/viewmodels/orders_viewmodel.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';
import 'package:the_code_cup/widgets/app_chrome.dart';
import 'package:the_code_cup/widgets/common_blocks.dart';
import 'package:the_code_cup/widgets/list_tiles.dart';

class OrdersScreen extends StatefulWidget {
  final OrdersViewModel viewModel;
  final ValueChanged<int> onTabSelected;

  const OrdersScreen({
    super.key,
    required this.viewModel,
    required this.onTabSelected,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _toggle(String orderId) async {
    final message = await widget.viewModel.toggleStatus(orderId);
    if (!mounted) return;
    if (message.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) => ScreenTemplate(
        appBar: createAppBar(tabController: _tabController),
        navigationBar: createNavigationBar(onTabSelected: widget.onTabSelected),
        body: createBody(
          tabController: _tabController,
          ongoing: widget.viewModel.ongoing,
          history: widget.viewModel.history,
          onToggle: (orderId) {
            _toggle(orderId);
          },
        ),
      ),
    );
  }

  static PreferredSizeWidget createAppBar({
    required TabController tabController,
  }) =>
      AppAppBar(
        title: 'My Orders',
        centerTitle: false,
        bottom: TabBar(
          controller: tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Ongoing'),
            Tab(text: 'History'),
          ],
        ),
      );

  static Widget createNavigationBar({
    required ValueChanged<int> onTabSelected,
  }) =>
      AppBottomNav(currentIndex: 2, onTabSelected: onTabSelected);

  static Widget createBody({
    required TabController tabController,
    required List<OrderRowUi> ongoing,
    required List<OrderRowUi> history,
    required ValueChanged<String> onToggle,
  }) =>
      TabBarView(
        controller: tabController,
        children: [
          _OrderList(orders: ongoing, onToggle: onToggle),
          _OrderList(orders: history, onToggle: onToggle),
        ],
      );
}

class _OrderList extends StatelessWidget {
  final List<OrderRowUi> orders;
  final ValueChanged<String> onToggle;

  const _OrderList({required this.orders, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const EmptyStateText('No orders');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) => OrderRowTile(
        order: orders[index],
        onToggle: () => onToggle(orders[index].id),
      ),
    );
  }
}
