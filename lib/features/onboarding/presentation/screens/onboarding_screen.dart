import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../auth/presentation/screens/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  void _openAuthScreen() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Deslizar hacia la izquierda.
          if ((details.primaryVelocity ?? 0) < -200) {
            _openAuthScreen();
          }
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  const Positioned.fill(child: OnboardingBackground()),

                  Positioned(
                    left: 28,
                    right: 28,
                    bottom: 88,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RouteCash',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 43,
                            height: 1,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tus finanzas en un\nsolo lugar',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            height: 1.45,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    left: 28,
                    bottom: 35,
                    child: Row(
                      children: [
                        _buildDot(isActive: true, onTap: () {}),
                        const SizedBox(width: 8),
                        _buildDot(isActive: false, onTap: _openAuthScreen),
                        const SizedBox(width: 8),
                        _buildDot(isActive: false, onTap: _openAuthScreen),
                      ],
                    ),
                  ),

                  Positioned(
                    right: 18,
                    bottom: 20,
                    child: TextButton(
                      onPressed: _openAuthScreen,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: Text(
                        'Continuar',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDot({required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.black : const Color(0xFFE1E1E1),
        ),
      ),
    );
  }
}

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: OnboardingPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class OnboardingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final lightBlobPaint = Paint()
      ..color = const Color(0xFFF1F1F1)
      ..style = PaintingStyle.fill;

    final blackBlobPaint = Paint()
      ..color = const Color(0xFF101010)
      ..style = PaintingStyle.fill;

    final smallLinePaint = Paint()
      ..color = const Color(0xFFAAAAAA)
      ..strokeWidth = 0.9
      ..strokeCap = StrokeCap.round;

    final dottedPaint = Paint()
      ..color = const Color(0xFFE3E3E3)
      ..style = PaintingStyle.fill;

    /*
      Forma gris superior izquierda.
    */
    final lightBlob = Path()
      ..moveTo(0, size.height * 0.055)
      ..cubicTo(
        size.width * 0.17,
        size.height * 0.01,
        size.width * 0.48,
        size.height * 0.05,
        size.width * 0.62,
        size.height * 0.16,
      )
      ..cubicTo(
        size.width * 0.72,
        size.height * 0.25,
        size.width * 0.58,
        size.height * 0.39,
        size.width * 0.39,
        size.height * 0.47,
      )
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.55,
        size.width * 0.03,
        size.height * 0.48,
        0,
        size.height * 0.40,
      )
      ..close();

    canvas.drawPath(lightBlob, lightBlobPaint);

    /*
      Forma negra superior derecha.
    */
    final blackBlob = Path()
      ..moveTo(size.width, size.height * 0.13)
      ..cubicTo(
        size.width * 0.90,
        size.height * 0.17,
        size.width * 0.82,
        size.height * 0.23,
        size.width * 0.65,
        size.height * 0.25,
      )
      ..cubicTo(
        size.width * 0.45,
        size.height * 0.27,
        size.width * 0.36,
        size.height * 0.35,
        size.width * 0.42,
        size.height * 0.42,
      )
      ..cubicTo(
        size.width * 0.51,
        size.height * 0.52,
        size.width * 0.68,
        size.height * 0.54,
        size.width * 0.78,
        size.height * 0.59,
      )
      ..cubicTo(
        size.width * 0.88,
        size.height * 0.64,
        size.width * 0.95,
        size.height * 0.66,
        size.width,
        size.height * 0.67,
      )
      ..close();

    canvas.drawPath(blackBlob, blackBlobPaint);

    /*
      Líneas diagonales del área gris.
    */
    const lineSpacingX = 14.0;
    const lineSpacingY = 16.0;

    for (
      double y = size.height * 0.12;
      y < size.height * 0.39;
      y += lineSpacingY
    ) {
      for (double x = 22; x < size.width * 0.68; x += lineSpacingX) {
        final normalizedX = x / size.width;
        final normalizedY = y / size.height;

        final insidePatternArea =
            normalizedX + normalizedY < 0.83 && normalizedY > 0.11;

        if (insidePatternArea) {
          canvas.drawLine(Offset(x, y + 4), Offset(x + 4, y), smallLinePaint);
        }
      }
    }

    /*
      Puntos blancos dentro de la forma negra.
    */
    for (double y = size.height * 0.31; y < size.height * 0.43; y += 13) {
      for (double x = size.width * 0.86; x < size.width; x += 13) {
        canvas.drawCircle(Offset(x, y), 1.1, Paint()..color = Colors.white);
      }
    }

    /*
      Puntos decorativos inferiores.
    */
    for (double y = size.height * 0.73; y < size.height * 0.93; y += 8) {
      for (double x = size.width * 0.67; x < size.width * 0.93; x += 8) {
        canvas.drawCircle(Offset(x, y), 0.7, dottedPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
