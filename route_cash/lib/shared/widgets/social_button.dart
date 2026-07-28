import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialButton extends StatelessWidget {

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Widget? icon;
  final VoidCallback onPressed;
  final bool border;

  const SocialButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.icon,
    this.border = false,
  });


  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      height: 47,

      child: ElevatedButton(

        onPressed: onPressed,

        style: ElevatedButton.styleFrom(

          elevation: 0,

          backgroundColor: backgroundColor,

          foregroundColor: textColor,

          side: border
              ? const BorderSide(
                  color: Colors.white,
                )
              : null,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),

        ),


        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            if(icon != null) ...[

              icon!,

              const SizedBox(width: 12),

            ],


            Text(
              text,

              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),

            ),

          ],
        ),

      ),
    );
  }
}