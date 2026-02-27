class TaskLevelModel {
  final int id;
  final int stars; // 0-3
  final double progress; // 0.0 - 1.0

  TaskLevelModel({
    required this.id,
    required this.stars,
    required this.progress,
  });

  bool get isCompleted => progress == 1.0;
}