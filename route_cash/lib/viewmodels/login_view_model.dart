import 'package:flutter/material.dart';
import '../services/auth_service.dart';

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
    final lowerEmail = email.trim().toLowerCase();
    if (lowerEmail.isEmpty || password.isEmpty) {
      return 'empty_fields';
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signIn(lowerEmail, password);
      
      final user = _authService.currentUser;
      final name = user?.userMetadata?['full_name'] ?? lowerEmail;
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

