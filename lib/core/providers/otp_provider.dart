import 'package:flutter/material.dart';

class OtpProvider extends ChangeNotifier {
  final List<TextEditingController> controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes =
  List.generate(6, (_) => FocusNode());

  String get otpCode =>
      controllers.map((c) => c.text).join();

  void onChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
    notifyListeners();
  }

  void clear() {
    for (final c in controllers) {
      c.clear();
    }
    focusNodes[0].requestFocus();
    notifyListeners();
  }

  @override
  void dispose() {
    for (final c in controllers) c.dispose();
    for (final f in focusNodes) f.dispose();
    super.dispose();
  }
}