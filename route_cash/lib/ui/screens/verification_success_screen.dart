import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/route_cash_buttons.dart';
import 'login_screen.dart';

class VerificationSuccessScreen extends StatelessWidget {
  final String email;
  final String password;

  const VerificationSuccessScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 100,
              ),
              const SizedBox(height: 32),
              Text(
                '¡Éxito!',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tu cuenta ha sido verificada correctamente. Ahora puedes iniciar sesión.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 64),
              RouteCashPrimaryButton(
                text: 'Ir al Login',
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => LoginScreen(
                        initialEmail: email,
                        initialPassword: password,
                      ),
                    ),
                    (route) => false,
                  );
                },
                backgroundColor: Colors.white,
                textColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
