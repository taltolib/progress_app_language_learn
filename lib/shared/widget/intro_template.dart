import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/fonts/app_fonts.dart';

class IntroTemplate extends StatelessWidget {
  final Widget animationPath;
  final String title;
  final String subtitle;
  final String body;

  const IntroTemplate({
    super.key,
    required this.animationPath,
    required this.title,
    required this.subtitle,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            animationPath,
            const SizedBox(height: 40),
            Text(
              title.tr(),
              textAlign: TextAlign.center,
              style: AppFonts.mulish.s22w600(color: AppColors.green),
            ),
            const SizedBox(height: 20),
            Text(
              subtitle.tr(),
              textAlign: TextAlign.center,
              style:  AppFonts.mulish.s15w600(color: colors.text),
            ),
            const SizedBox(height: 20),
            Text(
              body.tr(),
              textAlign: TextAlign.center,
              style:  AppFonts.mulish.s15w600(color: colors.text.withOpacity(0.9)),
            ),
          ],
        ),
      ),
    );
  }
}
