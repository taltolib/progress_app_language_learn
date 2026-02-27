import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress/shared/widget/custom_show_dialog.dart';
import 'package:progress/shared/widget/language_bottom_sheet.dart';
import 'package:progress/shared/widget/line.dart';
import 'package:progress/shared/widget/section.dart';
import 'package:progress/shared/widget/settings_switch_tile.dart';
import 'package:progress/shared/widget/settings_tile.dart';
import 'package:provider/provider.dart';
import 'package:progress/core/providers/theme_provider.dart';
import 'package:progress/core/providers/language_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageProvider>();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textPrimary = colorScheme.onSurface;
    final textSecondary = colorScheme.onSurface.withOpacity(0.6);

    return Container(
      color: backgroundColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          Section(
            cardColor: cardColor,
            children: [
              SettingsTile(
                title: "Получить премиум",
                textPrimary: textPrimary,
                showArrow: true,
              ),
              Line(),
              SettingsTile(
                title: "Активировать код",
                textPrimary: textPrimary,
                showArrow: true,
              ),
            ],
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Настройки",
              style: TextStyle(
                color: textSecondary,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Section(
            cardColor: cardColor,
            children: [
              SettingsTile(
                title: "Тема",
                textPrimary: textPrimary,
                trailing: Text(
                  themeProvider.isDarkMode ? "Темная" : "Светлая",
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 15,
                  ),
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
                title: "Язык приложения",
                textPrimary: textPrimary,
                trailing: Text(
                  languageProvider.selectedLanguage,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 15,
                  ),
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
                title: "Выйти",
                textPrimary: textPrimary,
              ),
              Line(),
              SettingsTile(
                title: "Удалить аккаунт",
                textPrimary: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}