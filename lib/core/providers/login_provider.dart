import 'package:flutter/material.dart';
import 'package:progress/core/hive/app_prefs.dart';
import 'package:progress/core/providers/auth_provider.dart';
import 'package:progress/core/providers/favorites_provider.dart';
import 'package:progress/core/providers/game_provider.dart';
import 'package:progress/core/providers/streak_provider.dart';
import 'package:progress/shared/widget/%20top_snackbar.dart';
import 'package:provider/provider.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> handleLogin(BuildContext context, AuthProvider authProvider) async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (phone.isEmpty) {
      TopSnackBar.show(context, 'Введите номер телефона');
      return;
    }
    if (phone.length < 9) {
      TopSnackBar.show(context, 'Введите корректный номер (9 цифр)');
      return;
    }
    if (password.isEmpty) {
      TopSnackBar.show(context, 'Введите пароль');
      return;
    }

    _isLoading = true;
    notifyListeners();

    final success = await authProvider.signInWithPassword(phone, password);
    if (!context.mounted) return;
    if (!success) {
      TopSnackBar.show(context, authProvider.errorMessage ?? 'Ошибка входа');
    } else {
      final gameProvider = context.read<GameProvider>();
      final favoritesProvider = context.read<FavoritesProvider>();
      final streakProvider = context.read<StreakProvider>();

      await gameProvider.reloadForCurrentUser();
      await favoritesProvider.reloadForCurrentUser();
      await streakProvider.reloadForCurrentUser();

      final uid = authProvider.currentUser?.uid;
      if (uid != null && context.mounted) {
        await gameProvider.loadFromFirestore(uid);
        await AppPrefs.setSeen();
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}