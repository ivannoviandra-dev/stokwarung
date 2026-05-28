import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';

/// Reusable elevated card following the Pro-Micro Merchant design.
///
/// White background, 16px corner radius, ambient shadow.
/// Optional left accent border for status highlighting.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? accentColor;
  final VoidCallback? onTap;
  final double borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.accentColor,
    this.onTap,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.appColors.cardBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppTheme.cardShadow(context.appColors),
        border: accentColor != null
            ? Border(
                left: BorderSide(color: accentColor!, width: 3),
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
