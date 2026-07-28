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
                        errorBuilder: (_, _, _) => const _FallbackIcon(),
                      )
                    : const _FallbackIcon(),
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

class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.local_cafe_rounded, color: AppColors.primary, size: 44),
    );
  }
}
