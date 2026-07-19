import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  void _login(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  void _createAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
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
              return Column(
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

                  Text(
                    'El dinero\ncon sentido.',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 64,
                      height: 0.85,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                    ),
                  ),

                  SizedBox(
                    height: constraints.maxHeight * 0.11,
                  ),

                  _AuthButton(
                    text: 'Iniciar Sesión',
                    backgroundColor: Colors.white,
                    textColor: const Color(0xFF333333),
                    onPressed: () => _login(context),
                  ),

                  const SizedBox(height: 8),

                  _AuthButton(
                    text: 'Inicia Sesión Con Outlook',
                    backgroundColor: const Color(0xFF1473E6),
                    textColor: Colors.white,
                    icon: const SocialIcon(
                      assetPath:
                          'assets/icons/microsoft-outlook-2025.png',
                    ),
                    onPressed: () {},
                  ),

                  const SizedBox(height: 8),

                  _AuthButton(
                    text: 'Inicia Sesión con Google',
                    backgroundColor: Colors.white,
                    textColor: const Color(0xFF333333),
                    icon: const SocialIcon(
                      assetPath: 'assets/icons/google.png',
                    ),
                    onPressed: () {},
                  ),

                  const SizedBox(height: 8),

                  _AuthButton(
                    text: 'Inicia Sesión Con Apple',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    icon: const SocialIcon(
                      assetPath: 'assets/icons/apple.png',
                      size: 23,
                    ),
                    onPressed: () {},
                  ),

                  SizedBox(
                    height: constraints.maxHeight * 0.12,
                  ),

                  _AuthButton(
                    text: '¿Eres nuevo? Crear Cuenta',
                    backgroundColor: Colors.white,
                    textColor: const Color(0xFF333333),
                    onPressed: () => _createAccount(context),
                  ),
                ],
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
  final VoidCallback onPressed;

  const _AuthButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.icon,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 12),
            ],
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}