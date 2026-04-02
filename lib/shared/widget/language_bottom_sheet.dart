import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/language_tile.dart';
import 'package:provider/provider.dart';
import 'package:progress/core/providers/language_selection_provider.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider =
    context.watch<LanguageSelectionProvider>();


    final textPrimary =
        Theme.of(context).colorScheme.onSurface;

    final selectedColor =
        Theme.of(context).colorScheme.surfaceVariant;

    final flags = [
      CountryFlag.fromCountryCode(
        'UZ',
        theme: const ImageTheme(
          width: 20,
          height: 20,
          shape: Circle(),
        ),
      ),
      CountryFlag.fromCountryCode(
        'RU',
        theme: const ImageTheme(
          width: 20,
          height: 20,
          shape: Circle(),
        ),
      ),
      CountryFlag.fromCountryCode(
        'US',
        theme: const ImageTheme(
          width: 20,
          height: 20,
          shape: Circle(),
        ),
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.choiceLSetting.tr(),
              style:  AppFonts.mulish.s18w600(color: textPrimary)
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: LanguageTile(
            flag: flags[0],
            title: "O'zbekcha",
            isSelected:
            languageProvider.selectedIndex == 0,
            selectedColor: selectedColor,
            textPrimary: textPrimary,
            onTap: () {
              languageProvider.selectLanguage(0, context);
              Navigator.pop(context);
            },
          ),
        ),
        Expanded(
          child: LanguageTile(
            flag: flags[1],
            title: "Русский",
            isSelected:
            languageProvider.selectedIndex == 1,
            selectedColor: selectedColor,
            textPrimary: textPrimary,
            onTap: () {
              languageProvider.selectLanguage(1, context);
              Navigator.pop(context);
            },
          ),
        ),
        Expanded(
          child: LanguageTile(
            flag: flags[2],
            title: "English",
            isSelected:
            languageProvider.selectedIndex == 2,
            selectedColor: selectedColor,
            textPrimary: textPrimary,
            onTap: () {
              languageProvider.selectLanguage(2, context);
              Navigator.pop(context);
            },
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}