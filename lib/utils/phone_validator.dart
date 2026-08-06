class PhoneValidator {
  static final RegExp _numericRegExp = RegExp(r'^[0-9]+$');

  /// Valida si el número de teléfono es válido si se proporciona
  static bool isValid(String? phone) {
    if (phone == null || phone.trim().isEmpty) return true;
    final trimmed = phone.trim();
    
    // Longitud estándar internacional: entre 7 y 15 dígitos
    return _numericRegExp.hasMatch(trimmed) && trimmed.length >= 7 && trimmed.length <= 15;
  }

  /// Limpia el número dejando solo dígitos
  static String clean(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9]'), '');
  }
}
