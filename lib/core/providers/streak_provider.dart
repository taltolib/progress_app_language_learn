import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class StreakProvider extends ChangeNotifier {
  late Box box;

  int streak = 0;
  DateTime? lastVisit;
  bool todayCompleted = false;

  Future<void> init() async {
    box = await Hive.openBox('streakBox');

    streak = box.get('streak', defaultValue: 0);
    todayCompleted = box.get('todayCompleted', defaultValue: false);

    final last = box.get('lastVisit');
    if (last != null) {
      lastVisit = DateTime.parse(last);
    }

    _checkNewDay();
  }

  // 📅 Проверка нового дня
  void _checkNewDay() {
    final now = DateTime.now();

    if (lastVisit == null) {
      lastVisit = now;
      box.put('lastVisit', now.toIso8601String());
      return;
    }

    final difference = now.difference(lastVisit!).inDays;

    if (difference >= 1) {
      // ❌ пропустил день → сброс
      if (!todayCompleted) {
        streak = 0;
      }

      todayCompleted = false;

      lastVisit = now;
      box.put('lastVisit', now.toIso8601String());
      box.put('todayCompleted', false);
      box.put('streak', streak);

      notifyListeners();
    }
  }

  // 🏆 Когда уровень завершен
  void completeLevel(int score) {
    if (score < 75) return; // ❌ не считается

    if (!todayCompleted) {
      streak++;

      if (streak > 7) streak = 7;

      todayCompleted = true;

      box.put('streak', streak);
      box.put('todayCompleted', true);
    }

    notifyListeners();
  }

  // ❌ если пропустил день вручную
  void resetStreak() {
    streak = 0;
    todayCompleted = false;

    box.put('streak', 0);
    box.put('todayCompleted', false);

    notifyListeners();
  }

  // 🔍 Проверка активности дня
  bool isDayActive() {
    return todayCompleted;
  }
}