import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

class LightTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.backgroundLight,

    colorScheme: const ColorScheme.light(
      background: AppColors.backgroundLight,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      error: AppColors.heartRed,
    ),

    dividerColor: AppColors.dividerLight,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBarLight,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: AppColors.textPrimaryLight,
      ),
    ),
  );
}