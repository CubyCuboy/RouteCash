import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/social_register_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import '../components/route_cash_dropdown.dart';
import '../components/route_cash_shared_ui.dart';
import 'auth_screen.dart';
import 'main_navigation_screen.dart';

class SocialRegistrationScreen extends StatefulWidget {
  const SocialRegistrationScreen({super.key});

  @override
  State<SocialRegistrationScreen> createState() => _SocialRegistrationScreenState();
}

class _SocialRegistrationScreenState extends State<SocialRegistrationScreen> {
  late final SocialRegisterViewModel _viewModel;
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = SocialRegisterViewModel();
    _viewModel.addListener(_onViewModelChange);
  }

  void _onViewModelChange() {
    if (_nameController.text.isEmpty && _viewModel.name.isNotEmpty) {
      _nameController.text = _viewModel.name;
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentStep < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutQuart,
      );
      setState(() => _currentStep++);
    } else {
      _completeRegister();
    }
  }

  void _onBack() async {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutQuart,
      );
      setState(() => _currentStep--);
    } else {
      // Caso especial: El usuario quiere cancelar su registro social
      await Supabase.instance.client.auth.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false,
      );
    }
  }

  void _completeRegister() async {
    final result = await _viewModel.completeRegistration();

    if (result == null) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        (route) => false,
      );
    } else {
      if (!mounted) return;
      final strings = AppLocalizations.of(context)!;
      String message = result;
      switch (result) {
        case 'errorNoSession': message = strings.errorNoSession; break;
        case 'errorNetwork': message = strings.errorNetwork; break;
        case 'errorProfileUpdate': message = strings.errorProfileUpdate; break;
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
                                    strings.stepLabel(_currentStep + 1, 2),
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
                              RouteCashProgressBar(progress: (_currentStep + 1) / 2),
                              const SizedBox(height: 32),
                              RouteCashStepTitle(
                                title: _currentStep == 0 ? strings.step1Title : strings.step2Title,
                                subtitle: _currentStep == 0 ? strings.step1Subtitle : strings.step2Subtitle,
                                animationKey: 'social_$_currentStep',
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
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                          child: RouteCashPrimaryButton(
                            text: _currentStep == 1 ? strings.createAccount : strings.nextStep,
                            onPressed: (_currentStep == 0 ? _viewModel.name.isNotEmpty : _viewModel.canContinue) 
                                ? _onNext : null,
                            isLoading: _viewModel.isLoading,
                            showArrow: _currentStep == 0,
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
          const SizedBox(height: 28),
          RouteCashDropdown<Map<String, dynamic>>(
            label: strings.mainCurrencyLabel,
            value: _viewModel.selectedCurrency,
            items: _viewModel.currencies,
            displayMember: 'code',
            onChanged: _viewModel.updateCurrency,
          ),
        ],
      ),
    );
  }
}
