import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    
    final List<_Movement> movements = [
      _Movement(
        title: strings.movementElectricityPayment,
        date: strings.movementTodayAt('17:10'),
        amount: '\$-30.000',
      ),
      _Movement(
        title: strings.movementWaterPayment,
        date: strings.movementTodayAt('17:10'),
        amount: '\$-22.300',
      ),
      _Movement(
        title: strings.movementRentPayment,
        date: strings.movementTodayAt('17:10'),
        amount: '\$-500.000',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(strings),
              const SizedBox(height: 28),
              _buildBalanceCard(strings),
              const SizedBox(height: 24),
              _buildActivityHeader(strings),
              const SizedBox(height: 12),
              _buildMovements(movements),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations strings) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.homeGreeting('BENJA').toUpperCase(),
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
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE4E4E4)),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black,
              size: 23,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(AppLocalizations strings) {
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

  Widget _buildActivityHeader(AppLocalizations strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              strings.movementCountLabel(5),
              style: GoogleFonts.inter(
                color: const Color(0xFFA0A0A0),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: Colors.black,
              ),
              child: Text(
                strings.viewAll,
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

  Widget _buildMovements(List<_Movement> movements) {
    return Column(
      children: movements.map((movement) {
        return _MovementTile(movement: movement, onTap: () {});
      }).toList(),
    );
  }
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({required this.movement, required this.onTap});

  final _Movement movement;
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

class _Movement {
  const _Movement({
    required this.title,
    required this.date,
    required this.amount,
  });

  final String title;
  final String date;
  final String amount;
}
