import 'package:flutter/material.dart';
import 'package:progress/domain/data/country_language_mapper.dart';
import 'package:provider/provider.dart';
import 'package:country_flags/country_flags.dart';
import '../../core/providers/selected_language_provider.dart';
import '../../core/providers/translation_provider.dart';

class CountryListWidget extends StatelessWidget {
  final String word;

  const CountryListWidget({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final countries = CountryLanguageMapper.supportedCountryCodes;

    return ListView.builder(
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final code = countries[index];

        return ListTile(
          leading: CountryFlag.fromCountryCode(
              code,
              theme : ImageTheme(
                width: 30,
                height: 30,
                shape: const Circle(),
              )
          ),
          title: Text(
            CountryLanguageMapper.getLanguage(code),
          ),
          onTap: () async {
            context.read<SelectedLanguageProvider>().select(code);
            await context.read<TranslationProvider>().translate(
              text: word,
              targetLang: code.toLowerCase(),
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }
}