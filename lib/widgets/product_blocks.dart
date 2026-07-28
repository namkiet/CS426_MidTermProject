import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';

class ProductGridCard extends StatelessWidget {
  final ProductCardUi product;
  final VoidCallback onTap;

  const ProductGridCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                        errorBuilder: (_, _, _) => const CoffeeFallbackIcon(),
                      )
                    : const CoffeeFallbackIcon(),
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
}

/// Dark panel + title + product grid. Home just drops this in.
class CoffeeSection extends StatelessWidget {
  final List<ProductCardUi> products;
  final ValueChanged<String> onProductTap;

  const CoffeeSection({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.local_cafe_rounded,
            title: 'Choose your coffee',
          ),
          const SizedBox(height: 16),
          ProductGrid(products: products, onProductTap: onProductTap),
        ],
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final List<ProductCardUi> products;
  final ValueChanged<String> onProductTap;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    // ponytail: shrinkWrap grid is fine for small seed menu; use CustomScrollView + SliverGrid if catalog exceeds 100 items
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductGridCard(
          product: product,
          onTap: () => onProductTap(product.id),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textOnDarkSecondary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textOnDarkSecondary,
          ),
        ),
      ],
    );
  }
}

class CoffeeFallbackIcon extends StatelessWidget {
  final double size;

  const CoffeeFallbackIcon({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.local_cafe_rounded,
        color: AppColors.primary,
        size: size,
      ),
    );
  }
}

class NetworkHeroImage extends StatelessWidget {
  final String? imageUrl;
  final double height;

  const NetworkHeroImage({
    super.key,
    required this.imageUrl,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const _FallbackBox(),
              )
            : const _FallbackBox(),
      ),
    );
  }
}

class _FallbackBox extends StatelessWidget {
  const _FallbackBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: const CoffeeFallbackIcon(size: 64),
    );
  }
}
