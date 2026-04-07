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

  User? get currentUser => _auth.currentUser;


  AuthProvider() {
    _auth.authStateChanges().listen((_) {
      notifyListeners();
    });
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


          if (e.code == 'billing-not-enabled' || (e.message?.contains('BILLING_NOT_ENABLED') ?? false)) {
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
    _status = AuthStatus.verified;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    phoneController.clear();
    _status = AuthStatus.initial;
    notifyListeners();
  }


  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await user.delete();
      phoneController.clear();
      _status = AuthStatus.initial;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.error;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}