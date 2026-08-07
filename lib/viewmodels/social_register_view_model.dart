import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/catalog_service.dart';

class SocialRegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final CatalogService _catalogService = CatalogService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Catalog data
  List<Map<String, dynamic>> countries = [];
  List<Map<String, dynamic>> states = [];
  List<Map<String, dynamic>> currencies = [];

  // Form fields
  String name = '';
  String phone = '';

  // Selected values
  Map<String, dynamic>? selectedCountry;
  Map<String, dynamic>? selectedState;
  Map<String, dynamic>? selectedCurrency;
  String? selectedPhoneCode;

  SocialRegisterViewModel() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();
    try {
      countries = await _catalogService.getCountries();
      currencies = await _catalogService.getCurrencies();
      
      final user = _authService.currentUser;
      if (user != null) {
        name = user.userMetadata?['full_name'] ?? '';
      }

      if (currencies.isNotEmpty) {
        selectedCurrency = currencies.firstWhere(
          (c) => c['code'] == 'USD',
          orElse: () => currencies.first,
        );
      }
    } catch (e) {
      debugPrint('Error loading initial data for social register: $e');
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

  void updateName(String val) { name = val; notifyListeners(); }
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

  bool get canContinue => 
    name.trim().isNotEmpty && 
    selectedCountry != null && 
    selectedState != null && 
    selectedCurrency != null;

  String formatName(String name) {
    if (name.isEmpty) return name;
    return name.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  Future<String?> completeRegistration() async {
    final user = _authService.currentUser;
    if (user == null) return 'errorNoSession';

    final formattedName = formatName(name.trim());
    final fullPhone = '${selectedPhoneCode ?? ""}${phone.trim()}';
    
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.createUserProfile(
        userId: user.id,
        fullName: formattedName,
        email: user.email ?? '',
        phone: fullPhone,
        stateId: selectedState!['state_id'],
        currencyId: selectedCurrency!['currency_id'],
      );

      await _authService.saveWelcomeMessage(formattedName);
      return null;
    } catch (e) {
      debugPrint('Error en registro social: $e');
      final msg = e.toString().toLowerCase();
      if (msg.contains('network') || msg.contains('connection')) return 'errorNetwork';
      return 'errorProfileUpdate';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
