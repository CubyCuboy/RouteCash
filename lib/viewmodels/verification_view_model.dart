import 'dart:async';
import 'package:flutter/material.dart';
import '../services/verification_service.dart';

class VerificationViewModel extends ChangeNotifier {
  final VerificationService _service = VerificationService();
  
  Timer? _timer;
  int _secondsRemaining = 1800; // 30 minutos
  int _attemptsRemaining = 5;
  bool _isLoading = false;
  bool _isExpired = false;
  
  int get secondsRemaining => _secondsRemaining;
  int get attemptsRemaining => _attemptsRemaining;
  bool get isLoading => _isLoading;
  bool get isExpired => _isExpired;
  bool get canVerify => !isExpired && _attemptsRemaining > 0 && !isLoading;

  String get timerText {
    final minutes = (_secondsRemaining / 60).floor();
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    _timer?.cancel();
    _isExpired = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        _isExpired = true;
        _timer?.cancel();
        notifyListeners();
      }
    });
  }

  void setTimerDuration(String purpose) {
    // Tiempos según propósito
    if (purpose == 'reset_password' || purpose == 'recovery') {
      _secondsRemaining = 5 * 60;
    } else if (purpose == 'change_email') {
      _secondsRemaining = 10 * 60; // 10 minutos para cambio de email
    } else {
      _secondsRemaining = 30 * 60;
    }
    notifyListeners();
  }

  Future<void> fetchOtpStatus(String userId, String purpose) async {
    final status = await _service.getLatestOtpStatus(userId, purpose);
    if (status != null) {
      final int attempts = status['attempts'] ?? 0;
      _attemptsRemaining = 5 - attempts;
      
      final DateTime expiresAt = DateTime.parse(status['expires_at']);
      final now = DateTime.now().toUtc();
      final difference = expiresAt.difference(now).inSeconds;
      
      if (difference > 0) {
        _secondsRemaining = difference;
        _isExpired = false;
      } else {
        _secondsRemaining = 0;
        _isExpired = true;
      }
      notifyListeners();
    }
  }

  Future<String?> sendCode(String userId, String email, String purpose, String lang) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final result = await _service.sendOtp(
        userId: userId,
        email: email,
        purpose: purpose,
        lang: lang,
      );
      
      _isLoading = false;
      if (result['success'] == true) {
        final int minutes = result['expires_in_minutes'] ?? 30;
        _secondsRemaining = minutes * 60;
        startTimer();
        _attemptsRemaining = 5;
        notifyListeners();
        return null;
      } else {
        notifyListeners();
        return result['error'] ?? 'Error al enviar el código. Verifica tu conexión.';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Error inesperado: $e';
    }
  }

  Future<String?> verifyCode(String userId, String code, String purpose, String lang, {String? email}) async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _service.verifyOtp(
      userId: userId,
      code: code,
      purpose: purpose,
      lang: lang,
      email: email,
    );
    
    _isLoading = false;
    if (result['success'] == true) {
      _timer?.cancel();
      notifyListeners();
      return null;
    } else {
      // Re-fetch status to update attempts
      await fetchOtpStatus(userId, purpose);
      notifyListeners();
      return result['error'] ?? 'Código inválido';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
