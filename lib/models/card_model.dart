enum RouteCashCardType { debit, credit }

class RouteCashCardModel {
  const RouteCashCardModel({
    required this.id,
    required this.bankName,
    required this.productName,
    required this.lastFourDigits,
    required this.availableAmount,
    required this.type,
    required this.assetPath,
    this.expiryDate,
  });

  final String id;
  final String bankName;
  final String productName;
  final String lastFourDigits;
  final double availableAmount;
  final RouteCashCardType type;
  final String assetPath;
  final String? expiryDate;

  RouteCashCardModel copyWith({
    String? id,
    String? bankName,
    String? productName,
    String? lastFourDigits,
    double? availableAmount,
    RouteCashCardType? type,
    String? assetPath,
    String? expiryDate,
  }) {
    return RouteCashCardModel(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      productName: productName ?? this.productName,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      availableAmount: availableAmount ?? this.availableAmount,
      type: type ?? this.type,
      assetPath: assetPath ?? this.assetPath,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bank_name': bankName,
      'product_name': productName,
      'last_four_digits': lastFourDigits,
      'available_amount': availableAmount,
      'type': type.name,
      'asset_path': assetPath,
      'expiry_date': expiryDate,
    };
  }

  factory RouteCashCardModel.fromJson(Map<String, dynamic> json) {
    return RouteCashCardModel(
      id: json['id'] as String,
      bankName: json['bank_name'] as String,
      productName: json['product_name'] as String,
      lastFourDigits: json['last_four_digits'] as String,
      availableAmount: (json['available_amount'] as num?)?.toDouble() ?? 0,
      type: json['type'] == RouteCashCardType.credit.name
          ? RouteCashCardType.credit
          : RouteCashCardType.debit,
      assetPath: json['asset_path'] as String? ?? '',
      expiryDate: json['expiry_date'] as String?,
    );
  }
}

