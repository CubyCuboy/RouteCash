import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'l10n/app_localizations.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/main_navigation_screen.dart';
import 'ui/screens/images.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const RouteCashApp());
}

class RouteCashApp extends StatefulWidget {
  const RouteCashApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _RouteCashAppState? state = context.findAncestorStateOfType<_RouteCashAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<RouteCashApp> createState() => _RouteCashAppState();
}

class _RouteCashAppState extends State<RouteCashApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appName;
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: session != null ? const MainNavigationScreen() : const OnboardingScreen(),
    );
  }
}
