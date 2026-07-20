enum MovementType {
  electricityPayment,
  waterPayment,
  rentPayment,
}

class Movement {
  const Movement({
    required this.type,
    required this.date,
    required this.amount,
  });

  final MovementType type;
  final DateTime date;
  final double amount;
}