import 'package:flutter/material.dart';
import '../models/expense_category.dart';

class ReportViewModel extends ChangeNotifier {
  int _selectedIndex = 1;
  int get selectedIndex => _selectedIndex;

  String _selectedMonth = 'Julio 2026';
  String get selectedMonth => _selectedMonth;

  final List<String> _months = const [
    'Julio 2026',
    'Junio 2026',
    'Mayo 2026',
  ];
  List<String> get months => _months;

  final double _monthlyBalance = 1240000;
  double get monthlyBalance => _monthlyBalance;

  final String _balanceComparison = '18% más que junio';
  String get balanceComparison => _balanceComparison;

  final List<double> _weeklyExpenses = const [0.42, 0, 0.13, 0.20, 0.23, 0.25, 0.28];
  List<double> get weeklyExpenses => _weeklyExpenses;

  final List<double> _weeklyIncomes = const [0.96, 0.56, 0.30, 0.26, 0.51, 0.33, 0.24];
  List<double> get weeklyIncomes => _weeklyIncomes;

  final List<ExpenseCategory> _categories = const [
    ExpenseCategory(name: 'Compras', percentage: 0.32, amount: '\$280.000'),
    ExpenseCategory(name: 'Vivienda', percentage: 0.27, amount: '\$235.000'),
    ExpenseCategory(name: 'Alimentación', percentage: 0.18, amount: '\$157.000'),
    ExpenseCategory(name: 'Transporte', percentage: 0.12, amount: '\$104.000'),
    ExpenseCategory(name: 'Servicios', percentage: 0.07, amount: '\$61.000'),
    ExpenseCategory(name: 'Entretenimiento', percentage: 0.04, amount: '\$35.000'),
  ];
  List<ExpenseCategory> get categories => _categories;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void selectMonth(String month) {
    if (_selectedMonth != month) {
      _selectedMonth = month;
      notifyListeners();
    }
  }
}
