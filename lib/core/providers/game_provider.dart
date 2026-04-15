import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  double get accuracyPercentage =>
      (nextTask > 0) ? (score / (nextTask * 5)) * 100 : 0;

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

  // ── uid-префикс для всех ключей ───────────────────────────────────────
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? 'guest';
  String get _kHearts          => 'hearts_$_uid';
  String get _kStreakCount      => 'streakCount_$_uid';
  String get _kLastRefillTime   => 'lastRefillTime_$_uid';
  String get _kLastCompletedDate=> 'lastCompletedDate_$_uid';
  String get _kNextLevel        => 'nextLevel_$_uid';
  String get _kLevelResults     => 'levelResults_$_uid';
  String get _kWeekStatus       => 'weekStatus_$_uid';
  String get _kRandSubtitle     => 'randomStreakSubtitleKey_$_uid';
  String get _kRandBody         => 'randomStreakBodyKey_$_uid';
  String get _kRandTextsUpdate  => 'lastRandomTextsUpdate_$_uid';

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
    if (!_isDisposed) super.notifyListeners();
  }

  Future<void> _initHive() async {
    _box = Hive.box('game_data');
    _loadFromBox();
    _checkDailyStreak();
    _startHeartRefillTimer();
    _updateRandomWeeklyTexts();
    notifyListeners();
  }

  void _loadFromBox() {
    playerProgress.hearts = _box.get(_kHearts, defaultValue: 26);
    playerProgress.streakCount = _box.get(_kStreakCount, defaultValue: 0);

    final lastRefillRaw = _box.get(_kLastRefillTime);
    playerProgress.lastRefillTime =
    lastRefillRaw != null ? DateTime.parse(lastRefillRaw) : null;

    final lastCompletedRaw = _box.get(_kLastCompletedDate);
    playerProgress.lastCompletedDate =
    lastCompletedRaw != null ? DateTime.parse(lastCompletedRaw) : null;

    nextLevel = _box.get(_kNextLevel, defaultValue: 1);

    final savedResults = _box.get(_kLevelResults, defaultValue: {});
    levelResults = Map<int, int>.from(
        savedResults.map((k, v) => MapEntry(int.parse(k.toString()), v as int)));
  }

  Future<void> reloadForCurrentUser() async {
    _loadFromBox();
    _checkDailyStreak();
    _updateRandomWeeklyTexts();
    notifyListeners();
  }

  // Вызывать при выходе — сбрасывает данные в памяти
  void resetForLogout() {
    _gameTimer?.cancel();
    _heartTimer?.cancel();
    playerProgress = PlayerProgressModel(hearts: 26);
    levelResults = {};
    nextLevel = 1;
    score = 0;
    increaseInCondition = 0;
    nextTask = 0;
    weekProgress = List.filled(7, StreakDayStatus.pending);
    _refillCountdown = "20:00";
    notifyListeners();
    // Запускаем таймер заново (уже с пустым состоянием)
    _startHeartRefillTimer();
  }

  // Удалить все Hive-ключи текущего пользователя
  Future<void> clearHiveForCurrentUser() async {
    await _box.delete(_kHearts);
    await _box.delete(_kStreakCount);
    await _box.delete(_kLastRefillTime);
    await _box.delete(_kLastCompletedDate);
    await _box.delete(_kNextLevel);
    await _box.delete(_kLevelResults);
    await _box.delete(_kWeekStatus);
    await _box.delete(_kRandSubtitle);
    await _box.delete(_kRandBody);
    await _box.delete(_kRandTextsUpdate);
  }

  void _updateRandomWeeklyTexts() {
    final now = DateTime.now();
    final lastUpdateRaw = _box.get(_kRandTextsUpdate);
    DateTime? lastUpdate =
    lastUpdateRaw != null ? DateTime.parse(lastUpdateRaw) : null;

    if (lastUpdate == null || now.difference(lastUpdate).inDays >= 7) {
      int randomIndex = Random().nextInt(5) + 1;
      randomStreakSubtitleKey = "streak_subtitle_$randomIndex";
      randomStreakBodyKey = "streak_body_$randomIndex";
      _box.put(_kRandSubtitle, randomStreakSubtitleKey);
      _box.put(_kRandBody, randomStreakBodyKey);
      _box.put(_kRandTextsUpdate, now.toIso8601String());
    } else {
      randomStreakSubtitleKey =
          _box.get(_kRandSubtitle, defaultValue: "streak_subtitle_1");
      randomStreakBodyKey =
          _box.get(_kRandBody, defaultValue: "streak_body_1");
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
      if (today.difference(lastDate).inDays > 1) {
        playerProgress.streakCount = 0;
        _box.put(_kStreakCount, 0);
      }
    }

    int currentWeekday = now.weekday % 7;
    List<String> savedWeek = List<String>.from(
        _box.get(_kWeekStatus, defaultValue: List.filled(7, 'pending')));

    for (int i = 0; i < currentWeekday; i++) {
      if (savedWeek[i] == 'pending') savedWeek[i] = 'frozen';
    }
    _box.put(_kWeekStatus, savedWeek);
    weekProgress = savedWeek
        .map((e) => StreakDayStatus.values.firstWhere((v) => v.name == e))
        .toList();
  }

  void _startHeartRefillTimer() {
    _heartTimer?.cancel();
    _heartTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed) { timer.cancel(); return; }
      _processHeartRefill();
    });
  }

  void _processHeartRefill() {
    if (playerProgress.hearts >= 26) {
      _refillCountdown = "20:00";
      playerProgress.lastRefillTime = null;
      _box.delete(_kLastRefillTime);
      notifyListeners();
      return;
    }

    final now = DateTime.now();
    if (playerProgress.lastRefillTime == null) {
      playerProgress.lastRefillTime = now;
      _box.put(_kLastRefillTime, now.toIso8601String());
    }

    final diff = now.difference(playerProgress.lastRefillTime!);
    const refillInterval = Duration(minutes: 20);

    if (diff >= refillInterval) {
      int refills = diff.inMinutes ~/ 20;
      playerProgress.hearts = min(26, playerProgress.hearts + (refills * 2));
      playerProgress.lastRefillTime =
          playerProgress.lastRefillTime!.add(Duration(minutes: refills * 20));
      _box.put(_kHearts, playerProgress.hearts);
      _box.put(_kLastRefillTime, playerProgress.lastRefillTime!.toIso8601String());
    }

    final timeToNext = refillInterval - now.difference(playerProgress.lastRefillTime!);
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
      if (_isDisposed || isLevelFinished) { timer.cancel(); return; }
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
        _box.put(_kHearts, playerProgress.hearts);
        if (playerProgress.lastRefillTime == null) {
          playerProgress.lastRefillTime = DateTime.now();
          _box.put(_kLastRefillTime, playerProgress.lastRefillTime!.toIso8601String());
        }
      }
      increaseInCondition += 5;
    }
    nextTask++;
    selectedIndex = null;
    notifyListeners();
  }

  void finishLevel(int levelId) async {
    if (isLevelFinished) return;
    isLevelFinished = true;
    stopTimer();

    int oldScore = levelResults[levelId] ?? 0;
    if (score > oldScore) {
      levelResults[levelId] = score;
      final mapToSave = levelResults.map((k, v) => MapEntry(k.toString(), v));
      _box.put(_kLevelResults, mapToSave);
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'nextLevel': nextLevel,
          'hearts': playerProgress.hearts,
          'streakCount': playerProgress.streakCount,
          'levelResults': levelResults.map((k, v) => MapEntry(k.toString(), v)),
          'lastCompletedDate': playerProgress.lastCompletedDate?.toIso8601String(),
        });
      }
    }

    if (accuracyPercentage >= 75) {
      _updateStreak();
      if (levelId == nextLevel) {
        nextLevel++;
        _box.put(_kNextLevel, nextLevel);
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
      if (lastDate.isAtSameMomentAs(today)) return;
      playerProgress.streakCount =
      today.difference(lastDate).inDays == 1 ? playerProgress.streakCount + 1 : 1;
    } else {
      playerProgress.streakCount = 1;
    }

    playerProgress.lastCompletedDate = now;
    _box.put(_kStreakCount, playerProgress.streakCount);
    _box.put(_kLastCompletedDate, now.toIso8601String());

    int currentWeekday = now.weekday % 7;
    List<String> savedWeek = List<String>.from(
        _box.get(_kWeekStatus, defaultValue: List.filled(7, 'pending')));
    savedWeek[currentWeekday] = 'completed';
    _box.put(_kWeekStatus, savedWeek);
    weekProgress = savedWeek
        .map((e) => StreakDayStatus.values.firstWhere((v) => v.name == e))
        .toList();
  }

  Future<void> loadFromFirestore(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) return;
    final data = doc.data()!;

    nextLevel = data['nextLevel'] ?? 1;
    playerProgress.hearts = data['hearts'] ?? 26;
    playerProgress.streakCount = data['streakCount'] ?? 0;

    final results = Map<String, dynamic>.from(data['levelResults'] ?? {});
    levelResults = results.map((k, v) => MapEntry(int.parse(k), v as int));

    _box.put(_kNextLevel, nextLevel);
    _box.put(_kHearts, playerProgress.hearts);
    _box.put(_kStreakCount, playerProgress.streakCount);
    _box.put(_kLevelResults, results);

    notifyListeners();
  }
}