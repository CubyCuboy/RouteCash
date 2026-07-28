import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../l10n/app_localizations.dart';
import '../components/route_cash_buttons.dart';
import 'login_screen.dart';
import 'register_screen.dart';

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
    final strings = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Text(
                strings.appName,
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
                strings.financialSpace,
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
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
                  letterSpacing: -2,
                ),
              ),
              const Spacer(flex: 2),
              SocialButton(
                text: strings.signIn,
                backgroundColor: Colors.white,
                textColor: const Color(0xFF333333),
                onPressed: () => _login(context),
              ),
              const SizedBox(height: 8),
              SocialButton(
                text: strings.signInWithOutlook,
                backgroundColor: const Color(0xFF1473E6),
                textColor: Colors.white,
                icon: const SocialIcon(
                  assetPath: 'assets/icons/microsoft-outlook-2025.png',
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              SocialButton(
                text: strings.signInWithGoogle,
                backgroundColor: Colors.white,
                textColor: const Color(0xFF333333),
                icon: const SocialIcon(
                  assetPath: 'assets/icons/google-logo.jpg',
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              SocialButton(
                text: strings.signInWithApple,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                border: true,
                borderColor: Colors.white,
                icon: const SocialIcon(
                  assetPath: 'assets/icons/apple.jpg',
                  size: 23,
                ),
                onPressed: () {},
              ),
              const Spacer(),
              SocialButton(
                text: strings.newUserCreateAccount,
                backgroundColor: Colors.white,
                textColor: const Color(0xFF333333),
                onPressed: () => _createAccount(context),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
