import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';
import '../../services/auth_service.dart';
import 'home_screen.dart';
import 'report_screen.dart';
import 'cards_screen.dart';
import 'settings_screen.dart';
import 'social_registration_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  static bool popTabHistory(BuildContext context) {
    final state = context.findAncestorStateOfType<_MainNavigationScreenState>();
    return state?.popTab() ?? false;
  }

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _selectedIndex;
  final List<int> _navigationHistory = [];
  bool _isCheckingProfile = true;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _checkProfileIntegrity();
  }

  Future<void> _checkProfileIntegrity() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final authService = AuthService();
    final profile = await authService.getUserProfile(user.id);

    if (!mounted) return;

    if (profile == null) {
      // Perfil incompleto detectado. Redirigir a completar registro.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SocialRegistrationScreen()),
        (route) => false,
      );
    } else {
      setState(() => _isCheckingProfile = false);
    }
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const ReportScreen(),
    const CardsScreen(),
    const SettingsScreen(),
  ];

  void _onNavigationTap(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _navigationHistory.add(_selectedIndex);
        _selectedIndex = index;
      });
    }
  }

  bool popTab() {
    if (_navigationHistory.isNotEmpty) {
      setState(() {
        _selectedIndex = _navigationHistory.removeLast();
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingProfile) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return PopScope(
      canPop: _navigationHistory.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        popTab();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: _buildBottomNavigation(),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final strings = AppLocalizations.of(context)!;

    return SafeArea(
      bottom: true,
      child: Container(
        height: 72,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            _navItem(0, Icons.home_outlined, Icons.home_rounded, strings.navHome),
            _navItem(1, Icons.north_east_rounded, Icons.north_east_rounded, strings.navMovements),
            _navItem(2, Icons.credit_card_outlined, Icons.credit_card_rounded, strings.navCards),
            _navItem(3, Icons.tune_rounded, Icons.tune_rounded, strings.navProfile),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onNavigationTap(index),
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(29),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? Colors.black : const Color(0xFFA9A9A9),
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.black : const Color(0xFFA9A9A9),
                  fontSize: 8,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
