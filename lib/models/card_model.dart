enum RouteCashCardType {
  debit,
  credit,
}

class RouteCashCardModel {
  const RouteCashCardModel({
    required this.id,
    required this.bankName,
    required this.productName,
    required this.lastFourDigits,
    required this.availableAmount,
    required this.type,
    required this.assetPath,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
  });

  final String id;
  final String bankName;
  final String productName;
  final String lastFourDigits;
  final double availableAmount;
  final RouteCashCardType type;
  final String assetPath;
  final String? cardNumber;
  final String? expiryDate;
  final String? cvv;
}
