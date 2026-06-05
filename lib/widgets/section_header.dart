import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: textTheme.labelMedium?.copyWith(
              color: context.appColors.textSecondary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (actionLabel != null && onActionPressed != null)
            GestureDetector(
              onTap: onActionPressed,
              child: Text(
                actionLabel!,
                style: textTheme.bodySmall?.copyWith(
                  color: context.appColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
