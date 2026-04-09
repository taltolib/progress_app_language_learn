import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/fonts/app_fonts.dart';

class CardForHomePage extends StatelessWidget {
  final String title;
  final String word;
  final Color? color;
  final Function()? onTap;

  const CardForHomePage({super.key, required this.title, required this.word, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: colors.backgroundAcceptsWhiteOrDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey.shade400.withOpacity(0.08),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                word,
                style:AppFonts.mulish.s20w500(color: colors.text),
              ),
            ),
          ),
          Positioned(
            top: -14,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric( vertical: 5,horizontal: 10),
                decoration: BoxDecoration(
                  color: color ?? AppColors.blackGreen,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(title, style: AppFonts.mulish.s15w500(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
