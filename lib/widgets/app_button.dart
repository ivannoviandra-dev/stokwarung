import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Reusable button variants following the design system.
///
/// Supports primary (filled green), secondary (outlined), and text styles.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
  }) : variant = AppButtonVariant.primary;

  const AppButton.outlined({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
  }) : variant = AppButtonVariant.outlined;

  const AppButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
  }) : variant = AppButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: context.appColors.onPrimary,
            ),
          )
        : Row(
            mainAxisSize:
                isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final style = switch (variant) {
      AppButtonVariant.primary => ElevatedButton.styleFrom(
          minimumSize: Size(isFullWidth ? double.infinity : 0, height ?? 48),
        ),
      AppButtonVariant.outlined => OutlinedButton.styleFrom(
          minimumSize: Size(isFullWidth ? double.infinity : 0, height ?? 48),
        ),
      AppButtonVariant.text => TextButton.styleFrom(
          minimumSize: Size(isFullWidth ? double.infinity : 0, height ?? 48),
        ),
    };

    return switch (variant) {
      AppButtonVariant.primary => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: child,
        ),
      AppButtonVariant.outlined => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: child,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: child,
        ),
    };
  }
}

enum AppButtonVariant { primary, outlined, text }
