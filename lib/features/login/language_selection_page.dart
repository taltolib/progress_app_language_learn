import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/providers/language_selection_provider.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:progress/generated/image/app_image.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/language_list.dart';
import 'package:provider/provider.dart';


class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  final List<Widget> flags = [

    CountryFlag.fromCountryCode(
      'US',
      theme: const ImageTheme(width: 30, height: 30, shape: Circle()),
    ),
  ];
  final List<String> languageName = [
    LocaleKeys.authUzbek,
    LocaleKeys.authRussian,
    LocaleKeys.authEnglish,
  ];
  int selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageSelectionProvider>();
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      backgroundColor:colors.backgroundWhiteOrDark,
      body: SafeArea(
        child: Column(
          children: [
            Expanded( flex:1, child: Container(),),
            Expanded( flex: 2,child: AppImage().character.fluent(width: 200, height: 200)),
            Expanded(
              flex: 6,
              child: Center(
                child: Container(
                  height: 250,
                  width: 270,
                  decoration: BoxDecoration(
                    border: BoxBorder.all(width: 0.5,color: colors.backgroundAcceptsWhiteOrDark),
                    color: colors.backgroundWhiteOrDark,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color:Theme.of(context).dividerColor.withOpacity(0.50) ,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            LocaleKeys.authSelectLanguage.tr(),
                            style: AppFonts.mulish.s20w500(color: colors.text),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          height: 1,
                          color: colors.backgroundAcceptsWhiteOrDark,
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          flex: 5,
                          child:LanguageList(
                            list: flags,
                            title: languageName,
                            selectedIndex: languageProvider.selectedIndex,
                            onTap: (index) {
                              languageProvider.selectLanguage(index, context);
                              context.setLocale(languageProvider.selectedLocale);
                             // Future.delayed(onst Duration(milliseconds:200), () {
                             //   context.go('/introduction');
                             //  });
                            },
                          ),


                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded( flex: 2,child: Container(),)
          ],
        ),
      ),
    );
  }
}
