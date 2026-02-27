import 'package:flutter/material.dart';

class TaskDetailPage extends StatelessWidget {
  final int taskId;

  const TaskDetailPage({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Level $taskId"),
      ),
      body: Center(
        child: Text(
          "Задания уровня $taskId",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}