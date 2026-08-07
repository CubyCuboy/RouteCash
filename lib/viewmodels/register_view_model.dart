import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/catalog_service.dart';
import '../utils/email_validator.dart';
import '../utils/phone_validator.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final CatalogService _catalogService = CatalogService();

  int _currentStep = 0;
  int get currentStep => _currentStep;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Catalog data
  List<Map<String, dynamic>> countries = [];
  List<Map<String, dynamic>> states = [];
  List<Map<String, dynamic>> currencies = [];

  // Form fields
  String name = '';
  String get fullName => name;
  String email = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';

  // Selected values
  Map<String, dynamic>? selectedCountry;
  Map<String, dynamic>? selectedState;
  Map<String, dynamic>? selectedCurrency;
  String? selectedPhoneCode;

  // Password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  // Password requirements
  bool hasUppercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;
  bool hasMinLength = false;
  bool passwordsMatch = false;

  RegisterViewModel() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();
    try {
      debugPrint('DEBUG: Attempting to load catalogs...');
      countries = await _catalogService.getCountries();
      currencies = await _catalogService.getCurrencies();
      
      debugPrint('DEBUG: Success! Countries: ${countries.length}, Currencies: ${currencies.length}');
      
      if (countries.isNotEmpty) {
        selectedCountry = null; // Let user select
        selectedPhoneCode = null; // Default to empty
      }
      
      if (currencies.isNotEmpty) {
        selectedCurrency = currencies.firstWhere(
          (c) => c['code'] == 'USD',
          orElse: () => currencies.first,
        );
      }
    } catch (e) {
      debugPrint('DEBUG ERROR: Failed to load catalogs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStates(String countryId) async {
    _isLoading = true;
    notifyListeners();
    try {
      states = await _catalogService.getStates(countryId);
      selectedState = null;
    } catch (e) {
      debugPrint('Error loading states: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void updateName(String val) { name = val; notifyListeners(); }
  void updateEmail(String val) { email = val; notifyListeners(); }
  void updatePhone(String val) { phone = val; notifyListeners(); }
  
  void updatePhoneCode(String? val) {
    selectedPhoneCode = val;
    notifyListeners();
  }

  void updateCountry(Map<String, dynamic>? val) {
    selectedCountry = val;
    if (val != null) {
      selectedPhoneCode = val['phone_code'];
      loadStates(val['country_id']);
    } else {
      states = [];
      selectedState = null;
      notifyListeners();
    }
  }

  void updateState(Map<String, dynamic>? val) {
    selectedState = val;
    notifyListeners();
  }

  void updateCurrency(Map<String, dynamic>? val) {
    selectedCurrency = val;
    notifyListeners();
  }

  void updatePassword(String val) { 
    password = val; 
    _validatePassword(); 
    notifyListeners(); 
  }

  void updateConfirmPassword(String val) { 
    confirmPassword = val; 
    _validatePassword(); 
    notifyListeners(); 
  }

  void _validatePassword() {
    hasUppercase = password.contains(RegExp(r'[A-Z]'));
    hasNumber = password.contains(RegExp(r'[0-9]'));
    hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    hasMinLength = password.length >= 8;
    passwordsMatch = password.isNotEmpty && password == confirmPassword;
  }

  bool get isStep1Valid => 
    name.trim().isNotEmpty && 
    EmailValidator.isValid(email) &&
    PhoneValidator.isValid(phone);

  bool get isStep2Valid => 
    selectedCountry != null && 
    selectedState != null;

  bool get isStep3Valid => 
    selectedCurrency != null && 
    hasMinLength && 
    hasUppercase && 
    hasNumber && 
    hasSpecialChar && 
    passwordsMatch;

  bool get canContinue {
    if (_currentStep == 0) return isStep1Valid;
    if (_currentStep == 1) return isStep2Valid;
    if (_currentStep == 2) return isStep3Valid;
    return false;
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  String formatName(String name) {
    if (name.isEmpty) return name;
    return name.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  Future<String?> register() async {
    final formattedName = formatName(name.trim());
    final cleanEmail = EmailValidator.normalize(email);
    final fullPhone = '${selectedPhoneCode ?? ""}${phone.trim()}';

    // Detectar idioma del sistema
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final supportedLanguages = ['es', 'en'];
    final languageCode = supportedLanguages.contains(systemLocale) ? systemLocale : 'en';
    
    _isLoading = true;
    notifyListeners();

    try {
      // Aseguramos que no haya una sesión previa (limpiar rastro de intentos anteriores)
      await _authService.signOut();

      final response = await _authService.signUp(
        cleanEmail,
        password,
        {
          'full_name': formattedName,
          'phone': fullPhone,
          'state_id': selectedState!['state_id'],
          'default_currency_id': selectedCurrency!['currency_id'],
          'language_code': languageCode,
        },
      );

      await _authService.saveWelcomeMessage(formattedName);
      
      if (response.user != null) {
        try {
          await _authService.createUserProfile(
            userId: response.user!.id,
            fullName: formattedName,
            email: cleanEmail,
            phone: fullPhone,
            stateId: selectedState!['state_id'],
            currencyId: selectedCurrency!['currency_id'],
          );
        } catch (_) {}

        return 'verify:${response.user!.id}';
      }
      return null;
    } on AuthException catch (e) {
      debugPrint('Auth Error: ${e.message}');
      final msg = e.message.toLowerCase();
      if (msg.contains('already registered') || msg.contains('already in use')) {
        return 'errorUserExists';
      }
      if (msg.contains('invalid email')) {
        return 'errorInvalidEmail';
      }
      if (msg.contains('password')) {
        return 'errorPasswordTooShort';
      }
      return e.message;
    } catch (e) {
      debugPrint('Unexpected Error: $e');
      final msg = e.toString().toLowerCase();
      if (msg.contains('timeout') || msg.contains('connection')) {
        return 'errorNetwork';
      }
      return 'errorUnexpected';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
