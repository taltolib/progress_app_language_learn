import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:progress/domain/enums/streak_day_status.dart';
import 'package:progress/domain/models/player_progress_model.dart';

class GameProvider extends ChangeNotifier {
  late Box _box;
  PlayerProgressModel playerProgress = PlayerProgressModel(hearts: 26);
  Map<int, int> levelResults = {}; 
  
  int score = 0;                
  int increaseInCondition = 0;  
  int nextTask = 0;             
  int nextLevel = 1;            
  int? currentLevelId;          
  
  int? selectedIndex;
  int correctIndex = 0;

  int errorCount = 0;
  double get accuracyPercentage => (nextTask > 0) ? (score / (nextTask * 5)) * 100 : 0;
  
  // ignore: prefer_final_fields
  Stopwatch _stopwatch = Stopwatch();
  Timer? _gameTimer;
  String _formattedTime = "00:00";
  String get formattedTime => _formattedTime;

  bool _isDisposed = false;
  bool isLevelFinished = false;

  Timer? _heartTimer;
  String _refillCountdown = "20:00";
  String get refillCountdown => _refillCountdown;


  List<StreakDayStatus> weekProgress = List.filled(7, StreakDayStatus.pending);
  String randomStreakSubtitleKey = "streak_subtitle_1";
  String randomStreakBodyKey = "streak_body_1";

  GameProvider() {
    _initHive();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _gameTimer?.cancel();
    _heartTimer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  Future<void> _initHive() async {
    _box = Hive.box('game_data');
    playerProgress.hearts = _box.get('hearts', defaultValue: 26);
    playerProgress.streakCount = _box.get('streakCount', defaultValue: 0);
    
    final lastRefillRaw = _box.get('lastRefillTime');
    if (lastRefillRaw != null) {
      playerProgress.lastRefillTime = DateTime.parse(lastRefillRaw);
    }
    
    final lastCompletedRaw = _box.get('lastCompletedDate');
    if (lastCompletedRaw != null) {
      playerProgress.lastCompletedDate = DateTime.parse(lastCompletedRaw);
    }

    nextLevel = _box.get('nextLevel', defaultValue: 1);
    
    final savedResults = _box.get('levelResults', defaultValue: {});
    levelResults = Map<int, int>.from(savedResults.map((k, v) => MapEntry(int.parse(k.toString()), v as int)));
    
    _checkDailyStreak();
    _startHeartRefillTimer();
    _updateRandomWeeklyTexts();
    notifyListeners();
  }

  void _updateRandomWeeklyTexts() {
    final now = DateTime.now();
    final lastUpdateRaw = _box.get('lastRandomTextsUpdate');
    DateTime? lastUpdate;
    if (lastUpdateRaw != null) {
      lastUpdate = DateTime.parse(lastUpdateRaw);
    }

    if (lastUpdate == null || now.difference(lastUpdate).inDays >= 7) {
      int randomIndex = Random().nextInt(5) + 1;
      randomStreakSubtitleKey = "streak_subtitle_$randomIndex";
      randomStreakBodyKey = "streak_body_$randomIndex";
      
      _box.put('randomStreakSubtitleKey', randomStreakSubtitleKey);
      _box.put('randomStreakBodyKey', randomStreakBodyKey);
      _box.put('lastRandomTextsUpdate', now.toIso8601String());
    } else {
      randomStreakSubtitleKey = _box.get('randomStreakSubtitleKey', defaultValue: "streak_subtitle_1");
      randomStreakBodyKey = _box.get('randomStreakBodyKey', defaultValue: "streak_body_1");
    }
  }

  void _checkDailyStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (playerProgress.lastCompletedDate != null) {
      final lastDate = DateTime(
        playerProgress.lastCompletedDate!.year,
        playerProgress.lastCompletedDate!.month,
        playerProgress.lastCompletedDate!.day,
      );
      
      final difference = today.difference(lastDate).inDays;
      
      if (difference > 1) {
        playerProgress.streakCount = 0;
        _box.put('streakCount', 0);
      }
    }

    int currentWeekday = now.weekday % 7; 
    List<String> savedWeek = List<String>.from(_box.get('weekStatus', defaultValue: List.filled(7, 'pending')));
    
    for (int i = 0; i < currentWeekday; i++) {
      if (savedWeek[i] == 'pending') {
        savedWeek[i] = 'frozen';
      }
    }
    
    _box.put('weekStatus', savedWeek);
    weekProgress = savedWeek.map((e) => StreakDayStatus.values.firstWhere((v) => v.name == e)).toList();
  }

