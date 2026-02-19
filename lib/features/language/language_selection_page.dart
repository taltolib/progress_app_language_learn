import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:progress/generated/image/app_image.dart';
import 'package:progress/shared/widget/language_list.dart';

import '../../core/theme/colors/app_colors.dart';

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
      'GB',
      theme: const ImageTheme(width: 30, height: 30, shape: Circle()),
    ),
  ];
  final List<String> languageName = [
    'Узбекский',
    'Русский',
    'Английский',
  ];
  int selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded( flex: 2,child: AppImage().logo.logoBrand(width: 60,height: 60),),
            Expanded(
              flex: 5,
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
                            'Выберите язык',
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
                            selectedIndex: selectedIndex,
                            onTap: (index) {
                              setState(() {
                                selectedIndex = index;
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
