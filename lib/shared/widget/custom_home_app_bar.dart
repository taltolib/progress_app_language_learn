import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
 import 'package:progress/generated/tr/locale_keys.dart';

class CustomHomeAppBar extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  const CustomHomeAppBar({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    String? name = FirebaseAuth.instance.currentUser?.displayName;
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
                Text(
                  LocaleKeys.homeWelcome.tr(args: [name ?? '']),
                  style: AppFonts.mulish.s20w700(
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  LocaleKeys.homeStartLesson.tr(),
                  style: AppFonts.mulish.s18w400(
                    color: colors.text,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: onTap,
              child: Icon(
               icon,
                color: colors.text ,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}