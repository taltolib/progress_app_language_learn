import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:progress/generated/tr/app_translate.dart';
import 'package:progress/shared/widget/language_card.dart';
import 'package:progress/shared/widget/language_search_field.dart';


class LearningLanguagePage extends StatefulWidget {
  const LearningLanguagePage({super.key});

  @override
  State<LearningLanguagePage> createState() => _LearningLanguagePageState();
}

class _LearningLanguagePageState extends State<LearningLanguagePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Widget> flags = [
    CountryFlag.fromCountryCode(
      'US',
      theme: const ImageTheme( width: 30,height: 30,shape: Circle()),
    ),
    CountryFlag.fromCountryCode(
      'UZ',
      theme: const ImageTheme(width: 30,height: 30,shape: Circle()),
    ),
    CountryFlag.fromCountryCode(
      'RU',
      theme: const ImageTheme(width: 30,height: 30,shape: Circle()),
    ),
  ];
  final List<String> languageName = [
    AppTranslate.english,
    AppTranslate.uzbek,
    AppTranslate.russian,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose Learning Language",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            LanguageSearchField(controller: _searchController),
            Expanded(
              child: GridView.builder(
                itemCount: languageName.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 0,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  return LanguageCard(
                    language: languageName[index],
                    flagAsset: flags[index],
                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}
