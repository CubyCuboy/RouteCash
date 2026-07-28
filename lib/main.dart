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
//'''se creo la carpeta de login_screen.dart y se creo la clase LoginScreen que es un StatefulWidget que contiene un formulario de inicio de sesión con campos de correo electrónico y contraseña, así como botones para iniciar sesión, recuperar contraseña y registrarse. También se implementa la funcionalidad de mostrar u ocultar la contraseña y navegar entre pantallas'''