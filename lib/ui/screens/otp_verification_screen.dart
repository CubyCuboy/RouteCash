import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routecash/ui/screens/verification_success_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/verification_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import 'auth_screen.dart';
import 'reset_password_screen.dart';
import '../../viewmodels/settings_view_model.dart';
import '../../services/auth_service.dart';

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
  final _authService = AuthService();
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.setTimerDuration(widget.purpose);
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
    final strings = AppLocalizations.of(context)!;
    final code = _codeController.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.errorUnexpected)),
      );
      return;
    }

    final lang = Localizations.localeOf(context).languageCode;
    final error = await _viewModel.verifyCode(
      widget.userId, 
      code, 
      widget.purpose, 
      lang,
      email: (widget.purpose == 'change_email' || widget.purpose == 'verify_email') ? widget.email : null,
    );
    
    if (error == null) {
      if (!mounted) return;
      
      if (widget.purpose == 'recovery') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(email: widget.email),
          ),
        );
        return;
      }

      if (widget.purpose == 'change_email') {
        await Supabase.instance.client.auth.signOut();
        
        if (!mounted) return;
        // Si es vinculación de email/password o verificación de email
      if (widget.purpose == 'verify_email') {
        // Forzamos la actualización de la sesión para obtener las nuevas identidades (Google + Email)
        await Supabase.instance.client.auth.refreshSession();
      }

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
          (route) => false,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo actualizado. Por favor inicia sesión con tu nueva dirección.')),
        );
        return;
      }

      // Si es vinculación de email/password o verificación de email
      if (widget.purpose == 'verify_email') {
        // Forzamos la actualización de la sesión para obtener las nuevas identidades (Google + Email)
        await Supabase.instance.client.auth.refreshSession();
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => VerificationSuccessScreen(
            email: widget.email,
            password: widget.password,
            returnToHome: Supabase.instance.client.auth.currentSession != null,
            initialIndex: widget.purpose == 'verify_email' && Supabase.instance.client.auth.currentSession != null ? 3 : 0,
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
    final strings = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final error = await _viewModel.sendCode(widget.userId, widget.email, widget.purpose, lang);
    if (error == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.successLinking)),
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
    final strings = AppLocalizations.of(context)!;
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
                    strings.enterCode,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9D9D9D),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    strings.verifyYourAccount,
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
                    strings.codeSentTo(widget.email),
                    style: GoogleFonts.inter(
                      color: const Color(0xFF999999),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 42),
                  RouteCashTextField(
                    label: strings.sixDigitCode,
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
                              strings.timeRemaining(_viewModel.timerText),
                              style: GoogleFonts.inter(
                                color: _viewModel.isExpired ? Colors.red : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              strings.attemptsRemainingLabel(_viewModel.attemptsRemaining),
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
                          child: Text(strings.resendCode),
                        )
                      else
                        TextButton(
                          onPressed: _viewModel.secondsRemaining < 1740 ? _resend : null, // Permitir reenviar tras 1 min
                          child: Text(
                            strings.resend,
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
                    text: strings.verify,
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
