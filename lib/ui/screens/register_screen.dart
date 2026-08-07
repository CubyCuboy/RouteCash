import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/register_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import '../components/route_cash_dropdown.dart';
import '../components/password_requirements.dart';
import '../components/route_cash_shared_ui.dart';
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
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutQuart,
      );
      _viewModel.setStep(_viewModel.currentStep + 1);
    } else {
      _completeRegister();
    }
  }

  void _onBack() {
    if (_viewModel.currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutQuart,
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
              userName: _viewModel.fullName,
            ),
          ),
        );
        return;
      }

      final strings = AppLocalizations.of(context)!;
      String message = result;

      switch (result) {
        case 'errorUserExists': message = strings.errorUserExists; break;
        case 'errorInvalidEmail': message = strings.errorInvalidEmail; break;
        case 'errorPasswordTooShort': message = strings.errorPasswordTooShort; break;
        case 'errorNetwork': message = strings.errorNetwork; break;
        case 'errorUnexpected': message = strings.errorUnexpected; break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: Stack(
            children: [
              // Fondo animado
              const Positioned.fill(
                child: RouteCashAnimatedBackground(),
              ),
              
              SafeArea(
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
                                    backgroundColor: Colors.white,
                                    borderColor: Colors.grey.withValues(alpha: 0.1),
                                  ),
                                  Text(
                                    strings.stepLabel(_viewModel.currentStep + 1, 3),
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              RouteCashProgressBar(progress: (_viewModel.currentStep + 1) / 3),
                              const SizedBox(height: 32),
                              RouteCashStepTitle(
                                title: _getStepTitle(_viewModel.currentStep, strings),
                                subtitle: _getStepSubtitle(_viewModel.currentStep, strings),
                                animationKey: _viewModel.currentStep,
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildStep1(strings),
                              _buildStep2(strings),
                              _buildStep3(strings),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                          child: RouteCashPrimaryButton(
                            text: _viewModel.currentStep == 2 ? strings.createAccount : strings.nextStep,
                            onPressed: _viewModel.canContinue ? _onNext : null,
                            isLoading: _viewModel.isLoading,
                            showArrow: _viewModel.currentStep < 2,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) => RouteCashLoadingOverlay(isLoading: _viewModel.isLoading),
        ),
      ],
    );
  }

  String _getStepTitle(int step, AppLocalizations strings) {
    if (step == 0) return strings.step1Title;
    if (step == 1) return strings.step2Title;
    return strings.step3Title;
  }

  String _getStepSubtitle(int step, AppLocalizations strings) {
    if (step == 0) return strings.step1Subtitle;
    if (step == 1) return strings.step2Subtitle;
    return strings.step3Subtitle;
  }

  Widget _buildStep1(AppLocalizations strings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        children: [
          RouteCashTextField(
            label: strings.fullNameLabel,
            hintText: strings.fullNamePlaceholder,
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            onChanged: _viewModel.updateName,
          ),
          const SizedBox(height: 28),
          RouteCashTextField(
            label: strings.emailLabel,
            hintText: strings.emailPlaceholder,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: _viewModel.updateEmail,
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 100,
                child: RouteCashDropdown<String>(
                  label: strings.phoneCodeLabel,
                  value: _viewModel.selectedPhoneCode,
                  items: _viewModel.countries.map((c) => c['phone_code'] as String).toSet().toList(),
                  onChanged: _viewModel.updatePhoneCode,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: RouteCashTextField(
                  label: '${strings.phoneLabel} (${strings.optionalLabel})',
                  hintText: strings.phonePlaceholder,
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  onChanged: _viewModel.updatePhone,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(AppLocalizations strings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        children: [
          RouteCashDropdown<Map<String, dynamic>>(
            label: strings.countryLabel,
            value: _viewModel.selectedCountry,
            items: _viewModel.countries,
            displayMember: 'name',
            onChanged: _viewModel.updateCountry,
          ),
          const SizedBox(height: 28),
          RouteCashDropdown<Map<String, dynamic>>(
            label: strings.stateLabel,
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

  Widget _buildStep3(AppLocalizations strings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        children: [
          RouteCashDropdown<Map<String, dynamic>>(
            label: strings.mainCurrencyLabel,
            value: _viewModel.selectedCurrency,
            items: _viewModel.currencies,
            displayMember: 'code',
            onChanged: _viewModel.updateCurrency,
          ),
          const SizedBox(height: 32),
          PasswordRequirements(
            hasMinLength: _viewModel.hasMinLength,
            hasUppercase: _viewModel.hasUppercase,
            hasNumber: _viewModel.hasNumber,
            hasSpecialChar: _viewModel.hasSpecialChar,
            passwordsMatch: _viewModel.passwordsMatch,
          ),
          const SizedBox(height: 20),
          RouteCashTextField(
            label: strings.passwordLabel,
            hintText: strings.passwordPlaceholder,
            controller: _passwordController,
            obscureText: _viewModel.obscurePassword,
            onChanged: _viewModel.updatePassword,
            suffixIcon: IconButton(
              onPressed: _viewModel.togglePasswordVisibility,
              icon: Icon(
                _viewModel.obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 28),
          RouteCashTextField(
            label: strings.confirmPasswordLabel,
            hintText: strings.passwordPlaceholder,
            controller: _confirmPasswordController,
            obscureText: _viewModel.obscureConfirmPassword,
            onChanged: _viewModel.updateConfirmPassword,
            suffixIcon: IconButton(
              onPressed: _viewModel.toggleConfirmPasswordVisibility,
              icon: Icon(
                _viewModel.obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
