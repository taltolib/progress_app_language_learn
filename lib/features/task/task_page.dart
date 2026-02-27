import 'dart:math';
import 'package:flutter/material.dart';
import 'package:progress/domain/models/task_level_model.dart';
import 'package:progress/shared/widget/level_button.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  double snakeX(double t) {
    return sin(t * pi * 2.2) * 0.75;
  }

  @override
  Widget build(BuildContext context) {
    final levels = [
      TaskLevelModel(id: 1, stars: 3, progress: 1.0),
      TaskLevelModel(id: 2, stars: 2, progress: 0.9),
      TaskLevelModel(id: 3, stars: 0, progress: 0.0),
      TaskLevelModel(id: 4, stars: 0, progress: 0.0),
      TaskLevelModel(id: 5, stars: 0, progress: 0.0),
      TaskLevelModel(id: 6, stars: 0, progress: 0.0),
      TaskLevelModel(id: 7, stars: 0, progress: 0.0),
      TaskLevelModel(id: 8, stars: 0, progress: 0.0),
      TaskLevelModel(id: 9, stars: 0, progress: 0.0),
      TaskLevelModel(id: 10, stars: 0, progress: 0.0),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          itemCount: levels.length,
          itemBuilder: (context, index) {
            final level = levels[index];

            final t = index / (levels.length - 1);
            final alignmentX = snakeX(t);

            /// Разблокировка логика
            final isUnlocked =
                index == 0 || levels[index - 1].stars > 0;

            final isActive =
                isUnlocked && !level.isCompleted;

            return Column(
              children: [
                Align(
                  alignment: Alignment(alignmentX, 0),
                  child: TaskButton(
                    level: level,
                    isActive: isActive,
                    onTap: () {
                      if (!isUnlocked) {
                        showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                            title: Text("Недоступно"),
                            content: Text(
                                "Сначала пройди предыдущий уровень"),
                          ),
                        );
                        return;
                      }

                      if (level.isCompleted) {
                        showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                            title: Text("Уровень завершён"),
                            content: Text(
                                "Этот уровень уже пройден на 100%"),
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TaskDetailPage(taskId: level.id),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TaskDetailPage extends StatelessWidget {
  final int taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Level $taskId")),
      body: Center(
        child: Text(
          "Контент уровня $taskId",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}