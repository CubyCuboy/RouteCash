import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodels/login_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import 'accounts_setup_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginViewModel _viewModel;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;
    
    final errorMessage = _viewModel.validateAndLogin(email, password);

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
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

  void _forgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Aquí se abrirá la recuperación de contraseña'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  CircleIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),

                  const SizedBox(height: 42),

                  Text(
                    'QUÉ BUENO VERTE',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9D9D9D),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    'Vuelve a\ntu ruta.',
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
                    label: 'CORREO ELECTRÓNICO',
                    hintText: 'andrea@correo.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 26),

                  ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      return RouteCashTextField(
                        label: 'CONTRASEÑA',
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

                  TextButton(
                    onPressed: _forgotPassword,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      'Olvidé mi contraseña',
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
                    text: 'Iniciar sesión',
                    onPressed: _login,
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
                        '¿No tienes cuenta? Regístrate',
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
