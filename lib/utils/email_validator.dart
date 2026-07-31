class EmailValidator {
  /// Expresión regular para validar el formato de correo electrónico
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&'
    r"'"
    r'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
  );

  /// Valida si el formato del correo es correcto
  static bool isValid(String? email) {
    if (email == null || email.isEmpty) return false;
    return _emailRegExp.hasMatch(email.trim());
  }

  /// Limpia y normaliza el correo electrónico (trim y minúsculas)
  static String normalize(String email) {
    return email.trim().toLowerCase();
  }
}
