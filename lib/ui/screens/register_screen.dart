import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/register_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import '../components/route_cash_dropdown.dart';
import '../components/password_requirements.dart';
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
        duration: const Duration(milliseconds: 600),
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
        duration: const Duration(milliseconds: 600),
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

      // Localización de errores
      final strings = AppLocalizations.of(context)!;
      String message = result;

      switch (result) {
        case 'errorUserExists':
          message = strings.errorUserExists;
          break;
        case 'errorInvalidEmail':
          message = strings.errorInvalidEmail;
          break;
        case 'errorPasswordTooShort':
          message = strings.errorPasswordTooShort;
          break;
        case 'errorNetwork':
          message = strings.errorNetwork;
          break;
        case 'errorUnexpected':
          message = strings.errorUnexpected;
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
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
              // Fondo de diseño sutil y elegante
              Positioned(
                top: -100,
                right: -50,
                child: _DesignCircle(size: 300, opacity: 0.03),
              ),
              Positioned(
                bottom: -50,
                left: -100,
                child: _DesignCircle(size: 400, opacity: 0.02),
              ),
              Positioned(
                top: 250,
                left: -30,
                child: _DesignCircle(size: 150, opacity: 0.01),
              ),
              
              // Gradiente muy sutil
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFFAFAFA),
                      const Color(0xFFF5F5F5).withValues(alpha: 0.5),
                      const Color(0xFFFAFAFA),
                    ],
                  ),
                ),
              ),
              
              SafeArea(
                child: ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header con Progreso
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
                              _ProgressBar(progress: (_viewModel.currentStep + 1) / 3),
                              const SizedBox(height: 32),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                switchInCurve: Curves.easeOutQuart,
                                switchOutCurve: Curves.easeInQuart,
                                transitionBuilder: (child, animation) => FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.05, 0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                ),
                                child: _buildStepTitle(_viewModel.currentStep, strings),
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
                          child: _buildFooterButtons(strings),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Overlay de carga premium
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
                    color: Colors.white.withValues(alpha: 0.8 * value),
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

  Widget _buildStepTitle(int step, AppLocalizations strings) {
    String title = '';
    String subtitle = '';
    switch (step) {
      case 0:
        title = strings.step1Title;
        subtitle = strings.step1Subtitle;
        break;
      case 1:
        title = strings.step2Title;
        subtitle = strings.step2Subtitle;
        break;
      case 2:
        title = strings.step3Title;
        subtitle = strings.step3Subtitle;
        break;
    }

    return Column(
      key: ValueKey('title_$step'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            color: Colors.black,
            fontSize: 42,
            height: 1,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.8,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: const Color(0xFF888888),
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
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
                  items: _viewModel.countries
                      .map((c) => c['phone_code'] as String)
                      .toSet()
                      .toList(),
                  onChanged: _viewModel.updatePhoneCode,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: RouteCashTextField(
                  label: '${strings.phoneLabel} (${strings.notVerified.toUpperCase()})',
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

  Widget _buildFooterButtons(AppLocalizations strings) {
    final isLastStep = _viewModel.currentStep == 2;
    final canContinue = _viewModel.canContinue;
    
    return Column(
      children: [
        RouteCashPrimaryButton(
          text: isLastStep ? strings.createAccount : strings.nextStep,
          onPressed: canContinue ? _onNext : null,
          isLoading: _viewModel.isLoading,
          backgroundColor: Colors.black,
          showArrow: !isLastStep,
        ),
        if (!isLastStep) ...[
          const SizedBox(height: 20),
          Center(
            child: Text(
              strings.termsAndPrivacy,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: const Color(0xFFB0B0B0),
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutQuart,
                width: constraints.maxWidth * progress,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DesignCircle extends StatelessWidget {
  final double size;
  final double opacity;
  const _DesignCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.black.withValues(alpha: opacity),
            Colors.black.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
