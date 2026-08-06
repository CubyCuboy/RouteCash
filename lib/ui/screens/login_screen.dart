import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/login_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import 'confirm_verification_screen.dart';
import 'main_navigation_screen.dart';
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
  late final LoginViewModel _viewModel;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel();
    _emailController = TextEditingController(text: widget.initialEmail);
    _passwordController = TextEditingController(text: widget.initialPassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final result = await _viewModel.login(email, password);

    if (result != null) {
      if (!mounted) return;

      // Manejar caso de email no verificado
      if (result.contains('Email not confirmed') || result.contains('unverified')) {
        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ConfirmVerificationScreen(
                userId: user.id,
                email: email,
                purpose: 'email_verification',
                password: password,
              ),
            ),
          );
          return;
        }
      }

      String message = result;
      final strings = AppLocalizations.of(context)!;

      if (result == 'empty_fields') {
        message = 'Ingresa tu correo y contraseña';
      } else if (result == 'errorInvalidCredentials') {
        message = strings.errorInvalidCredentials;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      return;
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigationScreen(),
      ),
    );
  }

  void _forgotPassword() {
    final strings = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.passwordRecoveryMessage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                      CircleIconButton(
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.pop(context),
                      ),

                      const SizedBox(height: 42),

                      Text(
                        AppLocalizations.of(context)!.loginWelcomeLabel,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF9D9D9D),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        AppLocalizations.of(context)!.loginTitle,
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
                        label: AppLocalizations.of(context)!.emailLabel,
                        hintText: 'andrea@correo.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 26),

                      ListenableBuilder(
                        listenable: _viewModel,
                        builder: (context, _) {
                          return RouteCashTextField(
                            label: AppLocalizations.of(context)!.passwordLabel,
                            hintText: '••••••••••',
                            controller: _passwordController,
                            obscureText: _viewModel.obscurePassword,
                            suffixIcon: IconButton(
                              onPressed: _viewModel.togglePasswordVisibility,
                              icon: Icon(
                                _viewModel.obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                                color: const Color(0xFF999999),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 17),

                      ListenableBuilder(
                        listenable: _viewModel,
                        builder: (context, _) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      value: _viewModel.rememberMe,
                                      onChanged: (val) => _viewModel.toggleRememberMe(val),
                                      activeColor: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocalizations.of(context)!.keepMeLoggedIn,
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: _forgotPassword,
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      foregroundColor: Colors.black,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.forgotPassword,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                        decorationThickness: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 50),

                      ListenableBuilder(
                        listenable: _viewModel,
                        builder: (context, _) {
                          return RouteCashPrimaryButton(
                            text: AppLocalizations.of(context)!.signIn,
                            onPressed: _viewModel.isLoading ? null : _login,
                            isLoading: _viewModel.isLoading,
                          );
                        },
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
                            AppLocalizations.of(context)!.noAccountRegister,
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
        ),
        ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            if (!_viewModel.isLoading) return const SizedBox.shrink();
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Container(
                    color: Colors.white.withValues(alpha: 0.6 * value),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}