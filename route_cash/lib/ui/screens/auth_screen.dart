import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/route_cash_buttons.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final Widget? icon;
  final bool border;
  final Color borderColor;
  final double height;

  const SocialButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.icon,
    this.border = false,
    this.borderColor = Colors.white,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: border
                  ? Border.all(
                      color: borderColor,
                      width: 1,
                    )
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (icon != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: icon!,
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: icon != null ? 36 : 0,
                  ),
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

                  SocialButton(
                    text: 'Iniciar Sesión',
                    backgroundColor: Colors.white,
                    textColor: const Color(0xFF333333),
                    onPressed: () => _login(context),
                  ),

                  const SizedBox(height: 8),

                  SocialButton(
                    text: 'Inicia Sesión Con Outlook',
                    backgroundColor: const Color(0xFF1473E6),
                    textColor: Colors.white,
                    icon: const SocialIcon(
                      assetPath: 'assets/icons/microsoft-outlook-2025.png',
                    ),
                    onPressed: () {},
                  ),

                  const SizedBox(height: 8),

                  SocialButton(
                    text: 'Inicia Sesión con Google',
                    backgroundColor: Colors.white,
                    textColor: const Color(0xFF333333),
                    icon: const SocialIcon(
                      assetPath: 'assets/icons/google-logo.jpg',
                    ),
                    onPressed: () {},
                  ),

                  const SizedBox(height: 8),

                  SocialButton(
                    text: 'Inicia Sesión Con Apple',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    border: true,
                    icon: const SocialIcon(
                      assetPath: 'assets/icons/apple.jpg',
                      size: 23,
                    ),
                    onPressed: () {},
                  ),

                  SizedBox(
                    height: constraints.maxHeight * 0.12,
                  ),

                  SocialButton(
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
