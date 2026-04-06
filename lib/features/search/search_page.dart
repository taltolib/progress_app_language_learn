import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/providers/search_provider.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/language_search_field.dart';
import 'package:progress/shared/widget/work_card.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  int currentIndex = 1;


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          LanguageSearchField(controller: _controller , hintText: LocaleKeys.writeWord.tr(),onChanged: provider.search,),
          SizedBox(height: 20),
          if (_controller.text.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  LocaleKeys.writeWord.tr(),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: provider.results.length,
                itemBuilder: (context, index) {
                  final l = provider.results[index];
                  return WordCard(
                    en: l.word,
                    pronunciation: l.pronunciation ?? 'null',
                    ru: l.wordRu ?? 'null',
                    uz: l.wordUz ?? 'null',
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
