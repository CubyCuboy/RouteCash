import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/register_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import '../components/route_cash_dropdown.dart';
import 'confirm_verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterViewModel _viewModel;
  final PageController _pageController = PageController();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = RegisterViewModel();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_viewModel.currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      _viewModel.setStep(_viewModel.currentStep + 1);
    } else {
      _completeRegister();
    }
  }

  void _onBack() {
    if (_viewModel.currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      _viewModel.setStep(_viewModel.currentStep - 1);
    } else {
      Navigator.pop(context);
    }
  }

  void _completeRegister() async {
    final result = await _viewModel.register();

    if (result != null) {
      if (!mounted) return;
      if (result.startsWith('verify:')) {
        final userId = result.split(':')[1];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ConfirmVerificationScreen(
              userId: userId,
              email: _viewModel.email,
              purpose: 'verify_email',
              password: _viewModel.password,
            ),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 20, 32, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleIconButton(
                            icon: Icons.arrow_back,
                            onPressed: _onBack,
                          ),
                          Text(
                            'PASO ${_viewModel.currentStep + 1} DE 3',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF999999),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: List.generate(3, (index) {
                          return Expanded(
                            child: Container(
                              height: 4,
                              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                              decoration: BoxDecoration(
                                color: index <= _viewModel.currentStep ? Colors.black : const Color(0xFFE0E0E0),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 12),
                      _buildStepTitle(),
                    ],
                  ),
                ),
                
                Expanded(
                  child: _viewModel.countries.isEmpty && _viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.black))
                      : PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildStep1(),
                            _buildStep2(),
                            _buildStep3(),
                          ],
                        ),
                ),
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
                  child: _buildFooterButtons(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepTitle() {
    String title = '';
    String subtitle = '';
    switch (_viewModel.currentStep) {
      case 0:
        title = 'Cuéntanos\nde ti.';
        subtitle = 'Tu información básica para empezar.';
        break;
      case 1:
        title = '¿Dónde te\nencuentras?';
        subtitle = 'Personalizaremos tu experiencia según tu región.';
        break;
      case 2:
        title = 'Seguridad y\npreferencias.';
        subtitle = 'Crea una contraseña fuerte para tu cuenta.';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            color: Colors.black,
            fontSize: 40,
            height: 1,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: const Color(0xFF999999),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        children: [
          RouteCashTextField(
            label: 'NOMBRE COMPLETO',
            hintText: 'Andrea Moreno',
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            onChanged: _viewModel.updateName,
          ),
          const SizedBox(height: 24),
          RouteCashTextField(
            label: 'CORREO ELECTRÓNICO',
            hintText: 'andrea@correo.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: _viewModel.updateEmail,
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 100,
                child: RouteCashDropdown<String>(
                  label: 'CÓDIGO',
                  value: _viewModel.selectedPhoneCode,
                  items: _viewModel.countries
                      .map((c) => c['phone_code'] as String)
                      .toSet()
                      .toList(),
                  onChanged: _viewModel.updatePhoneCode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RouteCashTextField(
                  label: 'TELÉFONO (OPCIONAL)',
                  hintText: '1234567890',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged: _viewModel.updatePhone,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        children: [
          RouteCashDropdown<Map<String, dynamic>>(
            label: 'PAÍS',
            value: _viewModel.selectedCountry,
            items: _viewModel.countries,
            displayMember: 'name',
            onChanged: _viewModel.updateCountry,
          ),
          const SizedBox(height: 24),
          RouteCashDropdown<Map<String, dynamic>>(
            label: 'ESTADO / REGIÓN',
            value: _viewModel.selectedState,
            items: _viewModel.states,
            displayMember: 'name',
            enabled: _viewModel.selectedCountry != null,
            onChanged: _viewModel.updateState,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        children: [
          RouteCashDropdown<Map<String, dynamic>>(
            label: 'MONEDA POR DEFECTO',
            value: _viewModel.selectedCurrency,
            items: _viewModel.currencies,
            displayMember: 'code',
            onChanged: _viewModel.updateCurrency,
          ),
          const SizedBox(height: 24),
          _PasswordRequirements(viewModel: _viewModel),
          const SizedBox(height: 12),
          RouteCashTextField(
            label: 'CONTRASEÑA',
            hintText: '••••••••••',
            controller: _passwordController,
            obscureText: _viewModel.obscurePassword,
            onChanged: _viewModel.updatePassword,
            suffixIcon: IconButton(
              onPressed: _viewModel.togglePasswordVisibility,
              icon: Icon(_viewModel.obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
            ),
          ),
          const SizedBox(height: 24),
          RouteCashTextField(
            label: 'CONFIRMAR CONTRASEÑA',
            hintText: '••••••••••',
            controller: _confirmPasswordController,
            obscureText: _viewModel.obscureConfirmPassword,
            onChanged: _viewModel.updateConfirmPassword,
            suffixIcon: IconButton(
              onPressed: _viewModel.toggleConfirmPasswordVisibility,
              icon: Icon(_viewModel.obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButtons() {
    final isLastStep = _viewModel.currentStep == 2;
    return Column(
      children: [
        RouteCashPrimaryButton(
          text: isLastStep ? 'CREAR CUENTA' : 'CONTINUAR',
          onPressed: _viewModel.canContinue ? _onNext : () {},
          isLoading: _viewModel.isLoading,
          backgroundColor: _viewModel.canContinue ? Colors.black : Colors.grey.shade400,
        ),
        if (!isLastStep) ...[
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Al continuar, aceptas nuestros términos y privacidad.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: const Color(0xFFB0B0B0), fontSize: 10),
            ),
          ),
        ],
      ],
    );
  }
}

class _PasswordRequirements extends StatelessWidget {
  final RegisterViewModel viewModel;
  const _PasswordRequirements({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          _RequirementRow(text: "8+ caracteres", isMet: viewModel.hasMinLength),
          _RequirementRow(text: "Una mayúscula", isMet: viewModel.hasUppercase),
          _RequirementRow(text: "Un número", isMet: viewModel.hasNumber),
          _RequirementRow(text: r"Carácter especial (!@#$)", isMet: viewModel.hasSpecialChar),
          _RequirementRow(text: "Las contraseñas coinciden", isMet: viewModel.passwordsMatch),
        ],
      ),
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
          Icon(isMet ? Icons.check_circle : Icons.circle_outlined, size: 14, color: isMet ? Colors.green : Colors.grey),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.inter(fontSize: 11, color: isMet ? Colors.green : Colors.grey)),
        ],
      ),
    );
  }
}
