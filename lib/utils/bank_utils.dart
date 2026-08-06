import '../models/card_model.dart';

class BankCardDetails {
  final String bankName;
  final RouteCashCardType type;
  final String brand;
  final String? productName;

  const BankCardDetails({
    required this.bankName,
    required this.type,
    required this.brand,
    this.productName,
  });
}

class BankUtils {
  /// Identifica el banco, tipo y marca de forma precisa usando los primeros 6-8 dígitos (BIN)
  static BankCardDetails identifyCard(String cardNumber) {
    final clean = cardNumber.replaceAll(RegExp(r'\D'), '');
    
    // Si no hay suficientes números, damos una respuesta genérica
    if (clean.length < 6) {
      return BankCardDetails(
        bankName: 'Banco Emisor',
        type: RouteCashCardType.debit,
        brand: _getBrandBasic(clean),
      );
    }

    final bin = int.parse(clean.substring(0, 6));
    final brand = _getBrandBasic(clean);

    // Listado de BINs conocidos (especialmente enfocados en Chile por el contexto del proyecto)
    
    // BANCO ESTADO
    if (_inRanges(bin, [403831, 453661, 589562, 590777, 506700])) {
      return BankCardDetails(
        bankName: 'Banco Estado',
        type: _inRanges(bin, [590777, 506700]) ? RouteCashCardType.debit : RouteCashCardType.credit,
        brand: brand,
        productName: bin == 590777 ? 'Cuenta RUT' : 'Cuenta Corriente',
      );
    }

    // BANCO SANTANDER
    if (_inRanges(bin, [454562, 545454, 401662, 454561, 404368])) {
      return BankCardDetails(
        bankName: 'Banco Santander',
        type: bin == 454562 ? RouteCashCardType.debit : RouteCashCardType.credit,
        brand: brand,
      );
    }

    // BCI / MACH
    if (bin == 539744 || bin == 539743) {
      return BankCardDetails(
        bankName: 'MACH (Bci)',
        type: RouteCashCardType.debit,
        brand: brand,
        productName: 'Cuenta Digital',
      );
    }
    if (_inRanges(bin, [407944, 547246, 524040, 483861])) {
      return BankCardDetails(
        bankName: 'BCI',
        type: bin == 407944 ? RouteCashCardType.debit : RouteCashCardType.credit,
        brand: brand,
      );
    }

    // BANCO FALABELLA
    if (_inRanges(bin, [540683, 603277, 401569])) {
      return BankCardDetails(
        bankName: 'Banco Falabella',
        type: bin == 401569 ? RouteCashCardType.debit : RouteCashCardType.credit,
        brand: brand,
        productName: 'CMR Falabella',
      );
    }

    // SCOTIABANK
    if (_inRanges(bin, [455431, 544837, 402777, 483707])) {
      return BankCardDetails(
        bankName: 'Scotiabank',
        type: bin == 455431 ? RouteCashCardType.debit : RouteCashCardType.credit,
        brand: brand,
      );
    }

    // TENPO
    if (bin == 539525 || bin == 539526) {
      return BankCardDetails(
        bankName: 'Tenpo',
        type: RouteCashCardType.debit,
        brand: brand,
        productName: 'Cuenta Prepago',
      );
    }

    // ITAU
    if (_inRanges(bin, [402766, 548174, 442088])) {
      return BankCardDetails(
        bankName: 'Itaú',
        type: RouteCashCardType.credit,
        brand: brand,
      );
    }

    // BICE
    if (bin == 402237 || bin == 451381) {
      return BankCardDetails(
        bankName: 'Banco BICE',
        type: RouteCashCardType.credit,
        brand: brand,
      );
    }

    // Lógica por defecto basada en rangos estándar de industria si no es un BIN específico
    return BankCardDetails(
      bankName: 'Banco Emisor',
      type: _guessTypeByBrand(brand, clean),
      brand: brand,
    );
  }

  static bool _inRanges(int bin, List<int> list) => list.contains(bin);

  static String _getBrandBasic(String clean) {
    if (clean.startsWith('4')) return 'Visa';
    if (RegExp(r'^5[1-5]').hasMatch(clean)) return 'Mastercard';
    if (clean.startsWith('34') || clean.startsWith('37')) return 'American Express';
    if (clean.startsWith('6011') || clean.startsWith('65')) return 'Discover';
    return 'Tarjeta';
  }

  static RouteCashCardType _guessTypeByBrand(String brand, String clean) {
    // Algunas marcas suelen ser más de crédito o débito en ciertas regiones
    // Pero por defecto, si no sabemos el BIN, no podemos estar 100% seguros
    // Aquí implementamos una lógica de "mejor suposición"
    if (brand == 'American Express') return RouteCashCardType.credit;
    return RouteCashCardType.debit;
  }
}
