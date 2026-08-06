import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../components/route_cash_buttons.dart';
import 'main_navigation_screen.dart';
import 'login_screen.dart';

class VerificationSuccessScreen extends StatelessWidget {
  final String email;
  final String password;
  final bool returnToHome;
  final int initialIndex;

  const VerificationSuccessScreen({
    super.key,
    required this.email,
    required this.password,
    this.returnToHome = false,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white.withValues(alpha: value),
                        size: 100 * value,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        strings.successTitle,
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        returnToHome 
                          ? strings.successAccountLinkedMsg
                          : strings.successAccountVerified,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 64),
                      RouteCashPrimaryButton(
                        text: returnToHome ? strings.continueButton : strings.goToLogin,
                        onPressed: () {
                          if (returnToHome) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => MainNavigationScreen(initialIndex: initialIndex),
                              ),
                              (route) => false,
                            );
                          } else {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => LoginScreen(
                                  initialEmail: email,
                                  initialPassword: password,
                                ),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
