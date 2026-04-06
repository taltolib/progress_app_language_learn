
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progress/core/providers/cards_provider.dart';
import 'package:progress/core/providers/search_provider.dart';
import 'package:progress/core/providers/word_detail_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/core/theme/colors/theme_custom.dart';
import 'package:progress/generated/fonts/app_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CardsProvider>().loadAllCards());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CardsProvider>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => provider.loadAllCards(), // pull-to-refresh = новые слова
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (provider.grammarCard != null)
                    _CardTile(label: 'Grammar', word: provider.grammarCard!.word,
                      onTap: () => Navigator.pushNamed(context, '/grammar',
                          arguments: provider.grammarCard)),

                  if (provider.differenceCard != null)
                    _CardTile(label: 'Differences', word: provider.differenceCard!.word,
                      onTap: () => Navigator.pushNamed(context, '/difference',
                          arguments: provider.differenceCard)),

                  if (provider.thesaurusCard != null)
                    _CardTile(label: 'Thesaurus', word: provider.thesaurusCard!.word,
                      onTap: () => Navigator.pushNamed(context, '/thesaurus',
                          arguments: provider.thesaurusCard)),

                  if (provider.collocationCard != null)
                    _CardTile(label: 'Collocations', word: provider.collocationCard!.word,
                      onTap: () => Navigator.pushNamed(context, '/collocation',
                          arguments: provider.collocationCard)),

                  if (provider.metaphorCard != null)
                    _CardTile(label: 'Metaphors', word: provider.metaphorCard!.word,
                      onTap: () => Navigator.pushNamed(context, '/metaphor',
                          arguments: provider.metaphorCard)),

                  if (provider.speakingCard != null)
                    _CardTile(label: 'Speaking', word: provider.speakingCard!.phrase,
                      onTap: () => Navigator.pushNamed(context, '/speaking',
                          arguments: provider.speakingCard)),
                ],
              ),
      ),
    );
  }
}

 class _CardTile extends StatelessWidget {
  final String label;
  final String word;
  final VoidCallback onTap;
  const _CardTile({required this.label, required this.word, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors =theme.extension<AppThemeColors>()!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colors.backgroundWhiteOrDark,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(label, textAlign: TextAlign.center,
                  style: AppFonts.mulish.s16w700(color: colors.text)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(word, style:  AppFonts.mulish.s18w500(color: colors.text)),
            ),
          ],
        ),
      ),
    );
  }
}


// class SearchScreen extends StatelessWidget {
//   const SearchScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<SearchProvider>();
//     return Scaffold(
//       appBar: AppBar(title: const Text('Search')),
//       body: Column(children: [
//         Padding(
//           padding: const EdgeInsets.all(12),
//           child: TextField(
//             decoration: const InputDecoration(
//               hintText: 'English, Русский, O\'zbek...',
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(),
//             ),
//             onChanged: (v) => provider.search(v),
//           ),
//         ),
//         Expanded(
//           child: provider.isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : ListView.builder(
//                   itemCount: provider.results.length,
//                   itemBuilder: (_, i) {
//                     final r = provider.results[i];
//                     return ListTile(
//                       title: Text(r.word),
//                       subtitle: Text([r.wordRu, r.wordUz].whereType<String>().join(' • ')),
//                       onTap: () {
//                         context.read<WordDetailProvider>().loadDetail(r.id);
//                         Navigator.pushNamed(context, '/word_detail');
//                       },
//                     );
//                   },
//                 ),
//         ),
//       ]),
//     );
//   }
// }

// ─────────────────────────────────────────────
// pubspec.yaml
// ─────────────────────────────────────────────
// dependencies:
//   provider: ^6.1.0
//   sqflite: ^2.3.0
//   path: ^1.9.0
//
// flutter:
//   assets:
//     - assets/waio_dictionary.db

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(home: HomeScreen());
}
