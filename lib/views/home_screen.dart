import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/viewmodels/home_viewmodel.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';
import 'package:the_code_cup/widgets/app_chrome.dart';
import 'package:the_code_cup/widgets/loyalty_card_block.dart';
import 'package:the_code_cup/widgets/product_blocks.dart';

class HomeScreen extends StatelessWidget {
  final HomeViewModel viewModel;
  final VoidCallback onOpenCart;
  final ValueChanged<String> onOpenDetails;
  final ValueChanged<int> onTabSelected;

  const HomeScreen({
    super.key,
    required this.viewModel,
    required this.onOpenCart,
    required this.onOpenDetails,
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
          userName: viewModel.userName,
          userInitial: viewModel.userInitial,
          loyaltyCard: viewModel.loyaltyCard,
          products: viewModel.products,
          onCartTap: onOpenCart,
          onProductTap: onOpenDetails,
        ),
      ),
    );
  }

  static PreferredSizeWidget? createAppBar() => null;

  static Widget createNavigationBar({
    required ValueChanged<int> onTabSelected,
  }) =>
      AppBottomNav(currentIndex: 0, onTabSelected: onTabSelected);

  static Widget createBody({
    required String userName,
    required String userInitial,
    required LoyaltyCardUi loyaltyCard,
    required List<ProductCardUi> products,
    required VoidCallback onCartTap,
    required ValueChanged<String> onProductTap,
  }) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _Header(
              name: userName,
              initial: userInitial,
              onCartTap: onCartTap,
            ),
            LoyaltyCardBlock(card: loyaltyCard, dark: true),
            CoffeeSection(
              products: products,
              onProductTap: onProductTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  final String initial;
  final VoidCallback onCartTap;

  const _Header({
    required this.name,
    required this.initial,
    required this.onCartTap,
  });

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning!';
    if (hour < 18) return 'Good afternoon!';
    return 'Good evening!';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onCartTap,
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.activeIcon,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              CircleAvatar(
                backgroundColor: AppColors.surface,
                radius: 20,
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
