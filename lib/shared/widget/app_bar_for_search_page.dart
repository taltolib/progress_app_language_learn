import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/generated/tr/locale_keys.dart';

class AppBarForSearchPage extends StatelessWidget {
  final VoidCallback? onTap;
  const AppBarForSearchPage({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
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
            Text(LocaleKeys.favoriteWord.tr(), style: AppFonts.mulish.s20w700(color: colors.text)),
            GestureDetector(
              onTap: onTap,
              child: Icon(Icons.bookmark, color: AppColors.green , size: 20,),
            ),
          ],
        ),
      ),
    );
  }
}
