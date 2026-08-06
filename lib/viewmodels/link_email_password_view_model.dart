import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../utils/email_validator.dart';
import '../l10n/app_localizations.dart';

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

  void _log(String operation, {String? details, dynamic error}) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[LINK_EMAIL_VM] [$timestamp] $operation ${details != null ? "- $details" : ""}');
    if (error != null) {
      debugPrint('[LINK_EMAIL_VM] ERROR: $error');
    }
  }

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

  Future<String?> submit({required AppLocalizations l10n}) async {
    _log('SUBMIT_START', details: 'email: $email');
    _isLoading = true;
    notifyListeners();

    try {
      final user = _authService.currentUser;
      if (user == null) return l10n.errorNoSession;

      // Actualizamos email y password. 
      // Si el email es nuevo, Supabase enviará una confirmación.
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          email: EmailValidator.normalize(email),
          password: password,
        ),
      );

      _log('SUBMIT_SUCCESS');
      return null;
    } catch (e) {
      _log('SUBMIT_ERROR', error: e);
      return e is AuthException ? e.message : l10n.errorUnexpected;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
