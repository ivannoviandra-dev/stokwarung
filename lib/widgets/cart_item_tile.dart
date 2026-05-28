import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../core/theme/app_colors.dart';
import '../utils/currency_formatter.dart';

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;

  const CartItemTile({
    super.key,
    required this.cartItem,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.appColors.divider),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cartItem.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      CurrencyFormatter.format(cartItem.product.sellPrice),
                      style: textTheme.bodySmall?.copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'x${cartItem.quantity}',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.appColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Subtotal & Adjusters
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                CurrencyFormatter.format(cartItem.subtotal),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.appColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onRemove != null && cartItem.quantity == 1)
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: context.appColors.error),
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onRemove,
                    )
                  else
                    IconButton(
                      icon: Icon(Icons.remove, color: context.appColors.textSecondary),
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onDecrement,
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '${cartItem.quantity}',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: context.appColors.primary),
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onIncrement,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}