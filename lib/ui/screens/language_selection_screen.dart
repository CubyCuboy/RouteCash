import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../components/route_cash_buttons.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {

  void _confirmChange(String newCode) async {
    final currentLocale = Localizations.localeOf(context);
    final currentCode = currentLocale.languageCode;
    
    if (currentCode == newCode) {
      Navigator.pop(context);
      return;
    }

    final bool? proceed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        String title = '¿Cambiar idioma?';
        String message = '';
        String yesText = 'Sí / Yes';
        String noText = 'No';

        if (newCode == 'es') {
          message = 'El idioma cambiará a Español.';
          yesText = 'Sí';
        } else if (newCode == 'en') {
          message = 'Language will change to English.';
          yesText = 'Yes';
        } else if (newCode == 'pt') {
          message = 'O idioma mudará para Português.';
          yesText = 'Sim';
        }

        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: RouteCashPrimaryButton(
                          text: noText,
                          backgroundColor: Colors.grey[200]!,
                          textColor: Colors.black,
                          showArrow: false,
                          onPressed: () => Navigator.pop(context, false),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RouteCashPrimaryButton(
                          text: yesText,
                          showArrow: false,
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (proceed == true) {
      if (!mounted) return;
      
      // Animación de transición personalizada
      // Usamos el context del Navigator para asegurar que el pop funcione
      final navigator = Navigator.of(context);

      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, anim1, anim2) {
          return FadeTransition(
            opacity: anim1,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        },
      );

      await Future.delayed(const Duration(milliseconds: 1000));
      
      if (!mounted) return;
      
      // Cambiamos el idioma
      RouteCashApp.setLocale(context, Locale(newCode));
      
      // Esperamos un momento para que el rebuild ocurra y luego cerramos todo
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        // Cerramos el diálogo de carga y volvemos a settings
        // Usamos popUntil para limpiar la pila si es necesario, o simplemente dos pops
        navigator.pop(); // Cierra el diálogo
        navigator.pop(); // Vuelve a settings
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final systemLocale = PlatformDispatcher.instance.locale;
    final isSystemSupported = systemLocale.languageCode == 'es' || 
                               systemLocale.languageCode == 'en' || 
                               systemLocale.languageCode == 'pt';

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'IDIOMA',
          style: GoogleFonts.inter(
            color: const Color(0xFF9D9D9D),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              currentLocale.languageCode == 'es' ? 'Selecciona tu idioma' : 
              currentLocale.languageCode == 'pt' ? 'Selecione seu idioma' : 'Select your language',
              style: GoogleFonts.playfairDisplay(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.w700,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 40),
            if (isSystemSupported) ...[
               _LanguageTile(
                title: currentLocale.languageCode == 'es' ? 'Idioma del sistema' : 
                       currentLocale.languageCode == 'pt' ? 'Idioma do sistema' : 'System language',
                subtitle: systemLocale.languageCode == 'es' ? 'Español' : 
                          systemLocale.languageCode == 'pt' ? 'Português' : 'English',
                isSelected: false,
                onTap: () => _confirmChange(systemLocale.languageCode),
              ),
              const SizedBox(height: 16),
            ],
            _LanguageTile(
              title: 'Español',
              subtitle: 'Spanish',
              isSelected: currentLocale.languageCode == 'es',
              onTap: () => _confirmChange('es'),
            ),
            const SizedBox(height: 16),
            _LanguageTile(
              title: 'English',
              subtitle: 'Inglés',
              isSelected: currentLocale.languageCode == 'en',
              onTap: () => _confirmChange('en'),
            ),
            const SizedBox(height: 16),
            _LanguageTile(
              title: 'Português',
              subtitle: 'Portuguese',
              isSelected: currentLocale.languageCode == 'pt',
              onTap: () => _confirmChange('pt'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFE5E5E5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.black)
            else
              const Icon(Icons.circle_outlined, color: Color(0xFFE5E5E5)),
          ],
        ),
      ),
    );
  }
}
