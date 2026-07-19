import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodels/register_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import 'accounts_setup_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterViewModel _viewModel;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = RegisterViewModel();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _continueRegister() {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    final errorMessage = _viewModel.validateAndRegister(name, email, password);

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleIconButton(
                        icon: Icons.arrow_back,
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
                          '1 / 3',
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
                    'PRIMER PASO',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9D9D9D),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    'Empezamos\ncontigo.',
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
                    'Crea tu espacio personal para guardar y\nentender cada movimiento.',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF999999),
                      fontSize: 14,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 42),

                  RouteCashTextField(
                    label: 'NOMBRE COMPLETO',
                    hintText: 'Andrea Moreno',
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                  ),

                  const SizedBox(height: 26),

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

                  const Spacer(),

                  const SizedBox(height: 36),

                  RouteCashPrimaryButton(
                    text: 'Continuar',
                    onPressed: _continueRegister,
                  ),

                  const SizedBox(height: 17),

                  Center(
                    child: Text(
                      'Al continuar aceptas nuestros términos y privacidad.',
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
