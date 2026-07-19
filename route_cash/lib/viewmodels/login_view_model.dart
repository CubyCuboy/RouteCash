import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  String? validateAndLogin(String email, String password) {
    if (email.trim().isEmpty || password.isEmpty) {
      return 'Ingresa tu correo y contraseña';
    }
    return null; // Éxito, sin errores
  }
}
