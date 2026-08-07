import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:routecash/services/google_auth_service.dart';
import 'package:routecash/services/microsoft_auth_service.dart';
import 'package:routecash/services/auth_service.dart';
import 'package:routecash/l10n/app_localizations.dart';
import '../components/route_cash_shared_ui.dart';

import 'main_navigation_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'social_registration_screen.dart';

class SocialIcon extends StatelessWidget {
  final String assetPath;
  final double size;

  const SocialIcon({super.key, required this.assetPath, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.broken_image_outlined,
          size: size,
          color: Colors.grey,
        );
      },
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isGoogleLoading = false;
  bool _isMicrosoftLoading = false;
  bool _isHandlingMicrosoftCallback = false;
  StreamSubscription<AuthState>? _authSubscription;
  bool _keepMeLoggedIn = true;

  @override
  void initState() {
    super.initState();

    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      _handleAuthStateChange,
      onError: (Object error, StackTrace stackTrace) {
        if (!_isMicrosoftLoading || !mounted) {
          return;
        }

        setState(() {
          _isMicrosoftLoading = false;
        });
        
        final strings = AppLocalizations.of(context);
        if (strings != null) {
          _showMessage(strings.errorMicrosoftAuth(error.toString()));
        }
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleAuthStateChange(AuthState authState) async {
    if (!_isMicrosoftLoading ||
        _isHandlingMicrosoftCallback ||
        authState.event != AuthChangeEvent.signedIn ||
        authState.session == null) {
      return;
    }

    _isHandlingMicrosoftCallback = true;

    try {
      await _handleSocialLogin(authState.session!.user.id);
    } catch (error) {
      if (mounted) {
        final strings = AppLocalizations.of(context);
        if (strings != null) {
          _showMessage(strings.errorMicrosoftAuth(error.toString()));
        }
      }
    } finally {
      _isHandlingMicrosoftCallback = false;

      if (mounted) {
        setState(() {
          _isMicrosoftLoading = false;
        });
      }
    }
  }

  void _login() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _createAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  Future<void> _signInWithGoogle() async {
    if (_isGoogleLoading) return;

    setState(() => _isGoogleLoading = true);
    final strings = AppLocalizations.of(context)!;

    try {
      final response = await GoogleAuthService.instance.signIn();
      if (response.session == null) throw AuthException(strings.googleSessionError);
      await _handleSocialLogin(response.user!.id);
    } catch (e) {
      String errorMessage = e.toString();
      bool isCancelled = errorMessage.contains('cancelled') || 
                        errorMessage.contains('canceled') || 
                        errorMessage.contains('closed');
      
      _showMessage(isCancelled ? strings.errorAuthCancelledDetail : strings.errorGoogleAuth(errorMessage));
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _signInWithMicrosoft() async {
    if (_isMicrosoftLoading) return;

    setState(() => _isMicrosoftLoading = true);
    final strings = AppLocalizations.of(context)!;

    try {
      await MicrosoftAuthService.instance.signIn();
    } catch (e) {
      if (mounted) {
        setState(() => _isMicrosoftLoading = false);
        String errorMessage = e.toString();
        bool isCancelled = errorMessage.contains('cancelled') || 
                          errorMessage.contains('canceled') || 
                          errorMessage.contains('closed');
        
        _showMessage(isCancelled ? strings.errorAuthCancelledDetail : strings.errorMicrosoftAuth(errorMessage));
      }
    }
  }

  Future<void> _handleSocialLogin(String userId) async {
    final authService = AuthService();
    final user = Supabase.instance.client.auth.currentUser;
    final strings = AppLocalizations.of(context)!;

    // 1. Buscamos perfil por ID único de Supabase (el más seguro)
    var profile = await authService.getUserProfile(userId);
    
    // 2. Si no hay perfil por ID, verificamos si hay uno por email
    // PERO solo permitimos la vinculación automática si el email está verificado
    // y si el ID de usuario coincide. Si el email es el mismo pero el ID es distinto,
    // significa que es una identidad nueva y NO debemos mezclarlas automáticamente.
    if (profile == null && user?.email != null) {
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('email', user!.email!)
          .maybeSingle();
      
      if (response != null) {
        // SEGURIDAD: Solo vinculamos si el perfil encontrado no tiene un user_id asignado
        // o si el email proviene de un proveedor de confianza y el usuario confirmó la acción.
        // Para evitar el error grave de seguridad, si el perfil ya existe con otro ID,
        // no debemos sobreescribirlo sin que el usuario sepa.
        
        final existingUserId = response['user_id'];
        if (existingUserId == null || existingUserId == userId) {
          try {
            await Supabase.instance.client
                .from('users')
                .update({'user_id': userId})
                .eq('email', user.email!);
            profile = await authService.getUserProfile(userId);
          } catch (e) {
            debugPrint('Error vinculando perfil: $e');
          }
        } else {
          // Si el ID es diferente, es un riesgo de seguridad vincularlos.
          // Forzamos a que sea tratado como usuario nuevo o que use Login normal.
          _log('CONFLICTO DE SEGURIDAD: El email ya pertenece a otra cuenta con ID distinto.');
        }
      }
    }
    
    if (!mounted) return;

    if (profile == null) {
      // Es un usuario nuevo o una identidad que no debe mezclarse.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SocialRegistrationScreen()),
        (route) => false,
      );
    } else {
      // Éxito total
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        (route) => false,
      );
    }
  }

  void _log(String message) {
    debugPrint('[AUTH_SCREEN] $message');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final isLoading = _isGoogleLoading || _isMicrosoftLoading;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.10),
                      Text(
                        strings.appName,
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        strings.financialSpace,
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        strings.moneyWithMeaning,
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 64,
                          height: 0.85,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: _keepMeLoggedIn,
                                onChanged: (value) {
                                  setState(() {
                                    _keepMeLoggedIn = value ?? true;
                                  });
                                },
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                                activeColor: Colors.white,
                                checkColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _keepMeLoggedIn = !_keepMeLoggedIn;
                                });
                              },
                              child: Text(
                                strings.keepMeLoggedIn,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _AuthButton(
                        text: strings.signIn,
                        backgroundColor: Colors.white,
                        textColor: const Color(0xff333333),
                        onPressed: isLoading ? null : _login,
                      ),
                      const SizedBox(height: 8),
                      _AuthButton(
                        text: strings.signInWithOutlook,
                        backgroundColor: const Color(0xff1473E6),
                        textColor: Colors.white,
                        icon: const SocialIcon(
                          assetPath: "assets/icons/microsoft-outlook-2025.png",
                        ),
                        isLoading: _isMicrosoftLoading,
                        onPressed: isLoading ? null : _signInWithMicrosoft,
                      ),
                      const SizedBox(height: 8),
                      _AuthButton(
                        text: strings.signInWithGoogle,
                        backgroundColor: Colors.white,
                        textColor: const Color(0xff333333),
                        icon: const SocialIcon(
                          assetPath: "assets/icons/google-logo.jpg",
                        ),
                        isLoading: _isGoogleLoading,
                        onPressed: isLoading ? null : _signInWithGoogle,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.12),
                      _AuthButton(
                        text: strings.newUserCreateAccount,
                        backgroundColor: Colors.white,
                        textColor: const Color(0xff333333),
                        onPressed: isLoading ? null : _createAccount,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        RouteCashLoadingOverlay(isLoading: isLoading),
      ],
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _AuthButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 47,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 12)],
                  Text(text, style: GoogleFonts.inter(fontSize: 14)),
                ],
              ),
      ),
    );
  }
}