  void _startHeartRefillTimer() {
    _heartTimer?.cancel();
    _heartTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      _processHeartRefill();
    });
  }

  void _processHeartRefill() {
    if (playerProgress.hearts >= 26) {
      _refillCountdown = "20:00";
      playerProgress.lastRefillTime = null;
      _box.delete('lastRefillTime');
      notifyListeners();
      return;
    }

    final now = DateTime.now();
    if (playerProgress.lastRefillTime == null) {
      playerProgress.lastRefillTime = now;
      _box.put('lastRefillTime', now.toIso8601String());
    }

    final diff = now.difference(playerProgress.lastRefillTime!);
    final refillInterval = const Duration(minutes: 20);
    
    if (diff >= refillInterval) {
      int refills = diff.inMinutes ~/ 20;
      playerProgress.hearts = min(26, playerProgress.hearts + (refills * 2));
      playerProgress.lastRefillTime = playerProgress.lastRefillTime!.add(Duration(minutes: refills * 20));
      _box.put('hearts', playerProgress.hearts);
      _box.put('lastRefillTime', playerProgress.lastRefillTime!.toIso8601String());
    }

    final timeToNext = refillInterval - (now.difference(playerProgress.lastRefillTime!));
    final minutes = timeToNext.inMinutes.toString().padLeft(2, '0');
    final seconds = (timeToNext.inSeconds % 60).toString().padLeft(2, '0');
    _refillCountdown = "$minutes:$seconds";
    notifyListeners();
  }

  void selectIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void startLevel(int levelId) {
    currentLevelId = levelId;
    score = 0;
    increaseInCondition = 0;
    nextTask = 0;
    errorCount = 0;
    selectedIndex = null;
    isLevelFinished = false;
    
    _stopwatch.reset();
    _stopwatch.start();
    _startGameTimer();
    
    notifyListeners();
  }

  void _startGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed || isLevelFinished) {
        timer.cancel();
        return;
      }
      final minutes = _stopwatch.elapsed.inMinutes.toString().padLeft(2, '0');
      final seconds = (_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
      _formattedTime = "$minutes:$seconds";
      notifyListeners();
    });
  }

  void stopTimer() {
    _stopwatch.stop();
    _gameTimer?.cancel();
  }

  void confirmAnswer(int index) {
    if (index == correctIndex) {
      score += 5;
      increaseInCondition += 5;
    } else {
      errorCount++;
      if (playerProgress.hearts > 0) {
        playerProgress.hearts--;
        _box.put('hearts', playerProgress.hearts);
        if (playerProgress.lastRefillTime == null) {
           playerProgress.lastRefillTime = DateTime.now();
           _box.put('lastRefillTime', playerProgress.lastRefillTime!.toIso8601String());
        }
      }
      increaseInCondition += 5;
    }
    
    nextTask++;
    selectedIndex = null;
    notifyListeners();
  }

  void finishLevel(int levelId) {
    if (isLevelFinished) return;
    
    isLevelFinished = true;
    stopTimer();
    
    int oldScore = levelResults[levelId] ?? 0;
    if (score > oldScore) {
      levelResults[levelId] = score;
      final mapToSave = levelResults.map((k, v) => MapEntry(k.toString(), v));
      _box.put('levelResults', mapToSave);
    }

    double accuracy = accuracyPercentage;

    if (accuracy >= 75) {
      _updateStreak();
      if (levelId == nextLevel) {
        nextLevel++;
        _box.put('nextLevel', nextLevel);
      }
    }
    
    notifyListeners();
  }

  void _updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (playerProgress.lastCompletedDate != null) {
      final lastDate = DateTime(
        playerProgress.lastCompletedDate!.year,
        playerProgress.lastCompletedDate!.month,
        playerProgress.lastCompletedDate!.day,
      );
      
      if (lastDate.isAtSameMomentAs(today)) {
        return;
      }
      
      if (today.difference(lastDate).inDays == 1) {
        playerProgress.streakCount++;
      } else {
        playerProgress.streakCount = 1;
      }
    } else {
      playerProgress.streakCount = 1;
    }
    
    playerProgress.lastCompletedDate = now;
    _box.put('streakCount', playerProgress.streakCount);
    _box.put('lastCompletedDate', now.toIso8601String());

    int currentWeekday = now.weekday % 7; 
    List<String> savedWeek = List<String>.from(_box.get('weekStatus', defaultValue: List.filled(7, 'pending')));
    savedWeek[currentWeekday] = 'completed';
    _box.put('weekStatus', savedWeek);
    weekProgress = savedWeek.map((e) => StreakDayStatus.values.firstWhere((v) => v.name == e)).toList();
  }
}
