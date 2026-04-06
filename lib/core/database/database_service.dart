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
      final data = await rootBundle.load('assets/db/progress_db.db');
      final bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes);
    }

    return await openDatabase(path, readOnly: true);
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

    final translations = await d.rawQuery('''
      SELECT word FROM phrases_translate
      WHERE phrase_id = ?
    ''', [phraseId]);

    final examples = await d.rawQuery('''
      SELECT value FROM phrases_example
      WHERE phrase_id = ?
    ''', [phraseId]);

    return PhraseItem(
      id: phraseId,
      phrase: phraseWord,
      translations: translations.map((r) => r['word'] as String).toList(),
      examples: examples.map((r) => r['value'] as String).toList(),
    );
  }


  Future<List<SearchResult>> searchWord(String query) async {
    if (query.trim().isEmpty) return [];
    final d = await db;
    final q = '%$query%';

    final rows = await d.rawQuery('''
      SELECT DISTINCT we.id, we.word, ru.word as word_ru, we.word_class_body , uz.word as word_uz
      FROM word_entity we
      LEFT JOIN words_ru ru ON we.id = ru.word_id
      LEFT JOIN words_uz uz ON we.id = uz.word_id
      WHERE we.word LIKE ?
         OR ru.word LIKE ?
         OR uz.word LIKE ?
      LIMIT 50
    ''', [q, q, q]);

    return rows.map((r) => SearchResult(
      id: r['id'] as int,
      word: r['word'] as String,
      wordRu: r['word_ru'] as String?,
      wordUz: r['word_uz'] as String?,
      pronunciation:  r['word_class_body'] as String?,
    )).toList();
  }

  Future<WordDetail> getWordDetail(int wordId) async {
    final d = await db;

    final we = await d.rawQuery(
      'SELECT id, word FROM word_entity WHERE id = ?', [wordId]);

    final grammar = await d.rawQuery(
      'SELECT body FROM grammar WHERE word_id = ? LIMIT 1', [wordId]);
    final difference = await d.rawQuery(
      'SELECT body FROM difference WHERE word_id = ? LIMIT 1', [wordId]);
    final thesaurus = await d.rawQuery(
      'SELECT body FROM thesaurus WHERE word_id = ? LIMIT 1', [wordId]);
    final collocation = await d.rawQuery(
      'SELECT body FROM collocation WHERE word_id = ? LIMIT 1', [wordId]);
    final metaphor = await d.rawQuery(
      'SELECT body FROM metaphor WHERE word_id = ? LIMIT 1', [wordId]);
    final ru = await d.rawQuery(
      'SELECT word FROM words_ru WHERE word_id = ? LIMIT 1', [wordId]);
    final uz = await d.rawQuery(
      'SELECT word FROM words_uz WHERE word_id = ? LIMIT 1', [wordId]);

    return WordDetail(
      id: wordId,
      word: we.first['word'] as String,
      grammarBody: grammar.isNotEmpty ? grammar.first['body'] as String? : null,
      differenceBody: difference.isNotEmpty ? difference.first['body'] as String? : null,
      thesaurusBody: thesaurus.isNotEmpty ? thesaurus.first['body'] as String? : null,
      collocationBody: collocation.isNotEmpty ? collocation.first['body'] as String? : null,
      metaphorBody: metaphor.isNotEmpty ? metaphor.first['body'] as String? : null,
      wordRu: ru.isNotEmpty ? ru.first['word'] as String? : null,
      wordUz: uz.isNotEmpty ? uz.first['word'] as String? : null,
    );
  }
}
