import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progress/features/Introduction/pages/discover_words_page.dart';
import 'package:progress/features/Introduction/pages/language_progress_page.dart';
import 'package:progress/features/Introduction/pages/practice_intro_page.dart';
import 'package:provider/provider.dart';
import '../../core/providers/introduction_provider.dart';
import '../../shared/widget/button.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<IntroductionProvider>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: SafeArea(
              child: Stack(
                children: [
                  PageView(
                    onPageChanged: p.onPageChanged,
                    controller: p.controller,
                    children: const [
                      DiscoverWordsPage(),
                      PracticeIntroPage(),
                      LanguageProgressPage(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(icon: Icons.arrow_back_ios, onTap: p.prev),
                  Button(
                    onTap: () {
                      p.next(context);
                    },
                    icon: Icons.arrow_forward_ios,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
