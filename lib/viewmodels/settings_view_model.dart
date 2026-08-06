import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/catalog_service.dart';
import '../services/google_auth_service.dart';
import '../services/verification_service.dart';
import '../utils/email_validator.dart';
import '../l10n/app_localizations.dart';

class SettingsViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final CatalogService _catalogService = CatalogService();
  final VerificationService _verificationService = VerificationService();

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

  void _log(String operation, {String? details, dynamic error}) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[SETTINGS_VM] [$timestamp] $operation ${details != null ? "- $details" : ""}');
    if (error != null) {
      debugPrint('[SETTINGS_VM] ERROR: $error');
    }
  }

  Future<void> _init() async {
    _log('INITIALIZING');
    await _loadFromCache();
    await loadData();
  }

  Future<void> _loadFromCache() async {
    _log('CACHE_LOAD_START');
    userProfile = await _authService.getCachedUserProfile();
    userSettings = await _authService.getCachedUserSettings();
    notifyListeners();
  }

  Future<void> loadData({bool forceRefresh = false}) async {
    _log('LOAD_DATA_START', details: 'forceRefresh: $forceRefresh');
    
    // Always show loading on first load if profile is missing
    if (forceRefresh || userProfile == null) {
      _isLoading = true;
      notifyListeners();
    }
    
    try {
      final user = _authService.currentUser;
      if (user == null) {
        _log('LOAD_DATA_NO_USER');
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Priority: Supabase is the source of truth
      final profile = await _authService.getUserProfile(user.id);
      final settings = await _authService.getUserSettings(user.id);
      
      countries = await _catalogService.getCountries();
      currencies = await _catalogService.getCurrencies();

      if (profile != null) {
        userProfile = profile;
        await _authService.cacheUserProfile(profile);
        _log('LOAD_DATA_PROFILE_FETCHED', details: 'name: ${profile['full_name']}');
        
        // Dynamic state loading based on profile's current state/country
        if (userProfile!['states'] != null) {
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
      } else {
        _log('LOAD_DATA_PROFILE_NULL');
      }

      if (settings != null) {
        userSettings = settings;
        await _authService.cacheUserSettings(settings);
      }
      
      _log('LOAD_DATA_SUCCESS');
    } catch (e) {
      _log('LOAD_DATA_ERROR', error: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String get userId => userProfile?['user_id'] ?? _authService.currentUser?.id ?? '';

  String get currentEmail => primaryEmailInfo['email'] ?? '';
  String get currentProviderLabel => primaryEmailInfo['label'] ?? '';

  /// Returns information about the oldest linked identity (email and provider)
  Map<String, String> get primaryEmailInfo {
    final user = _authService.currentUser;
    if (user == null) return {'email': '', 'provider': '', 'label': ''};

    final identities = user.identities ?? [];
    if (identities.isEmpty) {
      return {
        'email': user.email ?? '',
        'provider': 'email',
        'label': 'Email',
      };
    }

    final sorted = List<UserIdentity>.from(identities);
    sorted.sort((a, b) {
      final dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime.now();
      final dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime.now();
      return dateA.compareTo(dateB);
    });

    final oldest = sorted.first;
    String providerLabel = oldest.provider;
    if (providerLabel == 'azure') providerLabel = 'Microsoft';
    if (providerLabel == 'google') providerLabel = 'Google';
    if (providerLabel == 'email') providerLabel = 'Email';

    return {
      'email': oldest.identityData?['email']?.toString() ?? user.email ?? '',
      'provider': oldest.provider,
      'label': providerLabel,
    };
  }

  Future<void> loadStates(String countryId) async {
    _log('LOAD_STATES', details: 'countryId: $countryId');
    states = await _catalogService.getStates(countryId);
    notifyListeners();
  }

  Future<String?> updateProfile({
    required AppLocalizations l10n,
    required String fullName,
    String? nickname,
    required String phone,
    required String stateId,
    required int currencyId,
    String? profileImageUrl,
  }) async {
    _log('UPDATE_PROFILE_START');
    try {
      final user = _authService.currentUser;
      if (user == null) return l10n.errorNoSession;

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
      await loadData(forceRefresh: true);
      
      _log('UPDATE_PROFILE_SUCCESS');
      return null;
    } catch (e) {
      _log('UPDATE_PROFILE_ERROR', error: e);
      return l10n.errorProfileUpdate;
    }
  }

  Future<String?> initiateEmailChange({
    required AppLocalizations l10n,
    required String oldEmail,
    required String newEmail,
    required String lang,
  }) async {
    _log('INITIATE_EMAIL_CHANGE', details: 'from: $oldEmail to: $newEmail');
    try {
      final user = _authService.currentUser;
      if (user == null) return l10n.errorNoSession;
      
      final cleanOld = EmailValidator.normalize(oldEmail);
      final cleanNew = EmailValidator.normalize(newEmail);

      // Verify that the old email matches what Supabase has
      if (user.email == null || EmailValidator.normalize(user.email!) != cleanOld) {
        return l10n.errorOldEmailMismatch;
      }

      if (!EmailValidator.isValid(cleanNew)) {
        return l10n.errorInvalidNewEmail;
      }

      final result = await _verificationService.sendOtp(
        userId: user.id,
        email: cleanNew,
        purpose: 'change_email',
        lang: lang,
      );

      if (result['success'] == true) {
        _log('INITIATE_EMAIL_CHANGE_OTP_SENT');
        return null;
      } else {
        _log('INITIATE_EMAIL_CHANGE_OTP_ERROR', details: result['error']);
        return result['error'] ?? l10n.errorUnexpected;
      }
    } catch (e) {
      _log('INITIATE_EMAIL_CHANGE_ERROR', error: e);
      return e.toString();
    }
  }

  Future<String?> finalizeEmailChange({
    required AppLocalizations l10n,
    required String newEmail,
  }) async {
    _log('FINALIZE_EMAIL_CHANGE', details: 'newEmail: $newEmail');
    try {
      await _authService.completeEmailChange(EmailValidator.normalize(newEmail));
      await loadData(forceRefresh: true);
      _log('FINALIZE_EMAIL_CHANGE_SUCCESS');
      return null;
    } catch (e) {
      _log('FINALIZE_EMAIL_CHANGE_ERROR', error: e);
      return l10n.errorEmailUpdate;
    }
  }

  Future<String?> updatePassword({
    required AppLocalizations l10n,
    required String newPassword,
  }) async {
    _log('UPDATE_PASSWORD_START');
    try {
      await _authService.updatePassword(newPassword);
      _log('UPDATE_PASSWORD_SUCCESS');
      return null;
    } catch (e) {
      _log('UPDATE_PASSWORD_ERROR', error: e);
      return l10n.errorPasswordUpdate;
    }
  }

  Future<void> linkAccount(OAuthProvider provider) async {
    final providerStr = provider == OAuthProvider.google ? 'google' : 'azure';
    _log('LINK_ACCOUNT_START', details: 'provider: $providerStr');
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final user = _authService.currentUser;
      if (user == null) throw Exception('No session');

      // 1. Link provider
      if (provider == OAuthProvider.google) {
        await GoogleAuthService.instance.linkAccount();
      } else {
        await _authService.linkProvider(
          provider,
          queryParams: {'prompt': 'login'},
        );
      }
      
      // 2. Refresh session to get new identities
      await Supabase.instance.client.auth.refreshSession();
      final freshUser = _authService.currentUser;

      if (freshUser != null) {
        // 3. Strict cleanup: ensure only the new identity for this provider exists
        final providerIdentities = freshUser.identities?.where((id) => id.provider == providerStr).toList() ?? [];
        
        if (providerIdentities.length > 1) {
          _log('LINK_ACCOUNT_CLEANUP', details: 'found ${providerIdentities.length} identities');
          // Sort by createdAt descending (newest first)
          providerIdentities.sort((a, b) {
            final dA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
            final dB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
            return dB.compareTo(dA);
          });

          // Keep the first (newest), unlink others
          for (var i = 1; i < providerIdentities.length; i++) {
            await Supabase.instance.client.auth.unlinkIdentity(providerIdentities[i]);
            _log('LINK_ACCOUNT_UNLINKED_OLD', details: 'id: ${providerIdentities[i].id}');
          }
        }

        // 4. Update DB email from the primary identity
        final info = primaryEmailInfo;
        final newEmail = info['email'] ?? '';
        if (newEmail.isNotEmpty) {
          await _authService.updateUserProfile(freshUser.id, {'email': newEmail});
          _log('LINK_ACCOUNT_DB_UPDATED', details: 'email: $newEmail');
        }
      }
      
      await loadData(forceRefresh: true);
      _log('LINK_ACCOUNT_SUCCESS');
    } catch (e) {
      _log('LINK_ACCOUNT_ERROR', error: e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> unlinkAccount(String provider, {required AppLocalizations l10n}) async {
    _log('UNLINK_ACCOUNT_START', details: 'provider: $provider');
    
    final user = _authService.currentUser;
    if (user == null) return;
    
    final identities = user.identities ?? [];
    final hasPassword = hasEmailPasswordAuth;
    
    // Safety check: must have at least one method remaining
    if (identities.length <= 1 && !hasPassword) {
      throw Exception(l10n.errorUnlinkOnlyMethod);
    }

    _isLoading = true;
    notifyListeners();
    try {
      final toRemove = identities.where((id) => id.provider == provider).toList();
      
      for (var identity in toRemove) {
        await Supabase.instance.client.auth.unlinkIdentity(identity);
        _log('UNLINK_ACCOUNT_REMOVED', details: 'provider: $provider, identityId: ${identity.id}');
      }

      if (provider == 'google') {
        await GoogleAuthService.instance.signOutGoogle();
      }
      
      await Supabase.instance.client.auth.refreshSession();
      await loadData(forceRefresh: true);
      _log('UNLINK_ACCOUNT_SUCCESS');
    } catch (e) {
      _log('UNLINK_ACCOUNT_ERROR', error: e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAccount({required AppLocalizations l10n}) async {
    _log('DELETE_ACCOUNT_START');
    final user = _authService.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await Supabase.instance.client.rpc('delete_user_data'); 
      await _authService.signOut();
      _log('DELETE_ACCOUNT_SUCCESS');
    } catch (e) {
      _log('DELETE_ACCOUNT_ERROR', error: e);
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
      _log('SYNC_SETTINGS_SUCCESS');
    } catch (e) {
      _log('SYNC_SETTINGS_ERROR', error: e);
    }
  }

  Future<void> syncAndSignOut() async {
    _log('SYNC_AND_SIGN_OUT');
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

    final identities = linkedIdentities;
    return identities.any((e) => e.provider == 'email') || 
           (user.email != null && user.emailConfirmedAt != null);
  }

  Future<String?> addEmailPasswordAuth({
    required AppLocalizations l10n,
    required String email, 
    required String password,
  }) async {
    _log('ADD_EMAIL_PASSWORD_AUTH_START', details: 'email: $email');
    try {
      final user = _authService.currentUser;
      if (user == null) return l10n.errorNoSession;

      await Supabase.instance.client.auth.updateUser(
        UserAttributes(email: email, password: password),
      );

      await loadData(forceRefresh: true);
      _log('ADD_EMAIL_PASSWORD_AUTH_SUCCESS');
      return null;
    } catch (e) {
      _log('ADD_EMAIL_PASSWORD_AUTH_ERROR', error: e);
      return e.toString();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
