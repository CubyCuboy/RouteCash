import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../accounts/presentation/screens/accounts_setup_screen.dart';
import 'register_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
void _login() {
  final email = _emailController.text.trim();
  final password = _passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ingresa tu correo y contraseña'),
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
        content: Text('Aquí se abrirá la rercuperación de contraseña'),
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
                  _LoginBackButton(onPressed: () => Navigator.pop(context)),

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

                  RouteCashTextField(
                    label: 'CONTRASEÑA',
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
