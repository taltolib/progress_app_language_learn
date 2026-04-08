import 'dart:math';
import 'package:flutter/material.dart';
import 'package:progress/generated/image/app_image.dart';
import 'package:progress/generated/tr/locale_keys.dart';

class LoadingLevelProvider extends ChangeNotifier {
  final List<String> _tips = [
    LocaleKeys.tip1,
    LocaleKeys.tip2,
    LocaleKeys.tip3,
    LocaleKeys.tip4,
    LocaleKeys.tip5,
    LocaleKeys.tip6,
    LocaleKeys.tip7,
  ];

  final List<String> _compliments = [
    LocaleKeys.compliment1,
    LocaleKeys.compliment2,
    LocaleKeys.streakBody4,
    LocaleKeys.compliment3,
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
