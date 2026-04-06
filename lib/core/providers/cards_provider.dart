import 'package:flutter/foundation.dart';
import 'package:progress/core/database/database_service.dart';
import 'package:progress/domain/models/word_model.dart';

class CardsProvider extends ChangeNotifier {
  final _db = DatabaseService.instance;

  WordCard? grammarCard;
  WordCard? differenceCard;
  WordCard? thesaurusCard;
  WordCard? collocationCard;
  WordCard? metaphorCard;
  PhraseItem? speakingCard;

  bool isLoading = false;

  /// Загружает все 6 карточек (вызывай при открытии экрана / pull-to-refresh)
  Future<void> loadAllCards() async {
    isLoading = true;
    notifyListeners();

    final results = await Future.wait([
      _db.randomWordWithGrammar(),
      _db.randomWordWithDifference(),
      _db.randomWordWithThesaurus(),
      _db.randomWordWithCollocation(),
      _db.randomWordWithMetaphor(),
      _db.randomPhrase(),
    ]);

    grammarCard     = results[0] as WordCard?;
    differenceCard  = results[1] as WordCard?;
    thesaurusCard   = results[2] as WordCard?;
    collocationCard = results[3] as WordCard?;
    metaphorCard    = results[4] as WordCard?;
    speakingCard    = results[5] as PhraseItem?;

    isLoading = false;
    notifyListeners();
  }

  /// Обновить только одну карточку
  Future<void> refreshGrammar() async {
    grammarCard = await _db.randomWordWithGrammar();
    notifyListeners();
  }

  Future<void> refreshDifference() async {
    differenceCard = await _db.randomWordWithDifference();
    notifyListeners();
  }

  Future<void> refreshThesaurus() async {
    thesaurusCard = await _db.randomWordWithThesaurus();
    notifyListeners();
  }

  Future<void> refreshCollocation() async {
    collocationCard = await _db.randomWordWithCollocation();
    notifyListeners();
  }

  Future<void> refreshMetaphor() async {
    metaphorCard = await _db.randomWordWithMetaphor();
    notifyListeners();
  }

  Future<void> refreshSpeaking() async {
    speakingCard = await _db.randomPhrase();
    notifyListeners();
  }
}


