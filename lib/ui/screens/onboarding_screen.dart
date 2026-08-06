import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../components/onboarding_background.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  void _openAuthScreen() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) < -200) {
            _openAuthScreen();
          }
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  const Positioned.fill(child: OnboardingBackground()),

                  Positioned(
                    left: 28,
                    right: 28,
                    bottom: 88,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.appName.replaceAll(' ', ''),
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 43,
                            height: 1,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          strings.onboardingSubtitle,
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            height: 1.45,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    left: 28,
                    bottom: 35,
                    child: Row(
                      children: [
                        _buildDot(isActive: true, onTap: () {}),
                        const SizedBox(width: 8),
                        _buildDot(isActive: false, onTap: _openAuthScreen),
                        const SizedBox(width: 8),
                        _buildDot(isActive: false, onTap: _openAuthScreen),
                      ],
                    ),
                  ),

                  Positioned(
                    right: 18,
                    bottom: 20,
                    child: TextButton(
                      onPressed: _openAuthScreen,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: Text(
                        strings.continueButton,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDot({required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.black : const Color(0xFFE1E1E1),
        ),
      ),
    );
  }
}

