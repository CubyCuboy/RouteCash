import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import 'main_navigation_screen.dart';

class AccountsSetupScreen extends StatelessWidget {
  const AccountsSetupScreen({super.key});

  void _connectBank(BuildContext context, AppLocalizations strings) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.bankConnectionMessage),
      ),
    );
  }

  void _addManually(BuildContext context, AppLocalizations strings) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.manualAccountMessage),
      ),
    );
  }

  void _skipForNow(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const MainNavigationScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

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
                  _BackButton(
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
                      strings.setupProgress,
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
                strings.yourAccountsLabel,
                style: GoogleFonts.inter(
                  color: const Color(0xFF999999),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                strings.accountsSetupTitle,
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
                strings.accountsSetupDescription,
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
                title: strings.horizonBank,
                subtitle: strings.connectSecurely,
                onPressed: () => _connectBank(context, strings),
              ),

              const SizedBox(height: 12),

              _AccountOptionCard(
                icon: Icons.add,
                title: strings.addManually,
                subtitle: strings.manualAccountTypes,
                dashedBorder: true,
                onPressed: () => _addManually(context, strings),
              ),

              const SizedBox(height: 36),

              _PrimaryButton(
                text: strings.skipForNow,
                onPressed: () => _skipForNow(context),
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

class DashedBorderPainter extends CustomPainter {
  DashedBorderPainter({
    required this.color,
    required this.radius,
  });

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(roundedRect);
    final metrics = path.computeMetrics();

    const dashWidth = 6.0;
    const dashSpace = 4.0;

    for (final metric in metrics) {
      double distance = 0;

      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(
            distance,
            distance + dashWidth,
          ),
          paint,
        );

        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 19),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFE2E2E2),
          ),
        ),
        child: const Icon(
          Icons.arrow_back,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }
}
