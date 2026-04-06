import 'package:flutter/foundation.dart';
import 'package:progress/core/database/database_service.dart';
import 'package:progress/domain/models/word_model.dart';

class SearchProvider extends ChangeNotifier {
  final _db = DatabaseService.instance;

  List<SearchResult> results = [];
  bool isLoading = false;
  String lastQuery = '';

  Future<void> search(String query) async {
    if (query == lastQuery) return;
    lastQuery = query;

    if (query.trim().isEmpty) {
      results = [];
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    results = await _db.searchWord(query);

    isLoading = false;
    notifyListeners();
  }

  void clear() {
    results = [];
    lastQuery = '';
    notifyListeners();
  }
}