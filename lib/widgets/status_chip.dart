import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Reusable status chip/badge following the design system.
/// Uses dynamic colors based on status types.
class StatusChip extends StatelessWidget {
  final String label;
  final StatusChipType type;

  const StatusChip({
    super.key,
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor) = _getColors(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
      ),
    );
  }

  (Color, Color) _getColors(BuildContext context) {
    return switch (type) {
      StatusChipType.success => (
          context.appColors.success.withValues(alpha: 0.1),
          context.appColors.success,
        ),
      StatusChipType.warning => (
          context.appColors.warning.withValues(alpha: 0.15),
          context.appColors.warning,
        ),
      StatusChipType.danger => (
          context.appColors.error.withValues(alpha: 0.1),
          context.appColors.error,
        ),
      StatusChipType.neutral => (
          context.appColors.chipBackground,
          context.appColors.chipText,
        ),
    };
  }
}

enum StatusChipType { success, warning, danger, neutral }
