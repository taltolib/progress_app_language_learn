import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _key = 'isDarkMode';
  // ✅ Ключ чтобы понять — пользователь уже выбирал тему или нет
  static const _keyHasChosen = 'hasChosenTheme';

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final hasChosen = prefs.getBool(_keyHasChosen) ?? false;

    if (!hasChosen) {
      // ✅ Первый запуск — берём системную тему
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = brightness == Brightness.dark;
    } else {
      // ✅ Пользователь уже выбирал — загружаем его выбор
      _isDarkMode = prefs.getBool(_key) ?? false;
    }

    notifyListeners();
  }

  void toggleTheme(bool value) {
    _isDarkMode = value;
    _saveTheme(value);
    notifyListeners();
  }

  void setDarkMode() {
    _isDarkMode = true;
    _saveTheme(true);
    notifyListeners();
  }

  void setLightMode() {
    _isDarkMode = false;
    _saveTheme(false);
    notifyListeners();
  }

  Future<void> _saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
    await prefs.setBool(_keyHasChosen, true);
  }
}