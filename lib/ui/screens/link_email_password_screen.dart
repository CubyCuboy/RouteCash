import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/link_email_password_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import '../components/password_requirements.dart';
import 'confirm_verification_screen.dart';

class LinkEmailPasswordScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialName;

  const LinkEmailPasswordScreen({super.key, this.initialEmail, this.initialName});

  @override
  State<LinkEmailPasswordScreen> createState() => _LinkEmailPasswordScreenState();
}

class _LinkEmailPasswordScreenState extends State<LinkEmailPasswordScreen> {
  late final LinkEmailPasswordViewModel _viewModel;
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = LinkEmailPasswordViewModel();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    if (widget.initialEmail != null) {
      _viewModel.updateEmail(widget.initialEmail!);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    final strings = AppLocalizations.of(context)!;
    final result = await _viewModel.submit(l10n: strings);

    if (result == null) {
      if (!mounted) return;
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ConfirmVerificationScreen(
              userId: user.id,
              email: _viewModel.email,
              purpose: 'verify_email',
              password: _viewModel.password,
              userName: widget.initialName,
            ),
          ),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
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
                    'SEGURIDAD',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9D9D9D),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Configura tu acceso.',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.black,
                      fontSize: 42,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agrega una contraseña a tu cuenta para poder iniciar sesión con correo.',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF999999),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  RouteCashTextField(
                    label: 'CORREO ELECTRÓNICO',
                    hintText: 'ejemplo@correo.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: _viewModel.updateEmail,
                  ),
                  const SizedBox(height: 24),
                  PasswordRequirements(
                    hasMinLength: _viewModel.hasMinLength,
                    hasUppercase: _viewModel.hasUppercase,
                    hasNumber: _viewModel.hasNumber,
                    hasSpecialChar: _viewModel.hasSpecialChar,
                    passwordsMatch: _viewModel.passwordsMatch,
                  ),
                  const SizedBox(height: 24),
                  RouteCashTextField(
                    label: 'CONTRASEÑA',
                    hintText: '••••••••••',
                    controller: _passwordController,
                    obscureText: _viewModel.obscurePassword,
                    onChanged: _viewModel.updatePassword,
                    suffixIcon: IconButton(
                      onPressed: _viewModel.togglePasswordVisibility,
                      icon: Icon(
                        _viewModel.obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RouteCashTextField(
                    label: 'CONFIRMAR CONTRASEÑA',
                    hintText: '••••••••••',
                    controller: _confirmController,
                    obscureText: _viewModel.obscureConfirmPassword,
                    onChanged: _viewModel.updateConfirmPassword,
                    suffixIcon: IconButton(
                      onPressed: _viewModel.toggleConfirmPasswordVisibility,
                      icon: Icon(
                        _viewModel.obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  RouteCashPrimaryButton(
                    text: 'GUARDAR Y VERIFICAR',
                    onPressed: _viewModel.canSubmit ? _onSubmit : () {},
                    isLoading: _viewModel.isLoading,
                    backgroundColor:
                        _viewModel.canSubmit ? Colors.black : Colors.grey.shade400,
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
