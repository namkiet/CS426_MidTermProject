import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';

/// Shared 8-stamp row used inside loyalty cards.
class LoyaltyStampsRow extends StatelessWidget {
  final int stampCount;
  final double iconSize;

  const LoyaltyStampsRow({
    super.key,
    required this.stampCount,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        8,
        (i) => Icon(
          i < stampCount ? Icons.coffee_rounded : Icons.coffee_outlined,
          color: i < stampCount ? AppColors.stampFilled : AppColors.stampEmpty,
          size: iconSize,
        ),
      ),
    );
  }
}

enum LoyaltyCardStyle { onPrimary, onSurface }

/// Composable loyalty card block (home dark / rewards light).
class LoyaltyCardBlock extends StatelessWidget {
  final LoyaltyCardUi data;
  final LoyaltyCardStyle style;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry margin;

  const LoyaltyCardBlock({
    super.key,
    required this.data,
    this.style = LoyaltyCardStyle.onPrimary,
    this.onTap,
    this.margin = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    final onPrimary = style == LoyaltyCardStyle.onPrimary;
    final child = Container(
      margin: onPrimary ? margin : EdgeInsets.zero,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: onPrimary ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                onPrimary ? 'Loyalty card' : 'Loyalty Card',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: onPrimary
                      ? AppColors.textOnDarkSecondary
                      : AppColors.textPrimary,
                ),
              ),
              Text(
                data.countLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: onPrimary
                      ? AppColors.textOnDarkSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (onPrimary)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: LoyaltyStampsRow(stampCount: data.stampCount),
            )
          else
            LoyaltyStampsRow(stampCount: data.stampCount),
          if (onPrimary) ...[
            const SizedBox(height: 8),
            Text(
              data.subtitle,
              style: TextStyle(
                color: AppColors.textOnDarkSecondary,
                fontSize: 12,
              ),
            ),
          ] else if (data.canReset) ...[
            const SizedBox(height: 12),
            Text(
              data.subtitle,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return child;
    return GestureDetector(onTap: onTap, child: child);
  }
}
