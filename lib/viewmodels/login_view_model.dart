import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/email_validator.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _obscurePassword = true;
  bool _isLoading = false;

  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool _rememberMe = true;
  bool get rememberMe => _rememberMe;

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return 'empty_fields';
    }

    if (!EmailValidator.isValid(email)) {
      return 'invalidEmail';
    }

    final cleanEmail = EmailValidator.normalize(email);

    _isLoading = true;
    notifyListeners();

    try {
      // Limpiar sesión previa para evitar que el ID de un usuario no verificado 
      // se quede "pegado" en el cliente de Supabase
      await _authService.signOut();

      await _authService.signIn(cleanEmail, password);
      
      final user = _authService.currentUser;
      final name = user?.userMetadata?['full_name'] ?? cleanEmail;
      await _authService.saveWelcomeMessage(name);

      // Persistencia de sesión manejada por Supabase por defecto, 
      // pero podríamos añadir lógica extra aquí si fuera necesario.
      
      return null;
    } catch (e) {
      final error = e.toString().toLowerCase();
      if (error.contains('invalid login credentials')) {
        return 'errorInvalidCredentials';
      }
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

