import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../components/route_cash_buttons.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                strings.appName,
                style: GoogleFonts.playfairDisplay(
                  color: Colors.black,
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                strings.onboardingSubtitle,
                style: GoogleFonts.inter(
                  color: const Color(0xFF999999),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              const Spacer(flex: 2),
              RouteCashPrimaryButton(
                text: strings.continueButton,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
