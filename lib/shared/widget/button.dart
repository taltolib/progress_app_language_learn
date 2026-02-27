  import 'package:flutter/material.dart';

import '../../core/theme/colors/app_colors.dart';

  // ignore: must_be_immutable
  class Button extends StatelessWidget {
    final VoidCallback onTap;
    final IconData icon;

    const Button({
      super.key,
      required this.onTap,
      required this.icon,
    });

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.brandGreen,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            icon,
            color: AppColors.brandOnGreen,
            size: 30,
          ),
        ),
      );
    }
  }
