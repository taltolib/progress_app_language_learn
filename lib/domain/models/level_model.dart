import 'package:progress/domain/models/level_status.dart';
import 'package:progress/domain/models/task_model.dart';

class LevelModel {
  final int id;
  final List<TaskModel> tasks;

  int score;
  int currentQuestionIndex;

  LevelModel({
    required this.id,
    required this.tasks,
    this.score = 0,
    this.currentQuestionIndex = 0,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    final tasks = json['tasks'] as List;
    final taskModels = tasks.map((task) => TaskModel.fromJson(task)).toList();
    return LevelModel(
      id: json['id'] ?? json['level'] ?? 0,
      tasks: taskModels,
    );

  }

  LevelStatus get status => getStatus(score);
}
