import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/verification_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import 'verification_success_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String purpose;
  final String password;

  const OtpVerificationScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.purpose,
    required this.password,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _viewModel = VerificationViewModel();
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.startTimer();
    _viewModel.fetchOtpStatus(widget.userId, widget.purpose);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _verify() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el código de 6 dígitos')),
      );
      return;
    }

    final lang = Localizations.localeOf(context).languageCode;
    final error = await _viewModel.verifyCode(widget.userId, code, widget.purpose, lang);
    
    if (error == null) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => VerificationSuccessScreen(
            email: widget.email,
            password: widget.password,
          ),
        ),
        (route) => false,
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  void _resend() async {
    final lang = Localizations.localeOf(context).languageCode;
    final error = await _viewModel.sendCode(widget.userId, widget.email, widget.purpose, lang);
    if (error == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nuevo código enviado')),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          child: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 42),
                  Text(
                    'INGRESA EL CÓDIGO',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9D9D9D),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Verifica\ntu cuenta.',
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
                    'Hemos enviado un código a ${widget.email}',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF999999),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 42),
                  RouteCashTextField(
                    label: 'CÓDIGO DE 6 DÍGITOS',
                    hintText: '123456',
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tiempo restante: ${_viewModel.timerText}',
                              style: GoogleFonts.inter(
                                color: _viewModel.isExpired ? Colors.red : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Intentos disponibles: ${_viewModel.attemptsRemaining}',
                              style: GoogleFonts.inter(
                                color: _viewModel.attemptsRemaining <= 1 ? Colors.red : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_viewModel.isExpired || _viewModel.attemptsRemaining == 0)
                        ElevatedButton(
                          onPressed: _resend,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1473E6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('REENVIAR CÓDIGO'),
                        )
                      else
                        TextButton(
                          onPressed: _viewModel.secondsRemaining < 1740 ? _resend : null, // Permitir reenviar tras 1 min
                          child: Text(
                            'Reenviar',
                            style: GoogleFonts.inter(
                              color: _viewModel.secondsRemaining < 1740 ? const Color(0xFF1473E6) : Colors.grey,
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  RouteCashPrimaryButton(
                    text: 'Verificar',
                    onPressed: _viewModel.canVerify ? _verify : () {},
                    isLoading: _viewModel.isLoading,
                    showArrow: _viewModel.canVerify,
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
