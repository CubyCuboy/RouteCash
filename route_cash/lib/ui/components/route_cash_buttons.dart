import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RouteCashPrimaryButton extends StatelessWidget {
  const RouteCashPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 56,
    this.showArrow = true,
  });

  final String text;
  final VoidCallback onPressed;
  final double height;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: showArrow
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (showArrow) ...[
              const Spacer(),
              const Icon(
                Icons.arrow_forward,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.icon,
    this.border = false,
    this.borderColor = Colors.white,
    this.height = 47,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final Widget? icon;
  final bool border;
  final Color borderColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: border
                  ? Border.all(
                      color: borderColor,
                      width: 1,
                    )
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (icon != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: icon!,
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: icon != null ? 36 : 8,
                  ),
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  const SocialIcon({
    super.key,
    required this.assetPath,
    this.size = 20,
  });

  final String assetPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: size,
          height: size,
          child: Icon(
            Icons.image_not_supported_outlined,
            size: size,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black,
    this.borderColor,
    this.size = 48,
    this.iconSize = 22,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final Color? borderColor;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: CircleBorder(
        side: borderColor != null
            ? BorderSide(
                color: borderColor!,
                width: 1,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}