import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../core/theme/app_colors.dart';
import '../utils/currency_formatter.dart';
import 'app_card.dart';
import 'status_chip.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Image / Icon Placeholder
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: context.appColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.appColors.inputBorder),
            ),
            child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildPlaceholderIcon(context),
                    ),
                  )
                : _buildPlaceholderIcon(context),
          ),
          const SizedBox(width: 12),
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(product.sellPrice),
                  style: textTheme.bodyMedium?.copyWith(
                    color: context.appColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Stok: ${product.stock}',
                      style: textTheme.bodySmall?.copyWith(
                        color: product.stock <= 0
                            ? context.appColors.error
                            : product.isLowStock
                                ? context.appColors.warning
                                : context.appColors.textSecondary,
                        fontWeight: product.isLowStock || product.stock <= 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (product.stock <= 0)
                      const StatusChip(
                        label: 'Habis',
                        type: StatusChipType.danger,
                      )
                    else if (product.isLowStock)
                      const StatusChip(
                        label: 'Hampir Habis',
                        type: StatusChipType.warning,
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Action button
          if (onAddToCart != null && product.stock > 0)
            IconButton(
              icon: Icon(Icons.add_shopping_cart, color: context.appColors.primary),
              onPressed: onAddToCart,
              style: IconButton.styleFrom(
                backgroundColor: context.appColors.primary.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon(BuildContext context) {
    return Icon(
      Icons.inventory_2_outlined,
      color: context.appColors.primary,
      size: 24,
    );
  }
}