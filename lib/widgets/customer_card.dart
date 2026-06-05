import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import '../core/theme/app_colors.dart';
import '../utils/currency_formatter.dart';
import 'app_card.dart';
import 'status_chip.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onTap;

  const CustomerCard({
    super.key,
    required this.customer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      accentColor: customer.totalDebt > 0 ? context.appColors.error : context.appColors.success,
      child: Row(
        children: [
          // Customer Initials Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: customer.totalDebt > 0
                ? context.appColors.error.withValues(alpha: 0.1)
                : context.appColors.success.withValues(alpha: 0.1),
            child: Text(
              customer.name.substring(0, 1).toUpperCase(),
              style: textTheme.titleMedium?.copyWith(
                color: customer.totalDebt > 0 ? context.appColors.error : context.appColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  customer.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (customer.phone != null && customer.phone!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    customer.phone!,
                    style: textTheme.bodySmall?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  '${customer.invoiceCount} Transaksi Belum Lunas',
                  style: textTheme.bodySmall?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Debt Info & Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                CurrencyFormatter.format(customer.totalDebt),
                style: textTheme.titleMedium?.copyWith(
                  color: customer.totalDebt > 0 ? context.appColors.error : context.appColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              StatusChip(
                label: customer.statusLabel,
                type: customer.totalDebt > 0
                    ? StatusChipType.danger
                    : StatusChipType.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
