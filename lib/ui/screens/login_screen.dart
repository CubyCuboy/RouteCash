import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import 'accounts_setup_screen.dart';
import 'register_screen.dart';


class LoginScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialPassword;

  const LoginScreen({
    super.key,
    this.initialEmail,
    this.initialPassword,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final _emailController = TextEditingController(text: widget.initialEmail);
  late final _passwordController = TextEditingController(text: widget.initialPassword);

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
void _login(AppLocalizations strings) {
  final email = _emailController.text.trim();
  final password = _passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.errorInvalidCredentials),
      ),
    );
    return;
  }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const AccountsSetupScreen(),
    ),
  );
}

  void _forgotPassword(AppLocalizations strings) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.passwordRecoveryMessage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 20, 32, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  44,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LoginBackButton(onPressed: () => Navigator.pop(context)),

                  const SizedBox(height: 42),

                  Text(
                    strings.loginWelcomeLabel,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9D9D9D),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    strings.loginTitle,
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.black,
                      fontSize: 48,
                      height: 0.88,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.8,
                    ),
                  ),

                  const SizedBox(height: 50),

                  RouteCashTextField(
                    label: strings.emailLabel,
                    hintText: 'andrea@correo.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 26),

                  RouteCashTextField(
                    label: strings.passwordLabel,
                    hintText: '••••••••••',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: const Color(0xFF999999),
                      ),
                    ),
                  ),

                  const SizedBox(height: 17),

                  TextButton(
                    onPressed: () => _forgotPassword(strings),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      strings.forgotPassword,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationThickness: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  RouteCashPrimaryButton(
                    text: strings.signIn,
                    onPressed: () => _login(strings),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        strings.noAccountRegister,
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginBackButton extends StatelessWidget {
  const _LoginBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE2E2E2)),
        ),
        child: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
      ),
    );
  }
}
