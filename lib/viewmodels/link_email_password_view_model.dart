import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../utils/email_validator.dart';

class LinkEmailPasswordViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String email = '';
  String password = '';
  String confirmPassword = '';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Password requirements
  bool hasUppercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;
  bool hasMinLength = false;
  bool passwordsMatch = false;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  void updateEmail(String val) {
    email = val;
    notifyListeners();
  }

  void updatePassword(String val) {
    password = val;
    _validatePassword();
    notifyListeners();
  }

  void updateConfirmPassword(String val) {
    confirmPassword = val;
    _validatePassword();
    notifyListeners();
  }

  void _validatePassword() {
    hasUppercase = password.contains(RegExp(r'[A-Z]'));
    hasNumber = password.contains(RegExp(r'[0-9]'));
    hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    hasMinLength = password.length >= 8;
    passwordsMatch = password.isNotEmpty && password == confirmPassword;
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  bool get canSubmit =>
      EmailValidator.isValid(email) &&
      hasMinLength &&
      hasUppercase &&
      hasNumber &&
      hasSpecialChar &&
      passwordsMatch;

  Future<String?> submit() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _authService.currentUser;
      if (user == null) return 'No hay sesión activa';

      // Siempre actualizamos la contraseña primero. Esto es inmediato para el usuario actual.
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: password),
      );

      // NO actualizamos el email aquí si es diferente, para evitar que Supabase envíe
      // su propio correo de confirmación simultáneamente con nuestro OTP personalizado.
      // El cambio de email se completará en OtpVerificationScreen tras validar nuestro OTP.

      return null;
    } catch (e) {
      debugPrint('Error linking email/password: $e');
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
