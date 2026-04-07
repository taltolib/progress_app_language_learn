import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionProvider extends ChangeNotifier {

  static const _key = 'selectedLanguageIndex';

  bool _isSelect = false;

  bool  get isSelect => _isSelect;

  void toggleSelect() {
    _isSelect = !_isSelect;
    notifyListeners();
  }

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  Locale get selectedLocale {
    switch (_selectedIndex) {
      case 0:
        return const Locale('uz');
      case 1:
        return const Locale('ru');
      case 2:
        return const Locale('en');
      default:
        return const Locale('uz');
    }
  }

  String get selectedLanguageName {
    switch (_selectedIndex) {
      case 0:
        return "O'zbekcha";
      case 1:
        return "Русский";
      case 2:
        return "English";
      default:
        return "O'zbekcha";
    }
  }

  LanguageSelectionProvider() {
    _load();
  }

  void selectLanguage(int index, BuildContext context) async {
    _selectedIndex = index;

    await context.setLocale(selectedLocale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, index);

    notifyListeners();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedIndex = prefs.getInt(_key) ?? 0;
    notifyListeners();
  }
}