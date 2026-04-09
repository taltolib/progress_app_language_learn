
import 'package:hive_flutter/hive_flutter.dart';


class AppPrefs {
  static const _boxName = 'app_prefs';
  static const _keyIntroSeen = 'intro_seen';

  static Box get _box => Hive.box(_boxName);


  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }


  static bool get introSeen => _box.get(_keyIntroSeen, defaultValue: false) as bool;

  static Future<void> markIntroSeen() => _box.put(_keyIntroSeen, true);
}
