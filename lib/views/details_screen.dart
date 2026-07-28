import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/viewmodels/cart_viewmodel.dart';
import 'package:the_code_cup/viewmodels/home_viewmodel.dart';
import 'package:the_code_cup/viewmodels/ui_models.dart';
import 'package:the_code_cup/widgets/app_chrome.dart';
import 'package:the_code_cup/widgets/common_blocks.dart';
import 'package:the_code_cup/widgets/product_blocks.dart';

class DetailsScreen extends StatefulWidget {
  final String productId;
  final HomeViewModel home;
  final CartViewModel cart;
  final VoidCallback onOpenCart;

  const DetailsScreen({
    super.key,
    required this.productId,
    required this.home,
    required this.cart,
    required this.onOpenCart,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int _quantity = 1;
  late Map<String, String> _selections;
  ProductDetailsUi? _details;

  @override
  void initState() {
    super.initState();
    _details = widget.home.detailsFor(widget.productId);
    _selections = Map.from(_details?.defaultSelections ?? {});
  }

  void _addToCart(VoidCallback onAdded) {
    widget.cart.addToCart(widget.productId, _selections, _quantity);
    onAdded();
  }

  @override
  Widget build(BuildContext context) {
    final details = _details;
    if (details == null) {
      return const Scaffold(body: Center(child: Text('Product not found')));
    }

    return ListenableBuilder(
      listenable: widget.cart,
      builder: (context, _) => ScreenTemplate(
        appBar: createAppBar(
          cartCount: widget.cart.itemCount,
          onCartTap: widget.onOpenCart,
        ),
        navigationBar: createNavigationBar(
          totalLabel: widget.home.totalPriceLabel(
            widget.productId,
            _selections,
            _quantity,
          ),
          onAddToCart: () => _addToCart(() {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Added to cart'),
                duration: Duration(seconds: 1),
              ),
            );
          }),
        ),
        body: createBody(
          details: details,
          quantity: _quantity,
          selections: _selections,
          onSelectOption: (key, label) =>
              setState(() => _selections[key] = label),
          onDecrement: () =>
              setState(() => _quantity = (_quantity > 1) ? _quantity - 1 : 1),
          onIncrement: () => setState(() => _quantity++),
        ),
      ),
    );
  }

  static PreferredSizeWidget createAppBar({
    required int cartCount,
    required VoidCallback onCartTap,
  }) =>
      AppAppBar(
        leading: const BackButton(),
        actions: [
          _CartBadge(count: cartCount, onTap: onCartTap),
        ],
      );

  static Widget createNavigationBar({
    required String totalLabel,
    required VoidCallback onAddToCart,
  }) =>
      BottomActionBar(
        child: PrimaryButton(
          label: 'Add to cart  ·  $totalLabel',
          expanded: true,
          onPressed: onAddToCart,
        ),
      );

  static Widget createBody({
    required ProductDetailsUi details,
    required int quantity,
    required Map<String, String> selections,
    required void Function(String key, String label) onSelectOption,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    // ponytail: small static details list can use ListView; use CustomScrollView if content grows complex
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        NetworkHeroImage(imageUrl: details.imageUrl),
        const SizedBox(height: 20),
        Text(
          details.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (details.description != null)
          Text(
            details.description!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        const SizedBox(height: 8),
        Text(
          details.basePriceLabel,
          style: const TextStyle(
            color: AppColors.activeIcon,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        ...details.groups.map(
          (g) => _CustomizationGroup(
            group: g,
            selected: selections[g.key],
            onSelect: (label) => onSelectOption(g.key, label),
          ),
        ),
        const SizedBox(height: 16),
        QuantityStepper(
          quantity: quantity,
          onDecrement: onDecrement,
          onIncrement: onIncrement,
        ),
      ],
    );
  }
}

class _CartBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _CartBadge({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          color: AppColors.activeIcon,
          onPressed: onTap,
        ),
        if (count > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CustomizationGroup extends StatelessWidget {
  final CustomizationGroupUi group;
  final String? selected;
  final ValueChanged<String> onSelect;

  const _CustomizationGroup({
    required this.group,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: group.options.map((opt) {
              final isSelected = selected == opt.label;
              return FilterChip(
                label: Text(opt.chipLabel),
                selected: isSelected,
                onSelected: (_) => onSelect(opt.label),
                selectedColor: AppColors.primary.withValues(alpha: 0.15),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
