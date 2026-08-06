class CardUtils {
  /// Valida el número de tarjeta usando el algoritmo de Luhn
  static bool validateCardNumber(String input) {
    if (input.isEmpty) return false;
    
    input = input.replaceAll(RegExp(r'\D'), '');
    
    if (input.length < 13 || input.length > 19) return false;

    int sum = 0;
    bool alternate = false;
    for (int i = input.length - 1; i >= 0; i--) {
      int n = int.parse(input[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  /// Valida la fecha de expiración (MM/YY o MM/YYYY)
  static bool validateExpiryDate(String input) {
    if (input.isEmpty) return false;
    
    final clean = input.replaceAll(RegExp(r'\D'), '');
    if (clean.length != 4 && clean.length != 6) return false;

    int month = int.parse(clean.substring(0, 2));
    int year = int.parse(clean.substring(2));

    if (month < 1 || month > 12) return false;

    if (clean.length == 4) {
      year += 2000;
    }

    final now = DateTime.now();
    final lastDayOfMonth = DateTime(year, month + 1, 0);

    return lastDayOfMonth.isAfter(now);
  }

  /// Limpia el número de tarjeta (remueve espacios y guiones)
  static String getCleanNumber(String number) {
    return number.replaceAll(RegExp(r'\D'), '');
  }

  /// Retorna solo los últimos 4 dígitos
  static String getLastFourDigits(String number) {
    final clean = getCleanNumber(number);
    if (clean.length < 4) return clean.padLeft(4, '0');
    return clean.substring(clean.length - 4);
  }

  /// Detecta la marca de la tarjeta según el número
  static String getCardBrand(String number) {
    final clean = getCleanNumber(number);
    if (clean.startsWith('4')) return 'Visa';
    if (RegExp(r'^5[1-5]').hasMatch(clean)) return 'Mastercard';
    if (clean.startsWith('34') || clean.startsWith('37')) return 'American Express';
    if (clean.startsWith('6011') || clean.startsWith('65')) return 'Discover';
    return 'Tarjeta';
  }

  /// Formatea el número de tarjeta con espacios (1234 5678...)
  static String formatCardNumber(String input) {
    String clean = getCleanNumber(input);
    if (clean.length > 16) clean = clean.substring(0, 16);
    final buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(clean[i]);
    }
    return buffer.toString();
  }

  /// Formatea la fecha de expiración (MM/AA)
  static String formatExpiryDate(String input) {
    String clean = getCleanNumber(input);
    if (clean.length > 4) clean = clean.substring(0, 4);
    if (clean.length >= 3) {
      return '${clean.substring(0, 2)}/${clean.substring(2)}';
    }
    return clean;
  }
}
