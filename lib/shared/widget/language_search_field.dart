import 'package:flutter/material.dart';
import '../../core/theme/colors/app_colors.dart';

class LanguageSearchField extends StatelessWidget {
  final TextEditingController controller;

  const LanguageSearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      cursorColor: AppColors.brandGreen,
      style: TextStyle(
        color: isDark
            ? AppColors.textPrimaryDark
            : AppColors.textPrimaryLight,
      ),
      decoration: InputDecoration(
        hintText: "Find language to learn...",
        hintStyle: TextStyle(
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        ),
        filled: true,
        fillColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDark
                ? AppColors.borderDark
                : AppColors.borderLight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.brandGreen,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}