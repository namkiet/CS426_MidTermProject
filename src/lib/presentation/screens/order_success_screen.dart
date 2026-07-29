import 'package:flutter/material.dart';
import 'package:the_code_cup/core/constants/app_colors.dart';
import 'package:the_code_cup/presentation/viewmodels/orders_viewmodel.dart';
import 'package:the_code_cup/presentation/widgets/app_chrome.dart';
import 'package:the_code_cup/presentation/widgets/common_blocks.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrdersViewModel viewModel;
  final VoidCallback onTrackOrder;

  const OrderSuccessScreen({
    super.key,
    required this.viewModel,
    required this.onTrackOrder,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      appBar: createAppBar(),
      navigationBar: createNavigationBar(),
      body: createBody(onTrackOrder: onTrackOrder),
    );
  }

  static PreferredSizeWidget createAppBar() => const AppAppBar();

  static Widget? createNavigationBar() => null;

  static Widget createBody({required VoidCallback onTrackOrder}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: AppColors.primary,
              size: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              'Order Confirmed!',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your order has been placed successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Track My Order',
              onPressed: onTrackOrder,
            ),
          ],
        ),
      ),
    );
  }
}
