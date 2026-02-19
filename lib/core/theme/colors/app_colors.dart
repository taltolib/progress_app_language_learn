import 'package:flutter/material.dart';

class AppColors {
  // =========================
  // BRAND (НЕ ЗАВИСИТ ОТ ТЕМЫ)
  // =========================

  static const Color brandGreen = Color(0xFF58CC02); // Duolingo green
  static const Color brandGreenPressed = Color(0xFF46A302);
  static const Color brandOnGreen = Colors.white;

  static const Color accentBlue = Color(0xFF1CB0F6); // уровни / secondary CTA
  static const Color accentOrange = Color(0xFFFFA500); // уровни (light)

  static const Color starYellow = Color(0xFFFFC800);
  static const Color heartRed = Color(0xFFFF4B4B);

  // =========================
  // LIGHT THEME
  // =========================

  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF7F7F7);

  static const Color textPrimaryLight = Color(0xFF2E2E2E); // не чисто чёрный
  static const Color textSecondaryLight = Color(0xFF7A7A7A);

  static const Color testBlackLight = Color(0xFF121212);

  static const Color borderLight = Color(0xFFE5E5E5);

  // =========================
  // DARK THEME
  // =========================

  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  static const Color testBlackDark = Color(0xFF000000);

  static const Color borderDark = Color(0xFF2A2D36);
}
