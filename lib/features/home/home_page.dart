import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progress/core/providers/cards_provider.dart';
import 'package:progress/core/providers/game_provider.dart';
import 'package:progress/core/theme/colors/app_colors.dart';
import 'package:progress/domain/models/card_content_model.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:progress/shared/widget/card_for_home_page.dart';
import 'package:provider/provider.dart';
import 'package:progress/shared/widget/streak_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  late AnimationController _rotationController;
  static const double _bottomNavSpace = 30;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CardsProvider>().loadAllCards();
      _rotationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      );
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 300));
    await context.read<CardsProvider>().loadAllCards();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Consumer2<GameProvider, CardsProvider>(
      builder: (context, gameProvider, cardsProvider, child) {
        return SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _onRefresh,
          header: ClassicHeader(
              refreshingIcon: const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.green),
                ),
              ),
          ),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              bottomInset + _bottomNavSpace,
            ),
            children: [
              StreakCard(
                streakDays: gameProvider.playerProgress.streakCount,
                title: LocaleKeys.streakTitle.tr(),
                subTitle: gameProvider.randomStreakSubtitleKey.tr(),
                body: LocaleKeys.streakBody5.tr(),
                weekProgress: gameProvider.weekProgress,
              ),
              const SizedBox(height: 25),
              CardForHomePage(
                title: 'Grammar',
                word: cardsProvider.grammarCard?.word ?? '...',
                onTap: cardsProvider.grammarCard != null
                    ? () => context.push(
                        '/card',
                        extra: {
                          'wordId': cardsProvider.grammarCard!.id,
                          'type': CardContentType.grammar,
                        },
                      )
                    : null,
              ),
              const SizedBox(height: 25),
              CardForHomePage(
                title: 'Differences',
                word: cardsProvider.differenceCard?.word ?? '...',
                onTap: cardsProvider.differenceCard != null
                    ? () => context.push(
                        '/card',
                        extra: {
                          'wordId': cardsProvider.differenceCard!.id,
                          'type': CardContentType.differences,
                        },
                      )
                    : null,
              ),
              const SizedBox(height: 25),
              CardForHomePage(
                title: 'Thesaurus',
                word: cardsProvider.thesaurusCard?.word ?? '...',
                onTap: cardsProvider.thesaurusCard != null
                    ? () => context.push(
                        '/card',
                        extra: {
                          'wordId': cardsProvider.thesaurusCard!.id,
                          'type': CardContentType.thesaurus,
                        },
                      )
                    : null,
              ),
              const SizedBox(height: 25),
              CardForHomePage(
                title: 'Collocations',
                word: cardsProvider.collocationCard?.word ?? '...',
                onTap: cardsProvider.collocationCard != null
                    ? () => context.push(
                        '/card',
                        extra: {
                          'wordId': cardsProvider.collocationCard!.id,
                          'type': CardContentType.collocations,
                        },
                      )
                    : null,
              ),
              const SizedBox(height: 25),
              CardForHomePage(
                title: 'Metaphors',
                word: cardsProvider.metaphorCard?.word ?? '...',
                onTap: cardsProvider.metaphorCard != null
                    ? () => context.push(
                        '/card',
                        extra: {
                          'wordId': cardsProvider.metaphorCard!.id,
                          'type': CardContentType.metaphors,
                        },
                      )
                    : null,
              ),
              const SizedBox(height: 25),
              CardForHomePage(
                title: 'Speaking',
                word: cardsProvider.speakingCard?.phrase ?? '...',
                onTap: cardsProvider.speakingCard != null
                    ? () => context.push(
                        '/card',
                        extra: {
                          'wordId': cardsProvider.speakingCard!.id,
                          'type': CardContentType.speaking,
                        },
                      )
                    : null,
              ),
              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }
}
