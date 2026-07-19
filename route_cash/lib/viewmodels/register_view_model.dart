import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  String? validateAndRegister(String name, String email, String password) {
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      return 'Completa todos los campos';
    }
    return null; // Éxito, sin errores
  }
}
