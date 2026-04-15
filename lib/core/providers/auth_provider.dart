import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:progress/core/hive/app_prefs.dart';
import 'package:progress/domain/enums/auth_status.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController phoneController = TextEditingController();

  AuthStatus _status = AuthStatus.initial;
  AuthStatus get status => _status;

  String? _verificationId;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _loggedInUid;

  // ✅ Проверяем И Firebase сессию И сохранённый флаг в SharedPreferences
  bool get isLoggedIn =>
      _auth.currentUser != null || AppPrefs.isLoggedIn;

  User? get currentUser => _auth.currentUser;

  AuthProvider() {
    _auth.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  Future<bool> signInWithPassword(String phone, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final fullPhone = '+998$phone';
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: fullPhone)
          .limit(1)
          .get();

      if (doc.docs.isEmpty) {
        _errorMessage = 'Аккаунт с таким номером не найден';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }

      final userData = doc.docs.first.data();
      final storedHash = userData['passwordHash'] as String?;
      final inputHash = sha256.convert(utf8.encode(password)).toString();

      if (storedHash == null || storedHash != inputHash) {
        _errorMessage = 'Неверный пароль';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }

      _loggedInUid = doc.docs.first.id;
      _status = AuthStatus.verified;

      // ✅ Сохраняем факт входа в SharedPreferences
      await AppPrefs.saveLoggedIn(true);
      // ✅ Помечаем что пользователь прошёл логин экран
      await AppPrefs.setSeen();

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка входа. Попробуйте снова';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> isPhoneAlreadyRegistered(String phone) async {
    final fullPhone = '+998$phone';
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: fullPhone)
        .limit(1)
        .get();
    return doc.docs.isNotEmpty;
  }

  Future<void> sendOtp(String phoneNumber) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+998$cleanPhone',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
          if (e.code == 'billing-not-enabled' ||
              (e.message?.contains('BILLING_NOT_ENABLED') ?? false)) {
            _errorMessage = 'Ошибка конфигурации сервера (Billing).';
          } else if (e.code == 'invalid-phone-number') {
            _errorMessage = 'Неверный формат номера телефона.';
          } else {
            _errorMessage = e.message ?? 'Ошибка верификации';
          }
          _status = AuthStatus.error;
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _status = AuthStatus.codeSent;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      debugPrint('General Auth Error: $e');
      _errorMessage = 'Произошла непредвиденная ошибка';
      _status = AuthStatus.error;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String smsCode) async {
    if (_verificationId == null) return false;

    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      await _signInWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    await _auth.signInWithCredential(credential);
    _loggedInUid = _auth.currentUser?.uid;
    _status = AuthStatus.verified;

    // ✅ Сохраняем сессию в SharedPreferences
    await AppPrefs.saveLoggedIn(true);
    await AppPrefs.setSeen();

    notifyListeners();
  }

  Future<void> signOut() async {
    final uid = _auth.currentUser?.uid ?? _loggedInUid;

    await _auth.signOut();

    if (uid != null) {
      await _clearHiveForUser(uid);
    }

    // ✅ Сбрасываем флаги при выходе
    await AppPrefs.saveLoggedIn(false);
    await AppPrefs.setSeen(); // loginScreen остаётся true — инструкция показана

    phoneController.clear();
    _loggedInUid = null;
    _status = AuthStatus.initial;
    notifyListeners();
  }

  Future<void> _clearHiveForUser(String uid) async {
    if (Hive.isBoxOpen('game_data')) {
      final box = Hive.box('game_data');
      final keysToDelete = box.keys
          .where((k) =>
      k.toString().endsWith('_$uid') ||
          k.toString().contains('_${uid}_'))
          .toList();
      for (final key in keysToDelete) {
        await box.delete(key);
      }
    }

    if (Hive.isBoxOpen('streakBox')) {
      final box = Hive.box('streakBox');
      await box.delete('streak_$uid');
      await box.delete('todayCompleted_$uid');
      await box.delete('lastVisit_$uid');
    }
  }

  Future<bool> deleteAccount() async {
    try {
      final uid = _auth.currentUser?.uid ?? _loggedInUid;

      if (uid == null) {
        _errorMessage = 'Не удалось определить аккаунт. Войдите заново.';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      await _clearHiveForUser(uid);

      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.delete();
      }

      // ✅ Сбрасываем сохранённую сессию
      await AppPrefs.saveLoggedIn(false);

      phoneController.clear();
      _loggedInUid = null;
      _status = AuthStatus.initial;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _errorMessage = 'Войдите заново через SMS и попробуйте снова';
      } else {
        _errorMessage = e.message;
      }
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Ошибка удаления аккаунта';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}