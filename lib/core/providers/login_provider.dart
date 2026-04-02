import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progress/shared/widget/%20top_snackbar.dart';

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

  // Хэшируем пароль перед сравнением (пароли не хранят в открытом виде)
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<void> handleLogin(BuildContext context) async {
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

    try {
      final fullPhone = '+998$phone';
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: fullPhone)
          .limit(1)
          .get();

      if (!context.mounted) return;

      if (doc.docs.isEmpty) {
        TopSnackBar.show(context, 'Аккаунт с таким номером не найден');
        return;
      }

      final userData = doc.docs.first.data();
      final storedHash = userData['passwordHash'] as String?;

      if (storedHash == null || storedHash != _hashPassword(password)) {
        TopSnackBar.show(context, 'Неверный пароль');
        return;
      }

      // Всё верно — входим
      context.go('/main');
    } catch (e) {
      if (context.mounted) {
        TopSnackBar.show(context, 'Ошибка входа. Попробуйте снова');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}