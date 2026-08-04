import 'package:supabase_flutter/supabase_flutter.dart';

class MicrosoftAuthService {
  MicrosoftAuthService._();

  static final MicrosoftAuthService instance =
      MicrosoftAuthService._();

  final SupabaseClient _supabase =
      Supabase.instance.client;

  static const String _redirectUrl =
      'io.supabase.routecash://login-callback';

  Future<void> signIn() async {
    try {


      final launched =
          await _supabase.auth.signInWithOAuth(
        OAuthProvider.azure,
        redirectTo: _redirectUrl,
        scopes: 'openid profile email',
        authScreenLaunchMode:
            LaunchMode.externalApplication,
        queryParams: const {
          'prompt': 'login',
        },
      );

      if (!launched) {
        throw const AuthException(
          'No se pudo abrir el inicio de sesión con Outlook.',
        );
      }
    } on AuthException {
      rethrow;
    } catch (error) {
      throw AuthException(
        'Error autenticando con Outlook: $error',
      );
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut(
      scope: SignOutScope.local,
    );
  }
}