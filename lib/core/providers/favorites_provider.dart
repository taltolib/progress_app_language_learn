import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:progress/domain/models/word_model.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _boxName = 'favorites_box';

  late Box _box;
  List<SearchResult> _favorites = [];

  List<SearchResult> get favorites => List.unmodifiable(_favorites);

  String get _key {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    return 'favorites_list_$uid';
  }

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    _load();
  }

  Future<void> reloadForCurrentUser() async {
    _load();
    notifyListeners();
  }

  void _load() {
    final raw = _box.get(_key);
    if (raw == null) {
      _favorites = [];
      return;
    }
    try {
      final List list = jsonDecode(raw as String);
      _favorites = list.map((e) => SearchResult(
        id: e['id'] as int,
        word: e['word'] as String,
        wordRu: e['wordRu'] as String?,
        wordUz: e['wordUz'] as String?,
        pronunciation: e['pronunciation'] as String?,
      )).toList();
    } catch (_) {
      _favorites = [];
    }
  }

  Future<void> _save() async {
    final encoded = jsonEncode(_favorites.map((e) => {
      'id': e.id,
      'word': e.word,
      'wordRu': e.wordRu,
      'wordUz': e.wordUz,
      'pronunciation': e.pronunciation,
    }).toList());
    await _box.put(_key, encoded);
  }

  bool isFavorite(int id) => _favorites.any((e) => e.id == id);

  Future<void> toggle(SearchResult result) async {
    if (isFavorite(result.id)) {
      _favorites.removeWhere((e) => e.id == result.id);
    } else {
      _favorites.add(result);
    }
    notifyListeners();
    await _save();
  }

  // Вызывать при logout — очищаем in-memory список (Hive остаётся, ключ uid-специфичен)
  void clearMemory() {
    _favorites = [];
    notifyListeners();
  }
}