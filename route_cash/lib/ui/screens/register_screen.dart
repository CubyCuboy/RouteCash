import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/register_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import 'accounts_setup_screen.dart';
import 'login_screen.dart';
import 'main_navigation_screen.dart';

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
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = RegisterViewModel();
    
    _passwordController.addListener(_updatePasswordValidation);
    _confirmPasswordController.addListener(_updatePasswordValidation);
  }

  void _updatePasswordValidation() {
    _viewModel.validatePassword(
      _passwordController.text,
      _confirmPasswordController.text,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _continueRegister() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final result = await _viewModel.register(name, email, password, confirmPassword);

    if (result != null) {
      if (!mounted) return;
      
      String message = result;
      final strings = AppLocalizations.of(context)!;
      
      if (result == 'all_fields_required') {
        message = 'Completa todos los campos';
      } else if (result == 'invalidEmail') {
        message = strings.invalidEmail;
      } else if (result == 'weakPassword') {
        message = strings.weakPassword;
      } else if (result == 'passwordsDoNotMatch') {
        message = strings.passwordsDoNotMatch;
      } else if (result.contains('already registered') || result.contains('already been registered')) {
        message = strings.errorUserExists;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
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
                          AppLocalizations.of(context)!.registerProgress,
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
                    AppLocalizations.of(context)!.firstStepLabel,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9D9D9D),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    AppLocalizations.of(context)!.registerTitle,
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
                    AppLocalizations.of(context)!.registerDescription,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF999999),
                      fontSize: 14,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 42),

                  RouteCashTextField(
                    label: AppLocalizations.of(context)!.fullNameLabel,
                    hintText: 'Andrea Moreno',
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                  ),

                  const SizedBox(height: 26),

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
                      return Column(
                        children: [
                          _PasswordRequirements(viewModel: _viewModel),
                          const SizedBox(height: 12),
                          RouteCashTextField(
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
                          ),
                          const SizedBox(height: 26),
                          RouteCashTextField(
                            label: AppLocalizations.of(context)!.confirmPasswordLabel,
                            hintText: AppLocalizations.of(context)!.confirmPasswordHint,
                            controller: _confirmPasswordController,
                            obscureText: _viewModel.obscureConfirmPassword,
                            suffixIcon: IconButton(
                              onPressed: _viewModel.toggleConfirmPasswordVisibility,
                              icon: Icon(
                                _viewModel.obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                                color: const Color(0xFF999999),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const Spacer(),

                  const SizedBox(height: 36),

                  ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      return RouteCashPrimaryButton(
                        text: AppLocalizations.of(context)!.continueButton,
                        onPressed: _continueRegister,
                        isLoading: _viewModel.isLoading,
                      );
                    },
                  ),

                  const SizedBox(height: 17),

                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.termsAndPrivacy,
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

class _PasswordRequirements extends StatelessWidget {
  final RegisterViewModel viewModel;

  const _PasswordRequirements({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RequirementRow(
          text: "8+ caracteres",
          isMet: viewModel.hasMinLength,
        ),
        _RequirementRow(
          text: "Una mayúscula",
          isMet: viewModel.hasUppercase,
        ),
        _RequirementRow(
          text: "Un número",
          isMet: viewModel.hasNumber,
        ),
        _RequirementRow(
          text: r"Carácter especial (!@#$)",
          isMet: viewModel.hasSpecialChar,
        ),
        _RequirementRow(
          text: "Las contraseñas coinciden",
          isMet: viewModel.passwordsMatch,
        ),
      ],
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String text;
  final bool isMet;

  const _RequirementRow({required this.text, required this.isMet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 14,
            color: isMet ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isMet ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
