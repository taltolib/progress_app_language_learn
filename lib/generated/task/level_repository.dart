import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:progress/core/database/database_service.dart';
import 'package:progress/domain/models/level_model.dart';
import 'package:progress/domain/models/task_model.dart';


const int _kTasksPerLevel = 20;

const int _kAnswerCount = 4;

class LevelRepository {
  LevelRepository._();
  static final LevelRepository instance = LevelRepository._();

  final _rng = Random();

  Future<LevelModel> generateLevel(int levelId, String langCode) async {
    final db = await DatabaseService.instance.db;


    final offset = (levelId - 1) * _kTasksPerLevel;
    final correctWords = await _fetchWords(db, langCode, _kTasksPerLevel, offset);

    // ── 2. Получаем пул «неправильных» слов для диstractors ─────────────────
    // Берём 200 слов из другого диапазона — будем выбирать из них случайно
    final distractorOffset = offset + _kTasksPerLevel;
    final distractorPool =
        await _fetchWords(db, langCode, 200, distractorOffset);

    // ── 3. Строим TaskModel для каждого вопроса ──────────────────────────────
    final tasks = <TaskModel>[];

    for (int i = 0; i < correctWords.length; i++) {
      final correct = correctWords[i];

      // 3 случайных неправильных, не совпадающих с правильным
      final wrongs = _pickDistractors(
        pool: distractorPool,
        correctTranslation: correct['translation'] as String,
        count: _kAnswerCount - 1,
      );

      // Список из 4 ответов: [правильный, wrong1, wrong2, wrong3]
      final answers = [correct['translation'] as String, ...wrongs];

      // Перемешиваем — shuffle меняет порядок на месте
      answers.shuffle(_rng);

      // После shuffle ищем куда попал правильный ответ
      final correctIndex = answers.indexOf(correct['translation'] as String);

      tasks.add(TaskModel(
        id: i + 1,
        question: correct['wordEn'] as String,   // всегда английское слово
        answers: answers,
        rightAnswer: correctIndex,
      ));
    }

    return LevelModel(id: levelId, tasks: tasks);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Future<List<Map<String, String>>> _fetchWords(
    Database db,
    String langCode,
    int limit,
    int offset,
  ) async {
    final String joinTable;
    final String joinColumn;

    switch (langCode) {
      case 'ru':
        joinTable = 'words_ru';
        joinColumn = 'ru';
        break;
      case 'en':
        joinTable = 'word_entity';
        joinColumn = 'en_self';
        break;
      default: // 'uz'
        joinTable = 'words_uz';
        joinColumn = 'uz';
    }

    late List<Map<String, Object?>> rows;

    if (langCode == 'en') {
      rows = await db.rawQuery('''
        SELECT we.id, we.word AS wordEn, we.word AS translation
        FROM word_entity we
        WHERE we.word GLOB '[a-zA-Z]*'
          AND length(we.word) < 10
        LIMIT ? OFFSET ?
      ''', [limit, offset]);
    } else {
      rows = await db.rawQuery('''
        SELECT we.id, we.word AS wordEn, t.word AS translation
        FROM word_entity we
        JOIN $joinTable t ON we.id = t.word_id
        WHERE we.word GLOB '[a-zA-Z]*'
          AND length(we.word) < 30
          AND t.word IS NOT NULL
          AND length(t.word) > 0
        LIMIT ? OFFSET ?
      ''', [limit, offset]);
    }

    return rows
        .map((r) => {
              'wordEn': r['wordEn'] as String,
              'translation': r['translation'] as String,
            })
        .toList();
  }

  List<String> _pickDistractors({
    required List<Map<String, String>> pool,
    required String correctTranslation,
    required int count,
  }) {
    final candidates = pool
        .map((e) => e['translation']!)
        .where((t) => t != correctTranslation && t.isNotEmpty)
        .toList();

    candidates.shuffle(_rng);


    while (candidates.length < count) {
      candidates.add(candidates.isNotEmpty ? candidates.last : '???');
    }

    return candidates.take(count).toList();
  }
}
