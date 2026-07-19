import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodels/accounts_setup_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_painters.dart';
import 'home_screen.dart';

class AccountsSetupScreen extends StatefulWidget {
  const AccountsSetupScreen({super.key});

  @override
  State<AccountsSetupScreen> createState() => _AccountsSetupScreenState();
}

class _AccountsSetupScreenState extends State<AccountsSetupScreen> {
  late final AccountsSetupViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AccountsSetupViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _connectBank() {
    final message = _viewModel.connectBank();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _addManually() {
    final message = _viewModel.addManually();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _skipForNow() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 20, 32, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      '3 / 3',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 38),

              Text(
                'TUS CUENTAS',
                style: GoogleFonts.inter(
                  color: const Color(0xFF999999),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Lo importante,\nreunido.',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.black,
                  fontSize: 47,
                  height: 0.86,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.7,
                ),
              ),

              const SizedBox(height: 22),

              Text(
                'Conecta una cuenta o agrégala manualmente.\n'
                'Siempre podrás hacerlo después.',
                style: GoogleFonts.inter(
                  color: const Color(0xFF999999),
                  fontSize: 13,
                  height: 1.45,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 34),

              _AccountOptionCard(
                icon: Icons.account_balance,
                title: 'Banco Horizonte',
                subtitle: 'Conectar de forma segura',
                onPressed: _connectBank,
              ),

              const SizedBox(height: 12),

              _AccountOptionCard(
                icon: Icons.add,
                title: 'Agregar manualmente',
                subtitle: 'Efectivo, tarjeta o inversión',
                dashedBorder: true,
                onPressed: _addManually,
              ),

              const SizedBox(height: 36),

              RouteCashPrimaryButton(
                text: 'hola guille cambiar',
                onPressed: _skipForNow,
                height: 55,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountOptionCard extends StatelessWidget {
  const _AccountOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    this.dashedBorder = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final bool dashedBorder;

  @override
  Widget build(BuildContext context) {
    final card = InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(16),
          border: dashedBorder
              ? null
              : Border.all(
                  color: const Color(0xFFE1E1E1),
                  width: 1,
                ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF555555),
                size: 21,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFAAAAAA),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (!dashedBorder) {
      return card;
    }

    return CustomPaint(
      painter: DashedBorderPainter(
        color: const Color(0xFFD2D2D2),
        radius: 16,
      ),
      child: card,
    );
  }
}
