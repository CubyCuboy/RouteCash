import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodels/verification_view_model.dart';
import '../components/route_cash_buttons.dart';
import 'otp_verification_screen.dart';

class ConfirmVerificationScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String purpose;
  final String password; // Para devolverlo al login luego

  const ConfirmVerificationScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.purpose,
    required this.password,
  });

  @override
  State<ConfirmVerificationScreen> createState() => _ConfirmVerificationScreenState();
}

class _ConfirmVerificationScreenState extends State<ConfirmVerificationScreen> {
  final _viewModel = VerificationViewModel();

  void _sendCode() async {
    final lang = Localizations.localeOf(context).languageCode;
    final error = await _viewModel.sendCode(widget.userId, widget.email, widget.purpose, lang);
    
    if (error == null) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            userId: widget.userId,
            email: widget.email,
            purpose: widget.purpose,
            password: widget.password,
          ),
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleIconButton(
                icon: Icons.arrow_back,
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 32),
              Text(
                'Hola Diego 👋',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'VERIFICACIÓN',
                style: GoogleFonts.inter(
                  color: const Color(0xFF9D9D9D),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Confirma tu cuenta.',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.black,
                  fontSize: 48,
                  height: 0.88,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.8,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Enviaremos un código de seguridad a:',
                style: GoogleFonts.inter(
                  color: const Color(0xFF999999),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) {
                  return RouteCashPrimaryButton(
                    text: 'Enviar código',
                    onPressed: _sendCode,
                    isLoading: _viewModel.isLoading,
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
