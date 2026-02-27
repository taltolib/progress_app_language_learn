import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/app_colors.dart';

class CustomHomeAppBar extends StatelessWidget {
  final IconData icon;
  const CustomHomeAppBar({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final secondaryTextColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    final iconColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          right: 20,
          top: 25,
          left: 20,
          bottom: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "С возвращением, Жафар 👋",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandGreen,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Начнем новый урок?",
                  style: TextStyle(
                    fontSize: 18,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
            Icon(
             icon,
              color: Theme.of(context).shadowColor,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}