import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:progress/core/providers/game_provider.dart';
import 'package:progress/generated/tr/locale_keys.dart';
import 'package:provider/provider.dart';
import 'package:progress/shared/widget/streak_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            StreakCard(
              streakDays: gameProvider.playerProgress.streakCount,
              title: LocaleKeys.streakTitle.tr(),
              subTitle: gameProvider.randomStreakSubtitleKey.tr(),
              body: LocaleKeys.streakBody5.tr(),
              weekProgress: gameProvider.weekProgress,
            ),
          ],
        );
      },
    );
  }
}
