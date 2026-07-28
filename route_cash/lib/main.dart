import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:routecash/features/auth/presentation/screens/auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gpufgmlpbpydojnvgwid.supabase.co',
    publishableKey: 'sb_publishable_0UCUj_fWHU4-O8l6ZRAb3A_fEJECZsE',
  );

  runApp(const RouteCashApp());
}

class RouteCashApp extends StatelessWidget {
  const RouteCashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RouteCash',
      debugShowCheckedModeBanner: false,
      home: const AuthScreen(),
    );
  }
}