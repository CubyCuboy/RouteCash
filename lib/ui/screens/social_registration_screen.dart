import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/social_register_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import '../components/route_cash_dropdown.dart';
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
    // Pre-fill controllers when data is loaded
    _viewModel.addListener(_onViewModelChange);
  }

  void _onViewModelChange() {
    if (_nameController.text.isEmpty && _viewModel.name.isNotEmpty) {
      _nameController.text = _viewModel.name;
    }
    if (_phoneController.text.isEmpty && _viewModel.phone.isNotEmpty) {
      _phoneController.text = _viewModel.phone;
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
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _completeRegister();
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
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
                            'PASO ${_currentStep + 1} DE 2',
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
                        children: List.generate(2, (index) {
                          return Expanded(
                            child: Container(
                              height: 4,
                              margin: EdgeInsets.only(right: index < 1 ? 8 : 0),
                              decoration: BoxDecoration(
                                color: index <= _currentStep ? Colors.black : const Color(0xFFE0E0E0),
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
    switch (_currentStep) {
      case 0:
        title = 'Completa tu\nperfil.';
        subtitle = 'Solo unos detalles más para empezar.';
        break;
      case 1:
        title = 'Preferencias\ny región.';
        subtitle = 'Personalizaremos tu experiencia.';
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
            hintText: 'Tu nombre',
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            onChanged: _viewModel.updateName,
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
          const SizedBox(height: 24),
          RouteCashDropdown<Map<String, dynamic>>(
            label: 'MONEDA POR DEFECTO',
            value: _viewModel.selectedCurrency,
            items: _viewModel.currencies,
            displayMember: 'code',
            onChanged: _viewModel.updateCurrency,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButtons() {
    final isLastStep = _currentStep == 1;
    final bool canProceed = _currentStep == 0 
      ? _viewModel.name.isNotEmpty 
      : _viewModel.canContinue;

    return Column(
      children: [
        RouteCashPrimaryButton(
          text: isLastStep ? 'COMENZAR' : 'CONTINUAR',
          onPressed: canProceed ? _onNext : () {},
          isLoading: _viewModel.isLoading,
          backgroundColor: canProceed ? Colors.black : Colors.grey.shade400,
        ),
      ],
    );
  }
}
