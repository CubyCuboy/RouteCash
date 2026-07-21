import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get isLoading => _isLoading;

  // Requisitos de contraseña
  bool hasUppercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;
  bool hasMinLength = false;
  bool passwordsMatch = false;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void validatePassword(String password, String confirmPassword) {
    hasUppercase = password.contains(RegExp(r'[A-Z]'));
    hasNumber = password.contains(RegExp(r'[0-9]'));
    hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    hasMinLength = password.length >= 8;
    passwordsMatch = password.isNotEmpty && password == confirmPassword;
    notifyListeners();
  }

  String formatName(String name) {
    if (name.isEmpty) return name;
    return name.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  bool isValidEmailDomain(String email) {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<String?> register(String name, String email, String password, String confirmPassword) async {
    final formattedName = formatName(name.trim());
    final lowerEmail = email.trim().toLowerCase();

    if (formattedName.isEmpty || lowerEmail.isEmpty || password.isEmpty) {
      return 'all_fields_required';
    }

    if (!isValidEmailDomain(lowerEmail)) {
      return 'invalidEmail';
    }

    if (!hasUppercase || !hasNumber || !hasSpecialChar || !hasMinLength) {
      return 'weakPassword';
    }

    if (password != confirmPassword) {
      return 'passwordsDoNotMatch';
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signUp(lowerEmail, password, formattedName);
      await _authService.saveWelcomeMessage(formattedName);
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

