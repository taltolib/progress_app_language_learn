import 'package:flutter/foundation.dart';
import 'package:progress/core/database/database_service.dart';
import 'package:progress/domain/models/word_model.dart';

class WordDetailProvider extends ChangeNotifier {
  final _db = DatabaseService.instance;

  WordDetail? detail;
  bool isLoading = false;

  Future<void> loadDetail(int wordId) async {
    isLoading = true;
    notifyListeners();

    detail = await _db.getWordDetail(wordId);

    isLoading = false;
    notifyListeners();
  }

  void clear() {
    detail = null;
    notifyListeners();
  }
}