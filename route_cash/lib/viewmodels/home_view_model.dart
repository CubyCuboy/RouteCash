import 'package:flutter/material.dart';
import '../models/movement.dart';

class HomeViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  final List<Movement> _movements = const [
    Movement(title: 'Pago de Luz', date: 'Hoy · 17:10', amount: '-\$30.000'),
    Movement(title: 'Pago de Agua', date: 'Hoy · 17:10', amount: '-\$22.300'),
    Movement(
      title: 'Pago de Arriendo',
      date: 'Hoy · 17:10',
      amount: '-\$500.000',
    ),
  ];

  List<Movement> get movements => _movements;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
