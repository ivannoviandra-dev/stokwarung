import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'app_card.dart';

/// Reusable metric card for Dashboard or Laporan.
/// Features clean typography, soft shadow, and customizable color accent.
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final Color? textColor;
  final VoidCallback? onTap;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? context.appColors.primary;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      backgroundColor: color != null ? baseColor : context.appColors.cardBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: textTheme.bodySmall?.copyWith(
                    color: textColor ?? context.appColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: textTheme.headlineMedium?.copyWith(
                    color: textColor ?? context.appColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: textColor?.withValues(alpha: 0.8) ?? context.appColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: textColor != null
                  ? Colors.white.withValues(alpha: 0.2)
                  : baseColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: textColor ?? baseColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
