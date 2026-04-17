import 'dart:math';
import 'package:progress/core/database/database_service.dart';
import 'package:progress/domain/models/level_model.dart';
import 'package:progress/domain/models/task_model.dart';

const int _kTasksPerLevel = 20;
const int _kAnswerCount = 4;

/// Генерирует уровень из БД.
/// Слова берутся из середины таблицы (четверть от начала),
/// чтобы пропустить "хреновые" слова в начале.
class LevelRepository {
  LevelRepository._();
  static final LevelRepository instance = LevelRepository._();

  final _rng = Random();

  Future<LevelModel> generateLevel(int levelId, String langCode) async {
    final db = DatabaseService.instance;

    // Основные слова уровня — из середины таблицы
    final correctWords = await db.fetchWordsForLevel(
      levelId: levelId,
      langCode: langCode,
      limit: _kTasksPerLevel,
    );

    // Дистракторы — следующий блок после основных слов
    final distractorPool = await db.fetchDistractorsForLevel(
      levelId: levelId,
      langCode: langCode,
      mainLimit: _kTasksPerLevel,
      distractorCount: 200,
    );

    final tasks = <TaskModel>[];

    for (int i = 0; i < correctWords.length; i++) {
      final correct = correctWords[i];

      final wrongs = _pickDistractors(
        pool: distractorPool,
        correctTranslation: correct['translation']!,
        count: _kAnswerCount - 1,
      );

      final answers = [correct['translation']!, ...wrongs];
      answers.shuffle(_rng);

      final correctIndex = answers.indexOf(correct['translation']!);

      tasks.add(TaskModel(
        id: i + 1,
        question: correct['wordEn']!,
        answers: answers,
        rightAnswer: correctIndex,
      ));
    }

    return LevelModel(id: levelId, tasks: tasks);
  }

  List<String> _pickDistractors({
    required List<Map<String, String>> pool,
    required String correctTranslation,
    required int count,
  }) {
    final candidates = pool
        .map((e) => e['translation']!)
        .where((t) => t != correctTranslation && t.isNotEmpty)
        .toList()
      ..shuffle(_rng);

    while (candidates.length < count) {
      candidates.add(candidates.isNotEmpty ? candidates.last : '???');
    }

    return candidates.take(count).toList();
  }
}