import 'package:flutter/material.dart';
import 'package:the_code_cup/core/constants/app_colors.dart';
import 'package:the_code_cup/presentation/viewmodels/ui_models.dart';

/// Stamp tray + labels. Home uses dark style; Rewards uses light + optional reset.
class LoyaltyCardBlock extends StatelessWidget {
  final LoyaltyCardUi card;
  final bool dark;
  final VoidCallback? onTap;

  const LoyaltyCardBlock({
    super.key,
    required this.card,
    this.dark = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      margin: dark ? const EdgeInsets.all(20) : EdgeInsets.zero,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dark ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dark ? 'Loyalty card' : 'Loyalty Card',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: dark
                      ? AppColors.textOnDarkSecondary
                      : AppColors.textPrimary,
                ),
              ),
              Text(
                card.countLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: dark
                      ? AppColors.textOnDarkSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (dark)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: StampTray(stampCount: card.stampCount),
            )
          else
            StampTray(stampCount: card.stampCount),
          if (dark) ...[
            const SizedBox(height: 8),
            Text(
              card.subtitle,
              style: const TextStyle(
                color: AppColors.textOnDarkSecondary,
                fontSize: 12,
              ),
            ),
          ] else if (card.canReset) ...[
            const SizedBox(height: 12),
            Text(
              card.subtitle,
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

class StampTray extends StatelessWidget {
  final int stampCount;

  const StampTray({super.key, required this.stampCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        8,
        (i) => Icon(
          i < stampCount ? Icons.coffee_rounded : Icons.coffee_outlined,
          color: i < stampCount ? AppColors.stampFilled : AppColors.stampEmpty,
          size: 28,
        ),
      ),
    );
  }
}
