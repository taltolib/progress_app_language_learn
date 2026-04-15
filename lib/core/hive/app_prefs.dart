import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const _boxName = 'app_prefs';
  static const _keyIntroSeen = 'intro_seen';
  static const _keyLoginSeen = 'loginScreen';
  static const _keyLoggedIn = 'isLoggedIn';

  static late SharedPreferences _prefs;

  static Box get _box => Hive.box(_boxName);

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  static Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }


  static bool get introSeen => _box.get(_keyIntroSeen, defaultValue: false) as bool;

  static Future<void> markIntroSeen() => _box.put(_keyIntroSeen, true);


  static bool get isSeen => _prefs.getBool(_keyLoginSeen) ?? false;

  static Future<void> setSeen() async {
    await _prefs.setBool(_keyLoginSeen, true);
  }

  static bool get isLoggedIn => _prefs.getBool(_keyLoggedIn) ?? false;

  static Future<void> saveLoggedIn(bool value) async {
    await _prefs.setBool(_keyLoggedIn, value);
  }
}