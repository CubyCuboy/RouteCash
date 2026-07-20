import 'package:flutter/material.dart';

import '../models/expense_category.dart';

class ReportViewModel extends ChangeNotifier {
  int _selectedIndex = 1;

  int get selectedIndex => _selectedIndex;

  DateTime _selectedMonth = DateTime(2026, 7);

  DateTime get selectedMonth => _selectedMonth;

  final List<DateTime> _months = [
    DateTime(2026, 7),
    DateTime(2026, 6),
    DateTime(2026, 5),
  ];

  List<DateTime> get months => List.unmodifiable(_months);

  final double _monthlyBalance = 1240000;

  double get monthlyBalance => _monthlyBalance;

  final double _balanceComparisonPercentage = 18;

  double get balanceComparisonPercentage => _balanceComparisonPercentage;

  final DateTime _comparisonMonth = DateTime(2026, 6);

  DateTime get comparisonMonth => _comparisonMonth;

  final List<double> _weeklyExpenses = const [
    0.42,
    0,
    0.13,
    0.20,
    0.23,
    0.25,
    0.28,
  ];

  List<double> get weeklyExpenses => List.unmodifiable(_weeklyExpenses);

  final List<double> _weeklyIncomes = const [
    0.96,
    0.56,
    0.30,
    0.26,
    0.51,
    0.33,
    0.24,
  ];

  List<double> get weeklyIncomes => List.unmodifiable(_weeklyIncomes);

  final List<ExpenseCategory> _categories = const [
    ExpenseCategory(
      type: ExpenseCategoryType.shopping,
      percentage: 0.32,
      amount: 280000,
    ),
    ExpenseCategory(
      type: ExpenseCategoryType.housing,
      percentage: 0.27,
      amount: 235000,
    ),
    ExpenseCategory(
      type: ExpenseCategoryType.food,
      percentage: 0.18,
      amount: 157000,
    ),
    ExpenseCategory(
      type: ExpenseCategoryType.transport,
      percentage: 0.12,
      amount: 104000,
    ),
    ExpenseCategory(
      type: ExpenseCategoryType.services,
      percentage: 0.07,
      amount: 61000,
    ),
    ExpenseCategory(
      type: ExpenseCategoryType.entertainment,
      percentage: 0.04,
      amount: 35000,
    ),
  ];

  List<ExpenseCategory> get categories => List.unmodifiable(_categories);

  void setSelectedIndex(int index) {
    if (_selectedIndex == index) {
      return;
    }

    _selectedIndex = index;
    notifyListeners();
  }

  void selectMonth(DateTime month) {
    final sameMonth =
        _selectedMonth.year == month.year &&
        _selectedMonth.month == month.month;

    if (sameMonth) {
      return;
    }

    _selectedMonth = month;
    notifyListeners();
  }
}
