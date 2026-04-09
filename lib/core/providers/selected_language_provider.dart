import 'package:flutter/material.dart';

class SelectedLanguageProvider extends ChangeNotifier {
  String? _code;

  String? get code => _code;
  bool get hasLanguage => _code != null;

  void select(String code) {
    _code = code;
    notifyListeners();
  }

  void clear() {
    _code = null;
    notifyListeners();
  }
}