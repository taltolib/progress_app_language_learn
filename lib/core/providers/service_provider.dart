import 'dart:math';
import 'package:flutter/material.dart';
import 'package:progress/generated/image/app_image.dart';

class ServiceProvider extends ChangeNotifier {
  final List<String> _tips = [
    "Water — это вода. Пейте больше воды во время обучения!",
    "Учите по 5 новых слов каждый день.",
    "Смотрите фильмы на английском с субтитрами.",
    "Окружите себя английским языком: смените язык в телефоне.",
    "Не бойтесь совершать ошибки — это часть процесса.",
    "Практикуйте говорение перед зеркалом.",
    "Слушайте подкасты на английском в дороге.",
  ];

  final List<String> _compliments = [
    "Потрясающе!",
    "Отличная работа!",
    "Ты молодец!",
    "Так держать!",
    "Невероятный результат!",
    "Ты делаешь огромный прогресс!",
    "Гениально!",
  ];

  final List<Widget> _images = [
    AppImage().character.curious(width: 150, height: 150),
    AppImage().character.hardWork(width: 150, height: 150),
    AppImage().character.fluent2(width: 150, height: 150),
    AppImage().character.fluent(width: 150, height: 150),
    AppImage().character.hushed(width: 150, height: 150),
  ];


  String get randomTip => _tips[Random().nextInt(_tips.length)];
  String get randomCompliment => _compliments[Random().nextInt(_compliments.length)];
  Widget get randomImage => _images[Random().nextInt(_images.length)];
}
