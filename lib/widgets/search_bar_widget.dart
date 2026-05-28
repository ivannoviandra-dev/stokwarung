import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterPressed;
  final TextEditingController? controller;

  const SearchBarWidget({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onFilterPressed,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.inputBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            Icons.search,
            color: context.appColors.textSecondary,
            size: 20,
          ),
          suffixIcon: onFilterPressed != null
              ? IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: context.appColors.primary,
                    size: 20,
                  ),
                  onPressed: onFilterPressed,
                )
              : null,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
