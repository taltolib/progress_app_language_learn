import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:progress/domain/models/level_model.dart';

class TaskGenerator {
  static const String _base = 'assets/levels';

  // Инициализируем пустым списком, чтобы избежать LateInitializationError
  static List<LevelModel> allLevels = [];

   static Future<void> loadLevels() async {
    final a1 = await TaskGenerator.loadAllLevels('a1');
    final a2 = await TaskGenerator.loadAllLevels('a2');
    allLevels = [...a1, ...a2];
  }

  static Future<LevelModel> loadLevel(String difficulty,  int level ) async {
    final path = '$_base/$difficulty/level_$level.json';
    final data = await rootBundle.loadString(path);
    final json = jsonDecode(data);
    return LevelModel.fromJson(json);
  }

  static Future<List<LevelModel>> loadAllLevels(String difficulty) async {
    List<LevelModel> levels = [];
    for (int i = 1; i <= 40; i++) {
      try {
        final level = await loadLevel(difficulty, i);
        levels.add(level);
      } catch (e) {
        if (kDebugMode) {
          print('Error loading level $i for $difficulty: $e');
        }
      }
    }
    return levels;
  }

  static Future<LevelModel> loadOneLevel(int levelId) async {
    // Если список пуст, загружаем все уровни
    if (allLevels.isEmpty) {
      await loadLevels();
    }
    
    // Ищем уровень по ID. Если не нашли, можно вернуть первый или кинуть ошибку.
    return allLevels.firstWhere(
      (level) => level.id == levelId,
      orElse: () => allLevels.isNotEmpty ? allLevels.first : throw Exception('Level not found'),
    );
  }
}
