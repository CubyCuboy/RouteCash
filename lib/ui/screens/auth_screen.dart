import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:routecash/services/google_auth_service.dart';
import 'main_navigation_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class SocialIcon extends StatelessWidget {
  final String assetPath;
  final double size;

  const SocialIcon({
    super.key,
    required this.assetPath,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: size,
          height: size,
          child: const Icon(
            Icons.broken_image_outlined,
            size: 18,
          ),
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
  bool _keepMeLoggedIn = true;

  void _login() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  void _createAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    if (_isGoogleLoading) {
      return;
    }

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final response = await GoogleAuthService.instance.signIn();

      if (!mounted) {
        return;
      }

      if (response.session == null) {
        throw const AuthException(
          'No fue posible crear la sesión con Google.',
        );
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
        ),
        (route) => false,
      );
    } on AuthException catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(error.message);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'No fue posible iniciar sesión con Google: $error',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.10,
                      ),
                      Text(
                        'RouteCash',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 45,
                          height: 1,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tu espacio financiero',
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 28),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'El dinero\ncon sentido.',
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 64,
                            height: 0.85,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.11,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Checkbox(
                                value: _keepMeLoggedIn,
                                onChanged: (value) {
                                  setState(() {
                                    _keepMeLoggedIn = value ?? true;
                                  });
                                },
                                side: const BorderSide(
                                    color: Colors.white, width: 1.5),
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
                                'Mantener sesión iniciada',
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
                        text: 'Iniciar Sesión',
                        backgroundColor: Colors.white,
                        textColor: const Color(0xFF333333),
                        onPressed: _login,
                      ),
                      const SizedBox(height: 8),
                      _AuthButton(
                        text: 'Iniciar sesión con Outlook',
                        backgroundColor: const Color(0xFF1473E6),
                        textColor: Colors.white,
                        icon: const SocialIcon(
                          assetPath:
                              'assets/icons/microsoft-outlook-2025.png',
                        ),
                        onPressed: () {
                          _showMessage(
                            'El inicio de sesión con Outlook aún no está configurado.',
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      _AuthButton(
                        text: 'Iniciar sesión con Google',
                        backgroundColor: Colors.white,
                        textColor: const Color(0xFF333333),
                        icon: const SocialIcon(
                          assetPath: 'assets/icons/google-logo.jpg',
                        ),
                        isLoading: _isGoogleLoading,
                        onPressed:
                            _isGoogleLoading ? null : _signInWithGoogle,
                      ),
                      const SizedBox(height: 8),
                      _AuthButton(
                        text: 'Iniciar sesión con Apple',
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        icon: const SocialIcon(
                          assetPath: 'assets/icons/apple.png',
                          size: 23,
                        ),
                        onPressed: () {
                          _showMessage(
                            'El inicio de sesión con Apple aún no está configurado.',
                          );
                        },
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.12,
                      ),
                      _AuthButton(
                        text: '¿Eres nuevo? Crear cuenta',
                        backgroundColor: Colors.white,
                        textColor: const Color(0xFF333333),
                        onPressed: _createAccount,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
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
          disabledBackgroundColor: backgroundColor.withOpacity(0.75),
          disabledForegroundColor: textColor.withOpacity(0.75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
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
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 12),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}