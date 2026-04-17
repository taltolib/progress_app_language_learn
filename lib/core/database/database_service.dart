import 'package:flutter/material.dart';
import 'package:progress/domain/models/card_content_model.dart';
import 'package:progress/domain/models/word_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class DatabaseService {
  static DatabaseService? _instance;
  static Database? _db;

  DatabaseService._();

  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'progress_db.db');

    if (!await File(path).exists()) {
      try {
        final data = await rootBundle.load('assets/db/progress_db.db');
        final bytes = data.buffer.asUint8List();
        await File(path).writeAsBytes(bytes);
      } on FlutterError catch (error) {
        throw StateError(
          'Database asset is missing: assets/db/progress_db.db. '
              'Add this file to the project and register assets/db/ in pubspec.yaml. '
              'Original error: $error',
        );
      }
    }

    return await openDatabase(path, readOnly: true);
  }

  Future<CardContentModel?> getGrammar(int wordId) async {
    final d = await db;
    final rows = await d.rawQuery(
      '''
      SELECT g.body, w.word
      FROM grammar g
      JOIN word_entity w ON g.word_id = w.id
      WHERE g.word_id = ?
      LIMIT 1
    ''',
      [wordId],
    );
    if (rows.isEmpty) return null;
    return CardContentModel(
      title: rows.first['word'] as String,
      htmlBody: rows.first['body'] as String? ?? '',
      type: CardContentType.grammar,
    );
  }

  Future<WordCard?> randomWordWithGrammar() async {
    final d = await db;
    final rows = await d.rawQuery('''
      SELECT we.id, we.word, g.body
      FROM word_entity we
      INNER JOIN grammar g ON we.id = g.word_id
      ORDER BY RANDOM()
      LIMIT 1
    ''');
    if (rows.isEmpty) return null;
    return WordCard(
      id: rows.first['id'] as int,
      word: rows.first['word'] as String,
      body: rows.first['body'] as String?,
    );
  }

  Future<WordCard?> randomWordWithDifference() async {
    final d = await db;
    final rows = await d.rawQuery('''
      SELECT we.id, we.word, m.body
      FROM word_entity we
      INNER JOIN difference m ON we.id = m.word_id
      ORDER BY RANDOM()
      LIMIT 1
    ''');
    if (rows.isEmpty) return null;
    return WordCard(
      id: rows.first['id'] as int,
      word: rows.first['word'] as String,
      body: rows.first['body'] as String?,
    );
  }

  Future<WordCard?> randomWordWithThesaurus() async {
    final d = await db;
    final rows = await d.rawQuery('''
      SELECT we.id, we.word, t.body
      FROM word_entity we
      INNER JOIN thesaurus t ON we.id = t.word_id
      ORDER BY RANDOM()
      LIMIT 1
    ''');
    if (rows.isEmpty) return null;
    return WordCard(
      id: rows.first['id'] as int,
      word: rows.first['word'] as String,
      body: rows.first['body'] as String?,
    );
  }

  Future<WordCard?> randomWordWithCollocation() async {
    final d = await db;
    final rows = await d.rawQuery('''
      SELECT we.id, we.word, c.body
      FROM word_entity we
      INNER JOIN collocation c ON we.id = c.word_id
      ORDER BY RANDOM()
      LIMIT 1
    ''');
    if (rows.isEmpty) return null;
    return WordCard(
      id: rows.first['id'] as int,
      word: rows.first['word'] as String,
      body: rows.first['body'] as String?,
    );
  }

  Future<WordCard?> randomWordWithMetaphor() async {
    final d = await db;
    final rows = await d.rawQuery('''
      SELECT we.id, we.word, m.body
      FROM word_entity we
      INNER JOIN metaphor m ON we.id = m.word_id
      ORDER BY RANDOM()
      LIMIT 1
    ''');
    if (rows.isEmpty) return null;
    return WordCard(
      id: rows.first['id'] as int,
      word: rows.first['word'] as String,
      body: rows.first['body'] as String?,
    );
  }

  Future<PhraseItem?> randomPhrase() async {
    final d = await db;

    final phrases = await d.rawQuery('''
      SELECT p_id, p_word FROM phrases
      ORDER BY RANDOM()
      LIMIT 1
    ''');
    if (phrases.isEmpty) return null;

    final phraseId = phrases.first['p_id'] as int;
    final phraseWord = phrases.first['p_word'] as String;

    final translations = await d.rawQuery(
      '''
      SELECT word FROM phrases_translate
      WHERE phrase_id = ?
    ''',
      [phraseId],
    );

    final examples = await d.rawQuery(
      '''
      SELECT value FROM phrases_example
      WHERE phrase_id = ?
    ''',
      [phraseId],
    );

    return PhraseItem(
      id: phraseId,
      phrase: phraseWord,
      translations: translations.map((r) => r['word'] as String).toList(),
      examples: examples.map((r) => r['value'] as String).toList(),
    );
  }

  /// Берёт слова из середины таблицы, чтобы избежать "хреновых" слов с начала.
  /// totalWords — общее кол-во слов в БД (подбирается один раз).
  /// Для каждого уровня сдвигаемся от середины: middleOffset + (levelId-1)*limit.
  Future<List<Map<String, String>>> fetchWordsForLevel({
    required int levelId,
    required String langCode,
    int limit = 20,
    int distractorCount = 200,
  }) async {
    final d = await db;

    // Узнаём сколько всего слов в таблице
    final countResult = await d.rawQuery(
      "SELECT COUNT(*) as cnt FROM word_entity WHERE word GLOB '[a-zA-Z]*' AND length(word) < 30",
    );
    final totalWords = Sqflite.firstIntValue(countResult) ?? 1000;

    // Начинаем с четверти таблицы — там уже нормальные слова
    final middleStart = totalWords ~/ 4;
    final offset = middleStart + (levelId - 1) * limit;

    return _fetchWords(d, langCode, limit, offset);
  }

  /// Берёт пул слов-дистракторов из следующего блока после основных слов уровня.
  Future<List<Map<String, String>>> fetchDistractorsForLevel({
    required int levelId,
    required String langCode,
    int mainLimit = 20,
    int distractorCount = 200,
  }) async {
    final d = await db;

    final countResult = await d.rawQuery(
      "SELECT COUNT(*) as cnt FROM word_entity WHERE word GLOB '[a-zA-Z]*' AND length(word) < 30",
    );
    final totalWords = Sqflite.firstIntValue(countResult) ?? 1000;
    final middleStart = totalWords ~/ 4;
    final mainOffset = middleStart + (levelId - 1) * mainLimit;
    final distractorOffset = mainOffset + mainLimit;

    return _fetchWords(d, langCode, distractorCount, distractorOffset);
  }

  Future<List<Map<String, String>>> _fetchWords(
      Database d,
      String langCode,
      int limit,
      int offset,
      ) async {
    late List<Map<String, Object?>> rows;

    if (langCode == 'en') {
      rows = await d.rawQuery('''
        SELECT we.id, we.word AS wordEn, we.word AS translation
        FROM word_entity we
        WHERE we.word GLOB '[a-zA-Z]*'
          AND length(we.word) < 10
        LIMIT ? OFFSET ?
      ''', [limit, offset]);
    } else {
      final joinTable = langCode == 'ru' ? 'words_ru' : 'words_uz';
      rows = await d.rawQuery('''
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

  Future<List<SearchResult>> searchWord(String query) async {
    if (query.trim().isEmpty) return [];
    final d = await db;
    final q = '$query%';

    final rows = await d.rawQuery(
      '''
      SELECT DISTINCT we.id, we.word, ru.word as word_ru, we.word_class_body , uz.word as word_uz
      FROM word_entity we
      LEFT JOIN words_ru ru ON we.id = ru.word_id
      LEFT JOIN words_uz uz ON we.id = uz.word_id
      WHERE we.word LIKE ?
         OR ru.word LIKE ?
         OR uz.word LIKE ?
      LIMIT 50
    ''',
      [q, q, q],
    );
    return rows
        .map(
          (r) => SearchResult(
        id: r['id'] as int,
        word: r['word'] as String,
        wordRu: r['word_ru'] as String?,
        wordUz: r['word_uz'] as String?,
        pronunciation: r['word_class_body'] as String?,
      ),
    )
        .toList();
  }

  Future<WordDetail> getWordDetail(int wordId) async {
    final d = await db;
    final rows = await d.rawQuery(
      '''
      SELECT we.id,we.word,
      g.body AS grammar,
      d.body AS difference,
      t.body AS thesaurus,
      c.body AS collocation,
      m.body AS metaphor,

      ru.word AS word_ru,
      uz.word AS word_uz

      FROM word_entity we
      
      LEFT JOIN grammar g ON g.word_id = we.id
      LEFT JOIN difference d ON d.word_id = we.id
      LEFT JOIN thesaurus t ON t.word_id = we.id
      LEFT JOIN collocation c ON c.word_id = we.id
      LEFT JOIN metaphor m ON m.word_id = we.id
      LEFT JOIN words_ru ru ON ru.word_id = we.id
      LEFT JOIN words_uz uz ON uz.word_id = we.id
      WHERE we.id = ?
      LIMIT 1
      ''',
      [wordId],
    );
    final r = rows.first;
    return WordDetail(
      id: r['id'] as int,
      word: r['word'] as String,
      grammarBody: r['grammar'] as String?,
      differenceBody: r['difference'] as String?,
      thesaurusBody: r['thesaurus'] as String?,
      collocationBody: r['collocation'] as String?,
      metaphorBody: r['metaphor'] as String?,
      wordRu: r['word_ru'] as String?,
      wordUz: r['word_uz'] as String?,
    );
  }
}