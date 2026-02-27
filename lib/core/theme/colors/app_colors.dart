import 'package:flutter/material.dart';

class AppColors {
  // =========================
  // BRAND (НЕ ЗАВИСИТ ОТ ТЕМЫ)
  // =========================

  static const Color brandGreen = Color(0xFF58CC02);
  static const Color brandGreenPressed = Color(0xFF46A302);
  static const Color brandOnGreen = Colors.white;

  static const Color accentBlue = Color(0xFF1CB0F6);
  static const Color accentOrange = Color(0xFFFFA500);

  static const Color goldColors = Color(0xFFFFD54F);
  static const Color darkGold = Color(0xFFE0B800);

  static const Color starYellow = Color(0xFFFFC800);
  static const Color heartRed = Color(0xFFFF4B4B);

  // =========================================================
  // LIGHT THEME (ИЗМЕНЕНО ТОЛЬКО ЗДЕСЬ)
  // =========================================================

  /// Основной фон (как в iOS приложениях)
  static const Color backgroundLight = Color(0xFFF2F2F7);

  /// Карточки белые
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// AppBar того же цвета что фон
  static const Color appBarLight = Color(0xFFF2F2F7);

  /// Бордер карточек
  static const Color borderLight = Color(0xFFE5E5EA);

  /// Разделители
  static const Color dividerLight = Color(0xFFD1D1D6);

  static const Color textPrimaryLight = Color(0xFF000000);
  static const Color textSecondaryLight = Color(0xFF6C6C70);

  static const Color testBlackLight = Color(0xFF121212);

  // =========================================================
  // DARK THEME (НЕ ТРОГАЕМ)
  // =========================================================

  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  static const Color testBlackDark = Color(0xFF000000);

  static const Color borderDark = Color(0xFF2A2D36);
}