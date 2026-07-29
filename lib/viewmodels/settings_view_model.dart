import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/catalog_service.dart';
import '../services/google_auth_service.dart';
import '../services/verification_service.dart';
import '../utils/email_validator.dart';

class SettingsViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final CatalogService _catalogService = CatalogService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? userProfile;
  Map<String, dynamic>? userSettings;

  List<Map<String, dynamic>> countries = [];
  List<Map<String, dynamic>> states = [];
  List<Map<String, dynamic>> currencies = [];

  SettingsViewModel() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    debugPrint('SettingsViewModel: Start loading data...');

    try {
      final user = _authService.currentUser;
      if (user != null) {
        debugPrint('SettingsViewModel: Loading profile for ${user.id}');
        userProfile = await _authService.getUserProfile(user.id);
        userSettings = await _authService.getUserSettings(user.id);
        
        debugPrint('SettingsViewModel: Loading catalogs...');
        countries = await _catalogService.getCountries();
        currencies = await _catalogService.getCurrencies();
        
        if (userProfile != null && userProfile!['states'] != null) {
          final dynamic statesData = userProfile!['states'];
          Map<String, dynamic>? stateMap;
          
          if (statesData is List && statesData.isNotEmpty) {
            stateMap = Map<String, dynamic>.from(statesData.first);
          } else if (statesData is Map) {
            stateMap = Map<String, dynamic>.from(statesData);
          }

          if (stateMap != null && stateMap['countries'] != null) {
            final dynamic countryData = stateMap['countries'];
            Map<String, dynamic>? countryMap;
            
            if (countryData is List && countryData.isNotEmpty) {
              countryMap = Map<String, dynamic>.from(countryData.first);
            } else if (countryData is Map) {
              countryMap = Map<String, dynamic>.from(countryData);
            }

            if (countryMap != null && countryMap['country_id'] != null) {
              final String countryId = countryMap['country_id'].toString();
              debugPrint('SettingsViewModel: Loading states for country $countryId');
              states = await _catalogService.getStates(countryId);
            }
          }
        }
        debugPrint('SettingsViewModel: Data loaded successfully');
      } else {
        debugPrint('SettingsViewModel: No current user found');
      }
    } catch (e, stack) {
      debugPrint('SettingsViewModel: Error loading data: $e');
      debugPrint('Stack trace: $stack');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStates(String countryId) async {
    states = await _catalogService.getStates(countryId);
    notifyListeners();
  }

  Future<String?> updateProfile({
    required String fullName,
    required String phone,
    required String stateId,
    required int currencyId,
  }) async {
    try {
      final user = _authService.currentUser;
      if (user == null) return 'No hay sesión activa';

      await _authService.updateUserProfile(user.id, {
        'full_name': fullName,
        'phone': phone,
        'state_id': stateId,
        'default_currency_id': currencyId,
      });

      await loadData();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> initiateEmailChange(String oldEmail, String newEmail, String lang) async {
    try {
      final user = _authService.currentUser;
      if (user == null) return 'No hay sesión activa';
      
      final cleanOld = EmailValidator.normalize(oldEmail);
      final cleanNew = EmailValidator.normalize(newEmail);

      if (user.email != cleanOld) {
        return 'El correo anterior no coincide con el registrado';
      }

      if (!EmailValidator.isValid(cleanNew)) {
        return 'El formato del nuevo correo es inválido';
      }

      final verificationService = VerificationService();
      final result = await verificationService.sendOtp(
        userId: user.id,
        email: cleanNew,
        purpose: 'change_email',
        lang: lang,
      );

      if (result['success'] == true) {
        return null; // Éxito al enviar el código
      } else {
        return result['error'] ?? 'Error al enviar el código de verificación';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> finalizeEmailChange(String newEmail) async {
    try {
      await _authService.completeEmailChange(EmailValidator.normalize(newEmail));
      await loadData();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updatePassword(String newPassword) async {
    try {
      await _authService.updatePassword(newPassword);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> linkAccount(OAuthProvider provider) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (provider == OAuthProvider.google) {
        await GoogleAuthService.instance.linkAccount();
      } else {
        await _authService.linkProvider(provider);
      }
      await loadData();
    } catch (e) {
      debugPrint('Error linking account: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> unlinkAccount(String provider) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (provider == 'google') {
        await GoogleAuthService.instance.unlinkAccount();
      } else {
        final user = _authService.currentUser;
        final identity = user?.identities?.firstWhere(
          (id) => id.provider == provider,
        );
        if (identity != null) {
          await Supabase.instance.client.auth.unlinkIdentity(identity);
        }
      }
      await loadData();
    } catch (e) {
      debugPrint('Error unlinking account: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSetting(String key, dynamic value) async {
    final user = _authService.currentUser;
    if (user == null) return;

    try {
      await _authService.updateUserSettings(user.id, {key: value});
      if (userSettings != null) {
        userSettings![key] = value;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating setting: $e');
    }
  }

  bool get isEmailVerified => _authService.currentUser?.emailConfirmedAt != null;
  bool get isPhoneVerified => userProfile?['phone_verified'] ?? false;
  
  List<UserIdentity> get linkedIdentities => _authService.currentUser?.identities ?? [];
  
  bool isProviderLinked(String provider) {
    return linkedIdentities.any((id) => id.provider == provider);
  }
}
