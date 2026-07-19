import 'package:flutter/material.dart';

class AccountsSetupViewModel extends ChangeNotifier {
  String connectBank() {
    return 'Aquí se abrirá la conexión bancaria';
  }

  String addManually() {
    return 'Aquí se abrirá el registro manual de una cuenta';
  }
}
