import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/viewmodels/rewards_viewmodel.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';
import 'package:the_code_cup/widgets/app_chrome.dart';
import 'package:the_code_cup/widgets/list_tiles.dart';

class RedeemRewardsScreen extends StatelessWidget {
  final RewardsViewModel viewModel;

  const RedeemRewardsScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => ScreenTemplate(
        appBar: createAppBar(),
        navigationBar: createNavigationBar(),
        body: createBody(
          availablePointsLabel: viewModel.availablePointsLabel,
          items: viewModel.redeemItems,
          onRedeemTap: (item) => _confirm(context, item),
        ),
      ),
    );
  }

  static PreferredSizeWidget createAppBar() =>
      const AppAppBar(title: 'Redeem Rewards', centerTitle: false);

  static Widget? createNavigationBar() => null;

  static Widget createBody({
    required String availablePointsLabel,
    required List<RedeemItemUi> items,
    required void Function(RedeemItemUi item) onRedeemTap,
  }) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SurfaceCard(
          child: Row(
            children: [
              const Icon(
                Icons.monetization_on,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                availablePointsLabel,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => RedeemItemTile(
            item: item,
            onTap: item.canAfford ? () => onRedeemTap(item) : null,
            onRedeem: item.canAfford ? () => onRedeemTap(item) : null,
          ),
        ),
      ],
    );
  }

  void _confirm(BuildContext context, RedeemItemUi item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Redemption'),
        content: Text(viewModel.confirmMessage(item.id)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.redeem(item.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Redeemed ${item.name}!'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
