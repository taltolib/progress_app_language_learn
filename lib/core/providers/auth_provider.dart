import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress/domain/enums/auth_status.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController phoneController = TextEditingController();

  AuthStatus _status = AuthStatus.initial;
  AuthStatus get status => _status;

  String? _verificationId;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoggedIn = false;
  String? _loggedInUid; // uid сохраняем при входе через пароль
  bool get isLoggedIn => _auth.currentUser != null || _isLoggedIn;

  User? get currentUser => _auth.currentUser;

  AuthProvider() {
    _auth.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  // ── Вход по номеру + паролю ───────────────────────────────────────────
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

      // Пароль верный — сохраняем uid и ставим флаг входа
      _loggedInUid = doc.docs.first.id; // id документа = uid пользователя
      _isLoggedIn = true;
      _status = AuthStatus.verified;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка входа. Попробуйте снова';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // ── Проверка: существует ли аккаунт с этим номером ───────────────────
  Future<bool> isPhoneAlreadyRegistered(String phone) async {
    final fullPhone = '+998$phone';
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: fullPhone)
        .limit(1)
        .get();
    return doc.docs.isNotEmpty;
  }

  // ─────────────────────────────────────────────────────────────────────
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
    _isLoggedIn = true;
    _loggedInUid = _auth.currentUser?.uid;
    _status = AuthStatus.verified;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    phoneController.clear();
    _isLoggedIn = false;
    _loggedInUid = null;
    _status = AuthStatus.initial;
    notifyListeners();
  }

  // ── Удаление аккаунта ─────────────────────────────────────────────────
  Future<bool> deleteAccount() async {
    try {
      // uid берём из Firebase Auth если есть, иначе из сохранённого при входе через пароль
      final uid = _auth.currentUser?.uid ?? _loggedInUid;

      if (uid == null) {
        _errorMessage = 'Не удалось определить аккаунт. Войдите заново.';
        _status = AuthStatus.error;
        notifyListeners();
        return false;
      }

      // Удаляем данные из Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      // Удаляем Firebase Auth аккаунт (только если есть активная сессия)
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.delete();
      }

      phoneController.clear();
      _isLoggedIn = false;
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