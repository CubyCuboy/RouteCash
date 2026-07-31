import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _welcomeMessageKey = 'welcome_message';

  Future<AuthResponse> signUp(String email, String password, Map<String, dynamic> data) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
      return response;
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Ocurrió un error inesperado al registrarse';
    }
  }

  // Iniciar sesión
  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Ocurrió un error inesperado al iniciar sesión';
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> saveWelcomeMessage(String message) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_welcomeMessageKey, message);
  }

  Future<String?> getWelcomeMessage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_welcomeMessageKey);
  }

  User? get currentUser => _supabase.auth.currentUser;

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from('users')
          .select('*, states(state_id, name, country_id, countries(country_id, name, phone_code)), currencies(currency_id, code, name, symbol)')
          .eq('user_id', userId)
          .single();
      return data;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _supabase.from('users').update(data).eq('user_id', userId);
    } catch (e) {
      throw 'Error al actualizar perfil: $e';
    }
  }

  Future<Map<String, dynamic>?> getUserSettings(String userId) async {
    try {
      return await _supabase
          .from('user_settings')
          .select()
          .eq('user_id', userId)
          .single();
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserSettings(String userId, Map<String, dynamic> data) async {
    try {
      await _supabase.from('user_settings').update(data).eq('user_id', userId);
    } catch (e) {
      throw 'Error al actualizar ajustes: $e';
    }
  }

  static const String _userSettingsCacheKey = 'user_settings_cache';

  Future<void> cacheUserSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userSettingsCacheKey, json.encode(settings));
  }

  Future<Map<String, dynamic>?> getCachedUserSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_userSettingsCacheKey);
    if (encoded == null) return null;
    return json.decode(encoded) as Map<String, dynamic>;
  }

  Future<void> clearSettingsCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userSettingsCacheKey);
  }

  Future<void> completeEmailChange(String newEmail) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'No hay sesión activa';

      // Actualizar en Auth
      await _supabase.auth.updateUser(UserAttributes(email: newEmail));
      
      // Actualizar en la tabla users
      await _supabase.from('users').update({'email': newEmail}).eq('user_id', user.id);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Error al completar el cambio de email: $e';
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      throw 'Error al actualizar contraseña: $e';
    }
  }

  Future<void> linkProvider(OAuthProvider provider) async {
    try {
      await _supabase.auth.linkIdentity(provider);
    } catch (e) {
      throw 'Error al vincular cuenta: $e';
    }
  }

  Future<void> createUserProfile({
    required String userId,
    required String fullName,
    required String email,
    required String phone,
    required String stateId,
    required int currencyId,
  }) async {
    try {
      await _supabase.from('users').insert({
        'user_id': userId,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'state_id': stateId,
        'default_currency_id': currencyId,
      });

      await _supabase.from('user_settings').insert({
        'user_id': userId,
      });
    } catch (e) {
      throw 'Error al crear el perfil del usuario: $e';
    }
  }
}
