import 'package:flutter/material.dart';

import '../models/movement.dart';

class HomeViewModel extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  final List<Movement> _movements = [
    Movement(
      type: MovementType.electricityPayment,
      date: DateTime(2026, 7, 20, 17, 10),
      amount: -30000,
    ),
    Movement(
      type: MovementType.waterPayment,
      date: DateTime(2026, 7, 20, 17, 10),
      amount: -22300,
    ),
    Movement(
      type: MovementType.rentPayment,
      date: DateTime(2026, 7, 20, 17, 10),
      amount: -500000,
    ),
  ];

  List<Movement> get movements =>
      List.unmodifiable(_movements);

  void setSelectedIndex(int index) {
    if (_selectedIndex == index) {
      return;
    }

    _selectedIndex = index;
    notifyListeners();
  }
}