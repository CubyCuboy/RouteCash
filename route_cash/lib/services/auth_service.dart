import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _welcomeMessageKey = 'welcome_message';

  // Registrar un nuevo usuario
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
      // Re-lanzar el mensaje para que el ViewModel lo procese
      throw e.message;
    } catch (e) {
      throw 'Ocurrió un error inesperado al iniciar sesión';
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Guardar mensaje de bienvenida en caché
  Future<void> saveWelcomeMessage(String message) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_welcomeMessageKey, message);
  }

  // Obtener mensaje de bienvenida de la caché
  Future<String?> getWelcomeMessage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_welcomeMessageKey);
  }

  // Obtener el usuario actual
  User? get currentUser => _supabase.auth.currentUser;
}
