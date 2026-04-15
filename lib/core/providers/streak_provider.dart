import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class StreakProvider extends ChangeNotifier {
  late Box box;

  int streak = 0;
  DateTime? lastVisit;
  bool todayCompleted = false;

  // 🔑 Все ключи с uid-префиксом — данные изолированы по аккаунту
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? 'guest';
  String get _keyStreak         => 'streak_${_uid}';
  String get _keyTodayCompleted => 'todayCompleted_${_uid}';
  String get _keyLastVisit      => 'lastVisit_${_uid}';

  Future<void> init() async {
    box = await Hive.openBox('streakBox');
    _loadFromBox();
    _checkNewDay();
  }

  void _loadFromBox() {
    streak         = box.get(_keyStreak,         defaultValue: 0);
    todayCompleted = box.get(_keyTodayCompleted, defaultValue: false);
    final last = box.get(_keyLastVisit);
    lastVisit = last != null ? DateTime.parse(last) : null;
  }

  // Вызывать после входа в аккаунт
  Future<void> reloadForCurrentUser() async {
    _loadFromBox();
    _checkNewDay();
    notifyListeners();
  }

  void _checkNewDay() {
    final now = DateTime.now();
    if (lastVisit == null) {
      lastVisit = now;
      box.put(_keyLastVisit, now.toIso8601String());
      return;
    }
    final difference = now.difference(lastVisit!).inDays;
    if (difference >= 1) {
      if (!todayCompleted) streak = 0;
      todayCompleted = false;
      lastVisit = now;
      box.put(_keyLastVisit, now.toIso8601String());
      box.put(_keyTodayCompleted, false);
      box.put(_keyStreak, streak);
      notifyListeners();
    }
  }

  void completeLevel(int score) {
    if (score < 75) return;
    if (!todayCompleted) {
      streak++;
      if (streak > 7) streak = 7;
      todayCompleted = true;
      box.put(_keyStreak, streak);
      box.put(_keyTodayCompleted, true);
    }
    notifyListeners();
  }

  void resetStreak() {
    streak = 0;
    todayCompleted = false;
    box.put(_keyStreak, 0);
    box.put(_keyTodayCompleted, false);
    notifyListeners();
  }

  bool isDayActive() => todayCompleted;

  Future<void> clearForCurrentUser() async {
    await box.delete(_keyStreak);
    await box.delete(_keyTodayCompleted);
    await box.delete(_keyLastVisit);
    streak = 0;
    todayCompleted = false;
    lastVisit = null;
    notifyListeners();
  }
}