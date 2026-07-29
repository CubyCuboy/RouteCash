enum ExpenseCategoryType {
  shopping,
  housing,
  food,
  transport,
  services,
  entertainment,
}

class ExpenseCategory {
  const ExpenseCategory({
    required this.type,
    required this.percentage,
    required this.amount,
  });

  final ExpenseCategoryType type;
  final double percentage;
  final double amount;
}