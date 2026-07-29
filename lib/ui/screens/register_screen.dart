import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import 'accounts_setup_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _continueRegister(AppLocalizations strings) {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.errorUnexpected), // Or a more specific string if available
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _BackButton(
                        onPressed: () => Navigator.pop(context),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          strings.registerProgress,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 42),

                  Text(
                    strings.firstStepLabel,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9D9D9D),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    strings.registerTitle,
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.black,
                      fontSize: 48,
                      height: 0.88,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.8,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    strings.registerDescription,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF999999),
                      fontSize: 14,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 42),

                  RouteCashTextField(
                    label: strings.fullNameLabel,
                    hintText: 'Andrea Moreno',
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                  ),

                  const SizedBox(height: 26),

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

                  const Spacer(),

                  const SizedBox(height: 36),

                  RouteCashPrimaryButton(
                    text: strings.continueButton,
                    onPressed: () => _continueRegister(strings),
                  ),

                  const SizedBox(height: 17),

                  Center(
                    child: Text(
                      strings.termsAndPrivacy,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFB0B0B0),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({
    required this.onPressed,
  });

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
          border: Border.all(
            color: const Color(0xFFE2E2E2),
          ),
        ),
        child: const Icon(
          Icons.arrow_back,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }
}
