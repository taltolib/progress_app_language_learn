import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progress/core/providers/game_provider.dart';
import 'package:progress/domain/models/level_model.dart';
import 'package:progress/shared/widget/level_push_custom_button.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final totalLevels = 80;

  double snakeX(double t) {
    return sin(t * pi * 2.2) * 0.75;
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

    return ListView.builder(
      reverse: true,
      itemCount: totalLevels,
      itemBuilder: (context, index) {
        final levelId = index + 1;
        final alignmentX = snakeX(levelId - 1);
        

        final bool isLocked = levelId > game.nextLevel;
        final int score = game.levelResults[levelId] ?? 0;
        final bool isCompleted = score >= 70;
        final bool isActive = levelId == game.nextLevel;

        return Column(
          children: [
            Align(
              alignment: Alignment(alignmentX, 0),
              child: LevelPushCustomButton(
                level: LevelModel(id: levelId, tasks: []),
                isActive: isActive,
                isCompleted: isCompleted,
                isLocked: isLocked,
                onTap: () {
                  context.push('/level/$levelId');
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
