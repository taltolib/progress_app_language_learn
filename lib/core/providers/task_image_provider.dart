import 'dart:math';
import 'package:flutter/material.dart';
import 'package:progress/generated/image/app_image.dart';

class TaskImageProvider extends ChangeNotifier {
  final List<Widget> _images = [
    AppImage().character.proud(width: 150, height: 150),
    AppImage().character.proud2(width: 150, height: 150),
    AppImage().character.curious(width: 150, height: 150),
    AppImage().character.celebration(width: 150, height: 150),
    AppImage().character.fluent2(width: 150, height: 150),
    AppImage().character.happy(width: 150, height: 150),
    AppImage().character.excited(width: 150, height: 150),
    AppImage().character.fluent(width: 150, height: 150),
  ];

  List<Widget> get images => _images;

  Widget getRandomImage(int taskIndex, int levelId) {
    final random = Random(taskIndex + levelId);
    return _images[random.nextInt(_images.length)];
  }
}
