import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progress/core/providers/language_selection_provider.dart';
import 'package:progress/generated/image/app_image.dart';
import 'package:progress/generated/tr/app_translate.dart';
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
      'UZ',
      theme: const ImageTheme(width: 30, height: 30,shape: Circle()),
    ),
    CountryFlag.fromCountryCode(
      'RU',
      theme: const ImageTheme(width: 30, height: 30,shape: Circle()),
    ),
    CountryFlag.fromCountryCode(
      'US',
      theme: const ImageTheme(width: 30, height: 30, shape: Circle()),
    ),
  ];
  final List<String> languageName = [
    AppTranslate.uzbek,
    AppTranslate.russian,
    AppTranslate.english,
  ];
  int selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageSelectionProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded( flex:1, child: Container(),),
            Expanded( flex: 2,child: AppImage().logo.logoBrand(width: 60,height: 60),),
            Expanded(
              flex: 6,
              child: Center(
                child: Container(
                  height: 250,
                  width: 270,
                  decoration: BoxDecoration(
                    border: BoxBorder.all(width: 0.5,color: Theme.of(context).dividerColor),
                    color: Theme.of(context).scaffoldBackgroundColor,
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
                            AppTranslate.selectLanguage.tr(),
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
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
                             Future.delayed(const Duration(milliseconds:200), () {
                               context.go('/language');
                              });
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
