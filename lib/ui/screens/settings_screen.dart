import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../services/auth_service.dart';
import '../../main.dart';
import '../components/route_cash_buttons.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  bool _isDarkMode = false;

  void _signOut() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
  }

  void _changeLanguage(String languageCode) {
    RouteCashApp.setLocale(context, Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.navProfile.toUpperCase(),
                style: GoogleFonts.inter(
                  color: const Color(0xFF9D9D9D),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Ajustes',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.black,
                  fontSize: 48,
                  height: 0.88,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.8,
                ),
              ),
              const SizedBox(height: 42),
              
              _SettingsSection(
                title: 'APARIENCIA',
                children: [
                  _SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Modo Oscuro',
                    trailing: Switch(
                      value: _isDarkMode,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _SettingsSection(
                title: 'IDIOMA',
                children: [
                  _SettingsTile(
                    icon: Icons.language_outlined,
                    title: 'Español',
                    selected: currentLocale.languageCode == 'es',
                    onTap: () => _changeLanguage('es'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _SettingsTile(
                    icon: Icons.language_outlined,
                    title: 'English',
                    selected: currentLocale.languageCode == 'en',
                    onTap: () => _changeLanguage('en'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _SettingsSection(
                title: 'CUENTA',
                children: [
                  _SettingsTile(
                    icon: Icons.logout_rounded,
                    title: 'Cerrar Sesión',
                    titleColor: Colors.redAccent,
                    onTap: _signOut,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            color: const Color(0xFF999999),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color titleColor;
  final bool selected;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.titleColor = Colors.black,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.black, size: 22),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: titleColor,
        ),
      ),
      trailing: trailing ?? (selected ? const Icon(Icons.check, color: Colors.black, size: 20) : (onTap != null ? const Icon(Icons.chevron_right, size: 20) : null)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
