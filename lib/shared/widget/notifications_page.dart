import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/app_bar_custom_for_card_page.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      backgroundColor: colors.backgroundWhiteOrDark,
      appBar: appBarCustom(context, LocaleKeys.notificationPage.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child:Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_active, size: 40, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                LocaleKeys.notificationPageTitle.tr(),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                LocaleKeys.notificationPageBody.tr(),
                style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



