import 'package:flutter/material.dart';

import 'ui/screens/onboarding_screen.dart';

void main() {
  runApp(const RouteCashApp());
}

class RouteCashApp extends StatelessWidget {
  const RouteCashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RouteCash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const OnboardingScreen(),
    );
  }
}
