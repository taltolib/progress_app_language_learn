import 'package:flutter/material.dart';
import 'package:progress/shared/widget/custom_home_app_bar.dart';
import 'package:progress/shared/widget/glass_navigation_bar.dart';
import 'package:progress/shared/widget/language_search_field.dart';
import 'package:progress/shared/widget/work_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  int currentIndex = 1;

  final List<Map<String, String>> words = [
    {
      "word": "bread",
      "pronunciation": "bred",
      "ru": "хлеб",
      "uz": "non",
    },
    {
      "word": "butter",
      "pronunciation": "ˈbʌtər",
      "ru": "масло",
      "uz": "sariyog'",
    },
    {
      "word": "build",
      "pronunciation": "bɪld",
      "ru": "строить",
      "uz": "qurmoq",
    },
  ];

  List<Map<String, String>> filteredWords = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_filterWords);
  }

  void _filterWords() {
    final query = _controller.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        filteredWords = [];
      });
      return;
    }

    setState(() {
      filteredWords = words
          .where((word) =>
          word["word"]!.toLowerCase().startsWith(query))
          .toList();
    });
  }

  bool isExactMatch(String word) {
    return word.toLowerCase() == _controller.text.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            LanguageSearchField(controller: _controller),
            SizedBox(height: 20),
            if (_controller.text.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    "Начните вводить слово",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else Expanded(
                child: ListView.builder(
                  itemCount: filteredWords.length,
                  itemBuilder: (context, index) {
                    final word = filteredWords[index];
                    return WordCard(
                      word: word["word"]!,
                      pronunciation: word["pronunciation"]!,
                      ru: word["ru"]!,
                      uz: word["uz"]!,
                      isExact: isExactMatch(word["word"]!),
                    );
                  },
                ),
              ),
          ],
        ),
    );
  }
}