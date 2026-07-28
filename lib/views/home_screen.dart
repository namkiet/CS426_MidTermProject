import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/models/product.dart';
import 'package:the_code_cup/viewmodels/home_viewmodel.dart';
import 'package:the_code_cup/views/details_screen.dart';
import 'package:the_code_cup/widgets/app_shell.dart';

class HomeScreen extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomeScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: 0,
      userProfile: viewModel.userProfile,
      viewModel: viewModel,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildLoyaltyCard(),
              _buildCoffeeSection(),
            ],
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning!';
    if (hour < 18) return 'Good afternoon!';
    return 'Good evening!';
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting(),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    viewModel.userProfile.name,
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
                  Icon(Icons.shopping_cart_outlined,
                      color: AppColors.activeIcon, size: 24),
                  const SizedBox(width: 16),
                  CircleAvatar(
                    backgroundColor: AppColors.surface,
                    radius: 20,
                    child: Text(
                      viewModel.userProfile.name.isNotEmpty
                          ? viewModel.userProfile.name[0].toUpperCase()
                          : '?',
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
        ],
      ),
    );
  }

  Widget _buildLoyaltyCard() {
    final card = viewModel.loyaltyCard;
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loyalty card',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOnDarkSecondary,
                ),
              ),
              Text(
                '${card.stampCount} / 8',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOnDarkSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                8,
                (i) => Icon(
                  i < card.stampCount
                      ? Icons.coffee_rounded
                      : Icons.coffee_outlined,
                  color: i < card.stampCount
                      ? AppColors.stampFilled
                      : AppColors.stampEmpty,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${8 - card.stampCount} more stamps to a free drink!',
            style: TextStyle(
              color: AppColors.textOnDarkSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoffeeSection() {
    final products = viewModel.products;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_cafe_rounded,
                  color: AppColors.textOnDarkSecondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Choose your coffee',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOnDarkSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) =>
                _buildCoffeeGridItem(context, products[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildCoffeeGridItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => DetailsScreen(product: product),
            transitionsBuilder: (_, __, ___, child) => child,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: SizedBox(
              width: double.infinity,
              child: product.imageUrl != null
                  ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildFallbackIcon(),
                    )
                  : _buildFallbackIcon(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  product.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Center(
      child: Icon(
        Icons.local_cafe_rounded,
        color: AppColors.primary,
        size: 44,
      ),
    );
  }

}
