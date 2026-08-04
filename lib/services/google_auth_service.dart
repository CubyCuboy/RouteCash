import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

class GoogleAuthService {
  GoogleAuthService._();

  static final GoogleAuthService instance = GoogleAuthService._();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _initialized = false;

  static final String _webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';

  Future<void> _initialize() async {
    if (_initialized) return;
    await _googleSignIn.initialize(serverClientId: _webClientId);
    _initialized = true;
  }

  Future<AuthResponse> signIn() async {
    await _initialize();
    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

    const scopes = <String>['email', 'profile'];

    final authorization =
        await googleUser.authorizationClient.authorizationForScopes(scopes) ??
            await googleUser.authorizationClient.authorizeScopes(scopes);

    final idToken = googleUser.authentication.idToken;

    if (idToken == null) {
      throw const AuthException('Google no entregó un ID Token.');
    }

    final response = await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );

    if (response.user != null) {
      await AuthService().updateLastLogin(response.user!.id);
    }

    return response;
  }

  Future<void> linkAccount() async {
    await _initialize();
    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

    const scopes = <String>['email', 'profile'];
    final authorization = await googleUser.authorizationClient.authorizationForScopes(scopes) ??
        await googleUser.authorizationClient.authorizeScopes(scopes);
    final idToken = googleUser.authentication.idToken;

    if (idToken == null) {
      throw const AuthException('Google no entregó un ID Token.');
    }

    try {
      await Supabase.instance.client.auth.linkIdentityWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization.accessToken,
      );
    } on AuthException catch (e) {
      if (e.message.contains('identity already exists')) {
        throw const AuthException('Esta cuenta de Google ya está vinculada a otro usuario.');
      }
      rethrow;
    }
  }

  bool isGoogleLinked() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return false;
    return user.identities?.any((identity) => identity.provider == 'google') ?? false;
  }

  Future<void> unlinkAccount() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final googleIdentity = user.identities?.where(
          (identity) => identity.provider == 'google',
    ).firstOrNull;

    if (googleIdentity != null) {
      await Supabase.instance.client.auth.unlinkIdentity(googleIdentity);
    }
    await signOutGoogle();
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    await _googleSignIn.signOut();
  }
}
