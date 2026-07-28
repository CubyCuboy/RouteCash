import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AccountsSetupViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _welcomeMessage;

  String? get welcomeMessage => _welcomeMessage;

  Future<void> loadWelcomeMessage() async {
    _welcomeMessage = await _authService.getWelcomeMessage();
    notifyListeners();
  }

  String connectBank() {
    return 'Aquí se abrirá la conexión bancaria';
  }

  String addManually() {
    return 'Aquí se abrirá el registro manual de una cuenta';
  }
}

