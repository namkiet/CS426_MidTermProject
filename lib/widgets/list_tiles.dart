import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';

class CartLineTile extends StatelessWidget {
  final CartLineUi line;
  final ValueChanged<int> onDismissed;

  const CartLineTile({
    super.key,
    required this.line,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(line.dismissKey),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => onDismissed(line.index),
      child: SurfaceCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (line.customizations.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      line.customizations,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              line.quantityLabel,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderRowTile extends StatelessWidget {
  final OrderRowUi order;
  final VoidCallback onToggle;

  const OrderRowTile({
    super.key,
    required this.order,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(order.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onToggle();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
      ),
      child: SurfaceCard(
        borderRadius: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: order.isOngoing
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : AppColors.textSecondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: order.isOngoing
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              order.itemsSummary,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.priceLabel,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  order.dateLabel,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionRowTile extends StatelessWidget {
  final TransactionRowUi tx;

  const TransactionRowTile({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            tx.isEarn ? Icons.add_circle_outline : Icons.remove_circle_outline,
            color: tx.isEarn ? Colors.green : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tx.dateLabel,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            tx.pointsLabel,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: tx.isEarn ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

class RedeemItemTile extends StatelessWidget {
  final RedeemItemUi item;
  final VoidCallback? onRedeem;
  final VoidCallback? onTap;

  const RedeemItemTile({
    super.key,
    required this.item,
    this.onRedeem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SurfaceCard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.card_giftcard, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.costLabel,
                    style: TextStyle(
                      color: item.canAfford
                          ? AppColors.primary
                          : Colors.red.shade300,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onRedeem,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    item.canAfford ? AppColors.primary : AppColors.surface,
                foregroundColor: item.canAfford
                    ? Colors.white
                    : AppColors.textSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: const Text(
                'Redeem',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const SurfaceCard({
    super.key,
    required this.child,
    this.margin,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
