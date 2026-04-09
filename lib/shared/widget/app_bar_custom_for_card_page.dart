
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/generated/fonts/app_fonts.dart';

AppBar appBarCustom ( BuildContext context, String title ) {
  return AppBar(
    backgroundColor: AppColors.blackGreen,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 8),
        Text(
            title,
            style: AppFonts.mulish.s18w700(color: AppColors.whiteForLight)
        ),
      ],
    ),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
      onPressed: () => context.pop(),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
    ),
  );
}

