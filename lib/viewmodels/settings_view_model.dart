import 'dart:async';
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

  Timer? _debounceTimer;
  final Map<String, dynamic> _pendingSettings = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? userProfile;
  Map<String, dynamic>? userSettings;

  List<Map<String, dynamic>> countries = [];
  List<Map<String, dynamic>> states = [];
  List<Map<String, dynamic>> currencies = [];

  SettingsViewModel() {
    _init();
  }

  Future<void> _init() async {
    // 1. Cargar caché inmediatamente para que no haya parpadeo en blanco
    await _loadFromCache();
    // 2. Cargar de red para actualizar
    loadData();
  }

  Future<void> _loadFromCache() async {
    userProfile = await _authService.getCachedUserProfile();
    userSettings = await _authService.getCachedUserSettings();
    notifyListeners();
  }

  Future<void> loadData({bool forceRefresh = false}) async {
    if (forceRefresh) {
      _isLoading = true;
      notifyListeners();
    }
    debugPrint('SettingsViewModel: Start loading data...');

    try {
      final response = await Supabase.instance.client.auth.getUser();
      final user = response.user;

      if (user != null) {
        debugPrint('SettingsViewModel: Loading profile for ${user.id}');
        final profile = await _authService.getUserProfile(user.id);
        if (profile != null) {
          userProfile = profile;
          await _authService.cacheUserProfile(profile);
        }
        
        final settings = await _authService.getUserSettings(user.id);
        if (settings != null) {
          userSettings = settings;
          await _authService.cacheUserSettings(settings);
        }
        
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
              states = await _catalogService.getStates(countryId);
            }
          }
        }
        debugPrint('SettingsViewModel: Data loaded successfully');
      }
    } catch (e) {
      debugPrint('SettingsViewModel: Error loading data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String get userId => userProfile?['user_id'] ?? _authService.currentUser?.id ?? '';
  
  String get currentEmail {
    final identities = linkedIdentities;
    
    // 1. Prioridad Google
    for (var identity in identities) {
      if (identity.provider == 'google') {
        return identity.identityData?['email']?.toString() ?? '';
      }
    }
    
    // 2. Prioridad Microsoft
    for (var identity in identities) {
      if (identity.provider == 'azure') {
        return identity.identityData?['email']?.toString() ?? '';
      }
    }
    
    // 3. Correo de Auth o Perfil
    return _authService.currentUser?.email ?? userProfile?['email']?.toString() ?? '';
  }

  Future<void> loadStates(String countryId) async {
    states = await _catalogService.getStates(countryId);
    notifyListeners();
  }

  Future<String?> updateProfile({
    required String fullName,
    String? nickname,
    required String phone,
    required String stateId,
    required int currencyId,
    String? profileImageUrl,
  }) async {
    try {
      final user = _authService.currentUser;
      if (user == null) return 'No hay sesión activa';

      final Map<String, dynamic> data = {
        'full_name': fullName,
        'nickname': nickname,
        'phone': phone,
        'state_id': stateId,
        'default_currency_id': currencyId,
      };

      if (profileImageUrl != null) {
        data['profile_image_url'] = profileImageUrl;
      }

      await _authService.updateUserProfile(user.id, data);

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

      if (user.email == null || EmailValidator.normalize(user.email!) != cleanOld) {
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
        return null;
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
      await loadData(forceRefresh: true);
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
      final providerStr = provider == OAuthProvider.google ? 'google' : 'azure';
      
      // Si ya hay identidades de este proveedor, las limpiamos primero para evitar duplicados
      final existingIdentities = linkedIdentities.where((id) => id.provider == providerStr).toList();
      for (var id in existingIdentities) {
        await Supabase.instance.client.auth.unlinkIdentity(id);
      }

      if (provider == OAuthProvider.google) {
        await GoogleAuthService.instance.linkAccount();
      } else {
        await _authService.linkProvider(
          provider,
          queryParams: provider == OAuthProvider.azure ? {'prompt': 'login'} : null,
        );
      }
      
      await Supabase.instance.client.auth.refreshSession();
      
      // Sincronizar el nuevo correo social con la tabla de usuarios
      final newEmail = currentEmail;
      if (newEmail.isNotEmpty) {
        await _authService.updateUserProfile(userId, {'email': newEmail});
      }
      
      await loadData(forceRefresh: true);
    } catch (e) {
      debugPrint('Error linking account: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> unlinkAccount(String provider) async {
    // 1. Obtener datos frescos del usuario e identidades antes de empezar
    final response = await Supabase.instance.client.auth.getUser();
    final user = response.user;
    if (user == null) return;
    
    final identities = user.identities ?? [];
    final hasPassword = hasEmailPasswordAuth;
    
    // Seguridad: Evitar que el usuario se quede sin acceso
    if (identities.length <= 1 && !hasPassword) {
      throw Exception('No puedes desvincular tu única forma de acceso. Configura una contraseña primero en la sección de Seguridad.');
    }

    _isLoading = true;
    notifyListeners();
    try {
      // 2. Identificar todas las identidades de este proveedor
      final toRemove = identities.where((id) => id.provider == provider).toList();
      
      // 3. Desvincular cada una de forma explícita en Supabase
      for (var identity in toRemove) {
        await Supabase.instance.client.auth.unlinkIdentity(identity);
      }

      // 4. Si es Google, cerrar sesión SOLO en el SDK de Google (no en Supabase)
      if (provider == 'google') {
        await GoogleAuthService.instance.signOutGoogle();
      }
      
      // 5. Refrescar la sesión para que Supabase reconozca que las identidades ya no existen
      await Supabase.instance.client.auth.refreshSession();
      
      // 6. Recargar perfil y catálogo
      await loadData(forceRefresh: true);
    } catch (e) {
      debugPrint('Error desvinculando cuenta: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSetting(String key, dynamic value) async {
    final user = _authService.currentUser;
    if (user == null) return;

    if (userSettings != null) {
      userSettings![key] = value;
    }
    _pendingSettings[key] = value;
    notifyListeners();
    
    if (userSettings != null) {
      await _authService.cacheUserSettings(userSettings!);
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(minutes: 5), () {
      syncSettings();
    });
  }

  Future<void> syncSettings() async {
    final user = _authService.currentUser;
    if (user == null || _pendingSettings.isEmpty) return;

    try {
      await _authService.updateUserSettings(user.id, Map.from(_pendingSettings));
      _pendingSettings.clear();
      debugPrint('Settings synced to DB');
    } catch (e) {
      debugPrint('Error syncing settings: $e');
    }
  }

  Future<void> syncAndSignOut() async {
    await syncSettings();
    await _authService.clearSettingsCache(excludeCardImages: true);
    await _authService.signOut();
  }

  bool get isEmailVerified => _authService.currentUser?.emailConfirmedAt != null;
  bool get isPhoneVerified => userProfile?['phone_verified'] ?? false;
  
  List<UserIdentity> get linkedIdentities => _authService.currentUser?.identities ?? [];
  
  bool isProviderLinked(String provider) {
    return linkedIdentities.any((id) => id.provider == provider);
  }

  UserIdentity? getProviderIdentity(String provider) {
    try {
      return linkedIdentities.firstWhere((id) => id.provider == provider);
    } catch (_) {
      return null;
    }
  }

  bool get hasEmailPasswordAuth {
    final user = _authService.currentUser;
    if (user == null) return false;

    final providers = linkedIdentities.map((e) => e.provider).toList();
    debugPrint('SettingsViewModel: User providers: $providers');
    return providers.contains('email') || (user.email != null && user.emailConfirmedAt != null);
  }

  Future<String?> addEmailPasswordAuth(String email, String password) async {
    try {
      final user = _authService.currentUser;
      if (user == null) return 'No hay sesión activa';

      await Supabase.instance.client.auth.updateUser(
        UserAttributes(email: email, password: password),
      );

      await loadData();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
