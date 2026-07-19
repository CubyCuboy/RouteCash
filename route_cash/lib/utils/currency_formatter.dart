class CurrencyFormatter {
  /// Formatea un número como divisa, por ejemplo:
  /// 1240000 con showSign: true -> "+$1.240.000"
  /// -30000 -> "-$30.000"
  /// 24580 sin showSign -> "$24.580"
  static String format(num amount, {bool showSign = false}) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    
    final buffer = StringBuffer();
    if (showSign) {
      buffer.write(isNegative ? '-' : '+');
    } else if (isNegative) {
      buffer.write('-');
    }
    
    buffer.write('\$');
    
    // Formatear con puntos como separadores de miles
    final amountStr = absAmount.toInt().toString();
    final chars = amountStr.split('');
    final formattedChars = <String>[];
    int count = 0;
    
    for (int i = chars.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        formattedChars.add('.');
      }
      formattedChars.add(chars[i]);
      count++;
    }
    
    buffer.write(formattedChars.reversed.join(''));
    return buffer.toString();
  }
}
