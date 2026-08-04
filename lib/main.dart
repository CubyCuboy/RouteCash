import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'l10n/app_localizations.dart';
import 'ui/screens/main_navigation_screen.dart';
import 'ui/screens/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const RouteCashApp());
}

class RouteCashApp extends StatefulWidget {
  const RouteCashApp({super.key});

  static void setLocale(
    BuildContext context,
    Locale newLocale,
  ) {
    final state =
        context.findAncestorStateOfType<_RouteCashAppState>();

    state?.setLocale(newLocale);
  }

  @override
  State<RouteCashApp> createState() =>
      _RouteCashAppState();
}

class _RouteCashAppState extends State<RouteCashApp> {
  Locale? _locale;

  Session? _session;

  bool _authInitialized = false;

  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();

    final supabase = Supabase.instance.client;

    _session = supabase.auth.currentSession;
    _authInitialized = true;

    _authSubscription =
    Supabase.instance.client.auth.onAuthStateChange.listen(
  (authState) {
    if (!mounted) {
      return;
    }

    debugPrint('Auth event: ${authState.event}');
    debugPrint(
      'Usuario: ${authState.session?.user.email ?? "sin sesión"}',
    );

    switch (authState.event) {
      case AuthChangeEvent.initialSession:
      case AuthChangeEvent.signedIn:
      case AuthChangeEvent.tokenRefreshed:
      case AuthChangeEvent.userUpdated:
        setState(() {
          _session = authState.session;
          _authInitialized = true;
        });
        break;

      case AuthChangeEvent.signedOut:
      case AuthChangeEvent.userDeleted:
        setState(() {
          _session = null;
          _authInitialized = true;
        });
        break;

      default:
        break;
    }
  },
  onError: (Object error, StackTrace stackTrace) {
    debugPrint('Error en authStateChange: $error');
  },
);

  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appName;
      },
      localizationsDelegates:
          AppLocalizations.localizationsDelegates,
      supportedLocales:
          AppLocalizations.supportedLocales,
      home: !_authInitialized
          ? const _AuthLoadingScreen()
          : _session != null
              ? const MainNavigationScreen()
              : const OnboardingScreen(),
    );
  }
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}