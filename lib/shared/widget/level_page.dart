import 'package:flutter/material.dart';

class LevelPage extends StatelessWidget {
  final int level;

  const LevelPage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Level $level")),
      body: Center(
        child: Text(
          "Задания уровня $level",
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}