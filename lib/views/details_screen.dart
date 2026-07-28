import 'package:flutter/material.dart';
import 'package:the_code_cup/constants/app_colors.dart';
import 'package:the_code_cup/models/cart_item.dart';
import 'package:the_code_cup/models/product.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;
  final ValueChanged<CartItem>? onAddToCart;

  const DetailsScreen({
    super.key,
    required this.product,
    this.onAddToCart,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int _quantity = 1;
  final Map<String, String> _selections = {};
  late List<CartItem> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = [];
    for (final entry in widget.product.availableCustomizations.entries) {
      _selections[entry.key] = entry.value.keys.first;
    }
  }

  double get _unitPrice =>
      widget.product.calculateUnitPrice(_selections);
  double get _totalPrice => _unitPrice * _quantity;

  void _increment() => setState(() => _quantity++);
  void _decrement() => setState(() => _quantity = (_quantity > 1) ? _quantity - 1 : 1);

  void _select(String group, String option) {
    setState(() => _selections[group] = option);
  }

  void _addToCart() {
    final item = CartItem(
      product: widget.product,
      selectedCustomizations: Map.from(_selections),
      quantity: _quantity,
    );
    _cartItems.add(item);
    widget.onAddToCart?.call(item);
    setState(() {});
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                color: AppColors.activeIcon,
                onPressed: _cartItems.isEmpty
                    ? null
                    : () => _showCartPreview(context),
              ),
              if (_cartItems.isNotEmpty)
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
                      '${_cartItems.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildImage(),
                const SizedBox(height: 20),
                _buildProductInfo(),
                const SizedBox(height: 24),
                ..._buildCustomizationSections(),
                const SizedBox(height: 16),
                _buildQuantitySelector(),
              ],
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: widget.product.imageUrl != null
            ? Image.network(
                widget.product.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildFallbackImage(),
              )
            : _buildFallbackImage(),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(Icons.local_cafe_rounded, color: AppColors.primary, size: 64),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (widget.product.description != null)
          Text(
            widget.product.description!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        const SizedBox(height: 8),
        Text(
          _formatPrice(widget.product.basePrice),
          style: const TextStyle(
            color: AppColors.activeIcon,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCustomizationSections() {
    final sections = <Widget>[];
    for (final entry in widget.product.availableCustomizations.entries) {
      final group = entry.key;
      final options = entry.value;
      sections.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group[0].toUpperCase() + group.substring(1),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: options.entries.map((opt) {
                  final selected = _selections[group] == opt.key;
                  return FilterChip(
                    label: Text(
                      '${opt.key}${opt.value > 0 ? ' (+${_formatPrice(opt.value)})' : ''}',
                    ),
                    selected: selected,
                    onSelected: (_) => _select(group, opt.key),
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: selected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    }
    return sections;
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        const Text(
          'Quantity',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                color: AppColors.activeIcon,
                onPressed: _decrement,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$_quantity',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                color: AppColors.activeIcon,
                onPressed: _increment,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text('Add to cart  ·  ${_formatPrice(_totalPrice)}'),
          ),
        ),
      ),
    );
  }

  void _showCartPreview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cart',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._cartItems.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (item.selectedCustomizations.isNotEmpty)
                          Text(
                            item.selectedCustomizations.values.join(', '),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    'x${item.quantity}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
