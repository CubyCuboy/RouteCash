import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RouteCashProgressBar extends StatelessWidget {
  final double progress;
  const RouteCashProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 4,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutExpo,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  // Animated highlight effect
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutExpo,
                    left: (constraints.maxWidth * progress) - 20,
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0),
                            Colors.white.withValues(alpha: 0.5),
                            Colors.white.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class RouteCashDesignCircle extends StatelessWidget {
  final double size;
  final double opacity;
  const RouteCashDesignCircle({super.key, required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.black.withValues(alpha: opacity),
            Colors.black.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

class RouteCashAnimatedBackground extends StatefulWidget {
  const RouteCashAnimatedBackground({super.key});

  @override
  State<RouteCashAnimatedBackground> createState() => _RouteCashAnimatedBackgroundState();
}

class _RouteCashAnimatedBackgroundState extends State<RouteCashAnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Círculo superior derecho
            Positioned(
              top: -120 + (40 * _controller.value),
              right: -80 - (50 * _controller.value),
              child: RouteCashDesignCircle(
                size: 400, 
                opacity: 0.05 + (0.02 * _controller.value)
              ),
            ),
            // Círculo inferior izquierdo
            Positioned(
              bottom: -100 - (60 * _controller.value),
              left: -150 + (80 * _controller.value),
              child: RouteCashDesignCircle(
                size: 550, 
                opacity: 0.04 + (0.01 * (1 - _controller.value))
              ),
            ),
            // Círculo central lateral
            Positioned(
              top: 300 + (100 * (1 - _controller.value)),
              right: -100 + (40 * _controller.value),
              child: const RouteCashDesignCircle(size: 250, opacity: 0.02),
            ),
          ],
        );
      },
    );
  }
}

class RouteCashLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  const RouteCashLoadingOverlay({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            color: Colors.white.withValues(alpha: 0.8 * value),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}

class RouteCashStepTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final Object animationKey;

  const RouteCashStepTitle({
    super.key,
    required this.title,
    required this.subtitle,
    required this.animationKey,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 900),
      reverseDuration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutQuart,
      switchOutCurve: Curves.easeInQuart,
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (child, animation) {
        final slideIn = Tween<Offset>(
          begin: const Offset(0.0, 0.4),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.2, 1.0, curve: Curves.easeOutQuart),
        ));

        final opacity = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 1.0, curve: Curves.linear),
        );

        return FadeTransition(
          opacity: opacity,
          child: SlideTransition(
            position: slideIn,
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey(animationKey),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              color: Colors.black,
              fontSize: 42,
              height: 1.05,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.8,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: const Color(0xFF888888),
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
