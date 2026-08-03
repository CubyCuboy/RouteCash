import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/email_validator.dart';
import '../../viewmodels/settings_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import 'otp_verification_screen.dart';

class ChangeEmailScreen extends StatefulWidget {
  final SettingsViewModel viewModel;
  const ChangeEmailScreen({super.key, required this.viewModel});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _oldEmailController = TextEditingController();
  final _newEmailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldEmailController.dispose();
    _newEmailController.dispose();
    super.dispose();
  }

  void _initiateChange() async {
    final oldEmail = _oldEmailController.text.trim();
    final newEmail = _newEmailController.text.trim();

    if (oldEmail.isEmpty || newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorUnexpected)),
      );
      return;
    }

    if (!EmailValidator.isValid(newEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.invalidEmail)),
      );
      return;
    }

    setState(() => _isLoading = true);
    final lang = Localizations.localeOf(context).languageCode;
    final err = await widget.viewModel.initiateEmailChange(oldEmail, newEmail, lang);

    if (mounted) {
      setState(() => _isLoading = false);
      if (err == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(
              userId: widget.viewModel.userId,
              email: newEmail,
              purpose: 'change_email',
              password: '',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

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
          strings.changeEmail.toUpperCase(),
          style: GoogleFonts.inter(
            color: const Color(0xFF9D9D9D),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.changeEmail,
              style: GoogleFonts.playfairDisplay(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.w700,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ingresa tu correo actual y la nueva dirección donde deseas recibir tus notificaciones.',
              style: GoogleFonts.inter(
                color: const Color(0xFF999999),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            RouteCashTextField(
              label: strings.currentEmail,
              controller: _oldEmailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'ejemplo@correo.com',
            ),
            const SizedBox(height: 24),
            RouteCashTextField(
              label: strings.newEmail,
              controller: _newEmailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'nuevo@correo.com',
            ),
            const SizedBox(height: 48),
            RouteCashPrimaryButton(
              text: strings.update,
              isLoading: _isLoading,
              onPressed: _initiateChange,
            ),
          ],
        ),
      ),
    );
  }
}
