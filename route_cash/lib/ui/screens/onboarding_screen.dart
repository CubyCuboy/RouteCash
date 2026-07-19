import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodels/onboarding_view_model.dart';
import '../components/onboarding_background.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OnboardingViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _openAuthScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Deslizar hacia la izquierda.
          if ((details.primaryVelocity ?? 0) < -200) {
            _openAuthScreen();
          }
        },
        child: SafeArea(
          child: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
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
                          'RouteCash',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 43,
                            height: 1,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tus finanzas en un\nsolo lugar',
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
                        _buildDot(isActive: _viewModel.currentPage == 0, onTap: () => _viewModel.setPage(0)),
                        const SizedBox(width: 8),
                        _buildDot(isActive: _viewModel.currentPage == 1, onTap: _openAuthScreen),
                        const SizedBox(width: 8),
                        _buildDot(isActive: _viewModel.currentPage == 2, onTap: _openAuthScreen),
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
                        'Continuar',
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
