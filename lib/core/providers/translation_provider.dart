import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslationProvider extends ChangeNotifier {
  final GoogleTranslator _translator = GoogleTranslator();

  bool isLoading = false;
  String translatedText = '';

  Future<void> translate({
    required String text,
    required String targetLang,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _translator.translate(
        text,
        to: targetLang,
      );

      translatedText = result.text;
    } catch (e) {
      translatedText = "Ошибка перевода";
    }

    isLoading = false;
    notifyListeners();
  }

  void clear() {
    translatedText = '';
    notifyListeners();
  }
}