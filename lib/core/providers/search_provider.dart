import 'package:flutter/foundation.dart';
import 'package:progress/core/database/database_service.dart';
import 'package:progress/domain/models/word_model.dart';

class SearchProvider extends ChangeNotifier {
  final _db = DatabaseService.instance;

  List<SearchResult> results = [];
  bool isLoading = false;
  String lastQuery = '';
  String? errorMessage;

  Future<void> search(String query) async {
    if (query == lastQuery) return;
    lastQuery = query;

    if (query.trim().isEmpty) {
      results = [];
      errorMessage = null;
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      results = await _db.searchWord(query);
    } catch (error) {
      results = [];
      errorMessage = error.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void clear() {
    results = [];
    lastQuery = '';
    errorMessage = null;
    notifyListeners();
  }
}
