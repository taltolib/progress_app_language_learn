import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/generated/tr/locale_keys.dart';

class NotificationBanner extends StatelessWidget {
  final VoidCallback onAllow;

  const NotificationBanner({super.key, required this.onAllow});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 110,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 85,
                decoration: BoxDecoration(
                  color: AppColors.darkGold,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 10,
                  top: 14,
                  bottom: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text(
                            LocaleKeys.notificationBannerTitle,
                            style: AppFonts.mulish.s18w700(color: AppColors.whiteForLight),
                          ),
                          SizedBox(height: 4),
                          Text(
                            LocaleKeys.notificationBannerTitle,
                            style: AppFonts.mulish.s12w500(color: AppColors.whiteForLight),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: onAllow,
                        child: Text(LocaleKeys.allow.tr(),style: AppFonts.mulish.s12w500(color: AppColors.whiteForLight),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}