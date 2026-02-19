import 'package:flutter/material.dart';

class LanguageSelectionProvider extends ChangeNotifier {

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void  languageSelected(int index) {
    _selectedIndex = index;

    notifyListeners();
  }

}