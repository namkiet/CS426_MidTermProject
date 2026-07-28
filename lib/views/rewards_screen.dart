import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/viewmodels/rewards_viewmodel.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';
import 'package:the_code_cup/widgets/app_chrome.dart';
import 'package:the_code_cup/widgets/common_blocks.dart';
import 'package:the_code_cup/widgets/list_tiles.dart';
import 'package:the_code_cup/widgets/loyalty_card_block.dart';

class RewardsScreen extends StatelessWidget {
  final RewardsViewModel viewModel;
  final VoidCallback onOpenRedeem;
  final ValueChanged<int> onTabSelected;

  const RewardsScreen({
    super.key,
    required this.viewModel,
    required this.onOpenRedeem,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => ScreenTemplate(
        appBar: createAppBar(),
        navigationBar: createNavigationBar(onTabSelected: onTabSelected),
        body: createBody(
          balanceLabel: viewModel.balanceLabel,
          totalEarnedLabel: viewModel.totalEarnedLabel,
          loyaltyCard: viewModel.loyaltyCard,
          transactions: viewModel.transactions,
          onRedeem: onOpenRedeem,
          onResetLoyalty: viewModel.loyaltyCard.canReset
              ? () {
                  viewModel.resetLoyaltyCard();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Loyalty card reset!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              : null,
        ),
      ),
    );
  }

  static PreferredSizeWidget createAppBar() =>
      const AppAppBar(title: 'Rewards', centerTitle: false);

  static Widget createNavigationBar({
    required ValueChanged<int> onTabSelected,
  }) =>
      AppBottomNav(currentIndex: 1, onTabSelected: onTabSelected);

  static Widget createBody({
    required String balanceLabel,
    required String totalEarnedLabel,
    required LoyaltyCardUi loyaltyCard,
    required List<TransactionRowUi> transactions,
    required VoidCallback onRedeem,
    required VoidCallback? onResetLoyalty,
  }) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        PointsBalanceCard(
          balanceLabel: balanceLabel,
          totalEarnedLabel: totalEarnedLabel,
          onRedeem: onRedeem,
        ),
        const SizedBox(height: 24),
        LoyaltyCardBlock(card: loyaltyCard, onTap: onResetLoyalty),
        const SizedBox(height: 24),
        const Text(
          'Points History',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (transactions.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No transactions yet',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ),
          )
        else
          ...transactions.map((t) => TransactionRowTile(tx: t)),
      ],
    );
  }
}
