import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _selectedLanguage = "English";

  String get selectedLanguage => _selectedLanguage;

  void selectLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }
}
