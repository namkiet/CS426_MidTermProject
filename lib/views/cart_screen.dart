import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/viewmodels/cart_viewmodel.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';
import 'package:the_code_cup/widgets/app_chrome.dart';
import 'package:the_code_cup/widgets/common_blocks.dart';
import 'package:the_code_cup/widgets/list_tiles.dart';

class CartScreen extends StatelessWidget {
  final CartViewModel viewModel;
  final VoidCallback onCheckoutSuccess;

  const CartScreen({
    super.key,
    required this.viewModel,
    required this.onCheckoutSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => ScreenTemplate(
        appBar: createAppBar(),
        navigationBar: createNavigationBar(
          isEmpty: viewModel.isEmpty,
          totalLabel: viewModel.totalLabel,
          onCheckout: () async {
            await viewModel.checkout();
            onCheckoutSuccess();
          },
        ),
        body: createBody(
          isEmpty: viewModel.isEmpty,
          lines: viewModel.lines,
          onDismissed: (index) {
            viewModel.removeAt(index);
          },
        ),
      ),
    );
  }

  static PreferredSizeWidget createAppBar() =>
      const AppAppBar(title: 'My Cart');

  static Widget? createNavigationBar({
    required bool isEmpty,
    required String totalLabel,
    required VoidCallback onCheckout,
  }) {
    if (isEmpty) return null;
    return BottomActionBar(
      child: Row(
        children: [
          Expanded(
            child: Text(
              totalLabel,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          PrimaryButton(label: 'Checkout', onPressed: onCheckout),
        ],
      ),
    );
  }

  static Widget createBody({
    required bool isEmpty,
    required List<CartLineUi> lines,
    required ValueChanged<int> onDismissed,
  }) {
    if (isEmpty) return const EmptyStateText('Your cart is empty');
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: lines.length,
      itemBuilder: (context, index) => CartLineTile(
        line: lines[index],
        onDismissed: onDismissed,
      ),
    );
  }
}
