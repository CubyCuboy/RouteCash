import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'ui/screens/auth_screen.dart';

void main() {
  runApp(const RouteCashApp());
}

class RouteCashApp extends StatelessWidget {
  const RouteCashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      onGenerateTitle: (context) {
      return AppLocalizations.of(context)!.appName;
      },

      localizationsDelegates:
          AppLocalizations.localizationsDelegates,

      supportedLocales:
          AppLocalizations.supportedLocales,

      home: const AuthScreen(),
    );
  }
}