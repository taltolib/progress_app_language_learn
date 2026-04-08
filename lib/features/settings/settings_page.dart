import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progress/core/providers/auth_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/custom_show_dialog.dart';
import 'package:progress/shared/widget/language_bottom_sheet.dart';
import 'package:progress/shared/widget/line.dart';
import 'package:progress/shared/widget/push_button.dart';
import 'package:progress/shared/widget/section.dart';
import 'package:progress/shared/widget/settings_switch_tile.dart';
import 'package:progress/shared/widget/settings_tile.dart';
import 'package:provider/provider.dart';
import 'package:progress/core/providers/theme_provider.dart';
import 'package:progress/core/providers/language_selection_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageSelectionProvider>();
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final cardColor = colors.backgroundAcceptsWhiteOrDark;
    final text = colors.text;


    return Container(
      color: colors.backgroundWhiteOrDark,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // Section(
          //   cardColor: cardColor,
          //   children: [
          //     SettingsTile(
          //       title: LocaleKeys.getPremium.tr(),
          //       textPrimary: text,
          //       showArrow: true,
          //     ),
          //     Line(),
          //     SettingsTile(
          //       title: LocaleKeys.activateCode.tr(),
          //       textPrimary: text,
          //       showArrow: true,
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              LocaleKeys.settings.tr(),
              style: AppFonts.mulish.s18w500(color: text),
            ),
          ),
          const SizedBox(height: 10),
          Section(
            cardColor: cardColor,
            children: [
              SettingsTile(
                title: LocaleKeys.theme.tr(),
                textPrimary: text,
                trailing: Text(
                  themeProvider.isDarkMode
                      ? LocaleKeys.darkTheme.tr()
                      : LocaleKeys.lightTheme.tr(),
                  style: AppFonts.mulish.s15w500(color: text),
                ),
                showArrow: true,
                onTap: () {
                  themeProvider.toggleTheme(!themeProvider.isDarkMode);
                },
              ),
              Line(),
              SettingsTile(
                onTap: () {
                  customShowBottomSheetDialog(
                    context,
                    0.4,
                    const SizedBox(),
                    const LanguageBottomSheet(),
                    const SizedBox(),
                  );
                },
                title: LocaleKeys.appLanguage.tr(),
                textPrimary: text,
                trailing: Text(
                  languageProvider.selectedLanguageName,
                  style: AppFonts.mulish.s15w500(color: text),
                ),
                showArrow: true,
              ),
              Line(),
              const SettingsSwitchTile(),
            ],
          ),
          const SizedBox(height: 30),

          /// ACCOUNT
          Section(
            cardColor: cardColor,
            children: [
              SettingsTile(
                title: LocaleKeys.logout.tr(),
                textPrimary: text,
                onTap: () {
                  context.read<AuthProvider>().signOut();
                  context.go('/login');
                },
              ),
              Line(),
              SettingsTile(
                onTap: () {
                  customShowBottomSheetDialog(
                    context,
                    0.35,
                    Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '',
                              style:  AppFonts.mulish.s18w600(color: colors.text)
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close,color: Colors.grey,),
                          ),
                        ],
                      ),
                    Column(
                      children: [
                        SizedBox(height: 10,),
                        Expanded( flex: 2,child: Text(LocaleKeys.titleForDeleteAccount.tr(), style: AppFonts.mulish.s20w500(color: colors.text),textAlign: TextAlign.center,)),
                        Expanded(child: Text(LocaleKeys.bodyForDeleteAccount.tr(), style: AppFonts.mulish.s15w500(color: Colors.grey), textAlign: TextAlign.center,maxLines: 2,))
                      ],
                    ),
                    PushButton(
                      color: AppColors.heartRed,
                      colorShadow: AppColors.heartRedDark,
                      borderRadius: 20,
                      height: 75,
                      fontSize: 19,
                      border: Border.all(color:AppColors.heartRedDark,width: 2 ),
                      colorText: colors.text,
                      language: LocaleKeys.deleteAccount.tr(),
                      flagAsset: Container(),
                      onTap: () {
                        context.read<AuthProvider>().deleteAccount();
                         languageProvider.toggleSelect();
                        context.go('/login');
                        context.pop();
                      },
                      isSelected: languageProvider.isSelect,
                    ),
                  );
                },
                title: LocaleKeys.deleteAccount.tr(),
                textPrimary: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
