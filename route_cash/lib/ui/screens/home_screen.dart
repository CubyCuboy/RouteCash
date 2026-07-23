import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../l10n/app_localizations.dart';
import '../../models/movement.dart';
import '../../viewmodels/home_view_model.dart';
import '../../services/auth_service.dart';
import '../components/route_cash_buttons.dart';
import 'accounts_setup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;
  final AuthService _authService = AuthService();
  String _userName = '...';

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await _authService.getWelcomeMessage();
    if (mounted && name != null) {
      setState(() {
        _userName = name;
      });
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  // ... (keep _getMovementTitle, _formatMovementDate, _formatMovementAmount methods)
  String _getMovementTitle(
    AppLocalizations strings,
    MovementType type,
  ) {
    switch (type) {
      case MovementType.electricityPayment:
        return strings.movementElectricityPayment;

      case MovementType.waterPayment:
        return strings.movementWaterPayment;

      case MovementType.rentPayment:
        return strings.movementRentPayment;
    }
  }

  String _formatMovementDate(
    BuildContext context,
    AppLocalizations strings,
    DateTime date,
  ) {
    final locale =
        Localizations.localeOf(context).toLanguageTag();

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final movementDay = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final difference =
        today.difference(movementDay).inDays;

    final formattedTime = DateFormat.jm(
      locale,
    ).format(date);

    if (difference == 0) {
      return strings.movementTodayAt(formattedTime);
    }

    if (difference == 1) {
      return strings.movementYesterdayAt(formattedTime);
    }

    return DateFormat.yMMMd(locale)
        .add_jm()
        .format(date);
  }

  String _formatMovementAmount(
    BuildContext context,
    double amount,
  ) {
    final locale =
        Localizations.localeOf(context).toLanguageTag();

    final formattedAmount = NumberFormat.currency(
      locale: locale,
      symbol: '\$',
      decimalDigits: 0,
    ).format(amount.abs());

    if (amount < 0) {
      return '-$formattedAmount';
    }

    if (amount > 0) {
      return '+$formattedAmount';
    }

    return formattedAmount;
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
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 100), // More padding for nav
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final strings = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.homeGreeting(_userName),
                style: GoogleFonts.inter(
                  color: const Color(0xFF969696),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                strings.homeYourRoute,
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
  // ... (keep _buildBalanceCard, _buildActivityHeader, _buildMovements)
  Widget _buildBalanceCard() {
    final strings = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      height: 176,
      padding: const EdgeInsets.fromLTRB(
        23,
        24,
        23,
        21,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(27),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.availableBalanceLabel,
            style: GoogleFonts.inter(
              color: const Color(0xFF8E8E8E),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            _formatMovementAmount(
              context,
              24580,
            ),
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
    final strings = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              strings.movementCountLabel(
                _viewModel.movements.length,
              ),
              style: GoogleFonts.inter(
                color: const Color(0xFFA0A0A0),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (_) => const AccountsSetupScreen()),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                foregroundColor: Colors.black,
              ),
              child: Text(
                'Añadir Banco',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  decoration:
                      TextDecoration.underline,
                  decorationThickness: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          strings.activitySummary,
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
    final strings = AppLocalizations.of(context)!;

    return Column(
      children: _viewModel.movements.map((movement) {
        return _MovementTile(
          title: _getMovementTitle(
            strings,
            movement.type,
          ),
          date: _formatMovementDate(
            context,
            strings,
            movement.date,
          ),
          amount: _formatMovementAmount(
            context,
            movement.amount,
          ),
          onTap: () {},
        );
      }).toList(),
    );
  }
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({
    required this.title,
    required this.date,
    required this.amount,
    required this.onTap,
  });

  final String title;
  final String date;
  final String amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 67,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFE8E8E8),
            ),
          ),
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
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    date,
                    style: GoogleFonts.roboto(
                      color:
                          const Color(0xFFB1B1B1),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
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
