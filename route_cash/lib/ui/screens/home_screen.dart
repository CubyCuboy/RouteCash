import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/movement.dart';
import '../../viewmodels/home_view_model.dart';
import '../components/route_cash_buttons.dart';
import 'report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _onNavigationTap(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ReportScreen()),
      );
      return;
    }

    _viewModel.setSelectedIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 28),
                        _buildBalanceCard(),
                        const SizedBox(height: 24),
                        _buildActivityHeader(),
                        const SizedBox(height: 12),
                        _buildMovements(),
                      ],
                    ),
                  ),
                ),
                _buildBottomNavigation(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HOLA, bENJAJAA',
                style: GoogleFonts.inter(
                  color: const Color(0xFF969696),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tu ruta',
                style: GoogleFonts.dmSerifDisplay(
                  color: Colors.black,
                  fontSize: 39,
                  height: 0.95,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -1.3,
                ),
              ),
            ],
          ),
        ),
        CircleIconButton(
          icon: Icons.notifications_none_rounded,
          onPressed: () {},
          size: 46,
          iconSize: 23,
          backgroundColor: Colors.white,
          borderColor: const Color(0xFFE4E4E4),
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      height: 176,
      padding: const EdgeInsets.fromLTRB(23, 24, 23, 21),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(27),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SALDO DISPONIBLE',
            style: GoogleFonts.inter(
              color: const Color(0xFF8E8E8E),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '\$24.580',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 60,
              height: 1,
              fontWeight: FontWeight.w400,
              letterSpacing: -1,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                '•••• 3940',
                style: GoogleFonts.inter(
                  color: const Color(0xFF999999),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                'VISA',
                style: GoogleFonts.inter(
                  color: const Color(0xFF999999),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '05 / MOVIMIENTO',
              style: GoogleFonts.inter(
                color: const Color(0xFFA0A0A0),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => _onNavigationTap(1),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: Colors.black,
              ),
              child: Text(
                'Ver todo',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationThickness: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Resumen de actividad',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMovements() {
    return Column(
      children: _viewModel.movements.map((movement) {
        return _MovementTile(movement: movement, onTap: () {});
      }).toList(),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: _BottomNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Inicio',
              selected: _viewModel.selectedIndex == 0,
              onTap: () => _onNavigationTap(0),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.north_east_rounded,
              activeIcon: Icons.north_east_rounded,
              label: 'Movimientos',
              selected: _viewModel.selectedIndex == 1,
              onTap: () => _onNavigationTap(1),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.credit_card_outlined,
              activeIcon: Icons.credit_card_rounded,
              label: 'Tarjetas',
              selected: _viewModel.selectedIndex == 2,
              onTap: () => _onNavigationTap(2),
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.tune_rounded,
              activeIcon: Icons.tune_rounded,
              label: 'Perfil',
              selected: _viewModel.selectedIndex == 3,
              onTap: () => _onNavigationTap(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({required this.movement, required this.onTap});

  final Movement movement;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 67,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE8E8E8))),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: Color(0xFF444444),
                size: 19,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movement.title,
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    movement.date,
                    style: GoogleFonts.roboto(
                      color: const Color(0xFFB1B1B1),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              movement.amount,
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: 58,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(29),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? activeIcon : icon,
              color: selected ? Colors.black : const Color(0xFFA9A9A9),
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: selected ? Colors.black : const Color(0xFFA9A9A9),
                fontSize: 8,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
