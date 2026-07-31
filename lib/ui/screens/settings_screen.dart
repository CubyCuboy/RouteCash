import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';
import '../../services/verification_service.dart';
import '../../viewmodels/settings_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';
import '../components/route_cash_dropdown.dart';
import 'auth_screen.dart';
import 'otp_verification_screen.dart';
import 'language_selection_screen.dart';
import 'change_email_screen.dart';
import 'link_email_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _viewModel = SettingsViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _signOut() async {
    await _viewModel.syncAndSignOut();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
  }

  void _changeLanguage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
    );
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => _ProfileEditSheet(viewModel: _viewModel),
    );
  }

  void _changeSecurity(String type) async {
    final outerContext = context;
    final strings = AppLocalizations.of(context)!;

    if (type == 'password') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        builder: (sheetContext) => _ResetPasswordInfoSheet(
          onConfirm: () async {
            Navigator.pop(sheetContext);
            final user = Supabase.instance.client.auth.currentUser;
            if (user != null && user.email != null) {
              showDialog(
                context: outerContext,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );

              final lang = Localizations.localeOf(outerContext).languageCode;
              final service = VerificationService();
              final result = await service.sendOtp(
                userId: user.id,
                email: user.email!,
                purpose: 'recovery',
                lang: lang,
              );

              if (!mounted) return;
              Navigator.pop(outerContext);

              if (result['success'] == true) {
                Navigator.push(
                  outerContext,
                  MaterialPageRoute(
                    builder: (_) => OtpVerificationScreen(
                      userId: user.id,
                      email: user.email!,
                      purpose: 'recovery',
                      password: '',
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(outerContext).showSnackBar(
                  SnackBar(content: Text(result['error'] ?? strings.errorUnexpected)),
                );
              }
            }
          },
        ),
      );
      return;
    }

    if (type == 'email') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeEmailScreen(viewModel: _viewModel),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => _SecurityEditSheet(viewModel: _viewModel, type: type),
    );
  }

  void _showAddPasswordSheet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LinkEmailPasswordScreen(
          initialEmail: _viewModel.userProfile?['email'],
        ),
      ),
    );
  }

  void _verifyPhone() {
    if (_viewModel.userProfile?['phone'] == null || _viewModel.userProfile!['phone'].toString().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero agrega un número de teléfono')),
      );
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(
          userId: _viewModel.userProfile!['user_id'],
          email: _viewModel.userProfile!['email'],
          purpose: 'verify_phone',
          password: '',
        ),
      ),
    );
  }

  void _linkGoogle() async {
    final strings = AppLocalizations.of(context)!;
    try {
      await _viewModel.linkAccount(OAuthProvider.google);
      await _viewModel.loadData();
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(strings.successLinking),
            content: Text(strings.successLinkingMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(strings.confirm),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e is AuthException ? e.message : '${strings.errorUnexpected}: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _unlinkGoogle() async {
    final strings = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.unlinkAccountTitle),
        content: Text(strings.unlinkAccountMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(strings.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(strings.unlink, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _viewModel.unlinkAccount('google');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(strings.unlinkAccountTitle)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${strings.errorUnexpected}: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            if (_viewModel.isLoading && _viewModel.userProfile == null) {
              return const Center(child: CircularProgressIndicator(color: Colors.black));
            }

            final profile = _viewModel.userProfile;
            final settings = _viewModel.userSettings;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(26, 24, 26, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        strings.settingsLabel,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF9D9D9D),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                      if (!_viewModel.isEmailVerified)
                        _Badge(
                          text: strings.verifyingEmailBadge,
                          color: Colors.orange,
                          onTap: () {  },
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    strings.settingsTitle,
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.black,
                      fontSize: 42,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  _ProfileHeader(
                    fullName: profile?['full_name'] ?? 'Usuario',
                    email: profile?['email'] ?? '',
                    onEdit: _editProfile,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  _SettingsSection(
                    title: strings.accountLinking,
                    children: [
                      _SettingsTile(
                        icon: Icons.g_mobiledata,
                        title: 'Google',
                        trailing: _viewModel.isProviderLinked('google') 
                          ? Text(strings.changeAccount, style: const TextStyle(color: Color(0xFF1473E6), fontSize: 12))
                          : Text(strings.link, style: const TextStyle(color: Color(0xFF1473E6), fontSize: 12)),
                        onTap: _viewModel.isProviderLinked('google') ? _unlinkGoogle : _linkGoogle,
                      ),
                      const Divider(height: 1, indent: 16),
                      _SettingsTile(
                        icon: Icons.window,
                        title: 'Microsoft',
                        trailing: _viewModel.isProviderLinked('azure')
                          ? Text(strings.linked, style: const TextStyle(color: Colors.green, fontSize: 12))
                          : Text(strings.link, style: const TextStyle(color: Color(0xFF1473E6), fontSize: 12)),
                        onTap: _viewModel.isProviderLinked('azure') ? null : () => _viewModel.linkAccount(OAuthProvider.azure),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  _SettingsSection(
                    title: strings.security,
                    children: [
                      _SettingsTile(
                        icon: Icons.phone_android_outlined,
                        title: strings.verifyPhone,
                        trailing: _viewModel.isPhoneVerified
                          ? const Icon(Icons.check_circle, color: Colors.green, size: 18)
                          : Text(strings.notVerified, style: const TextStyle(color: Colors.orange, fontSize: 12)),
                        onTap: _viewModel.isPhoneVerified ? null : _verifyPhone,
                      ),
                      const Divider(height: 1, indent: 16),
                      if (_viewModel.hasEmailPasswordAuth) ...[
                        _SettingsTile(
                          icon: Icons.lock_outline,
                          title: strings.changePassword,
                          onTap: () => _changeSecurity('password'),
                        ),
                        const Divider(height: 1, indent: 16),
                        _SettingsTile(
                          icon: Icons.alternate_email,
                          title: strings.changeEmail,
                          onTap: () => _changeSecurity('email'),
                        ),
                      ] else ...[
                        _SettingsTile(
                          icon: Icons.add_moderator_outlined,
                          title: 'Configurar acceso con correo',
                          subtitle: 'Agrega una contraseña a tu cuenta',
                          onTap: _showAddPasswordSheet,
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 32),
                  
                  _SettingsSection(
                    title: strings.preferences,
                    children: [
                      _SettingsTile(
                        icon: Icons.dark_mode_outlined,
                        title: strings.darkMode,
                        trailing: Switch(
                          value: settings?['theme_mode'] == 'dark',
                          activeColor: Colors.black,
                          onChanged: (val) => _viewModel.updateSetting('theme_mode', val ? 'dark' : 'light'),
                        ),
                      ),
                      const Divider(height: 1, indent: 16),
                      _SettingsTile(
                        icon: Icons.language,
                        title: strings.language,
                        trailing: Text(currentLocale.languageCode == 'es' ? 'Español' : currentLocale.languageCode == 'pt' ? 'Português' : 'English', style: const TextStyle(fontSize: 12)),
                        onTap: _changeLanguage,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 48),
                  
                  RouteCashPrimaryButton(
                    text: strings.logout,
                    backgroundColor: Colors.white,
                    textColor: Colors.redAccent,
                    onPressed: _signOut,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'RouteCash v1.0.0',
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String fullName;
  final String email;
  final VoidCallback onEdit;

  const _ProfileHeader({required this.fullName, required this.email, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            child: Text(
              fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Text(
                  email,
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_note_rounded, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF999999),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(children: children),
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({required this.icon, required this.title, this.subtitle, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.black, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null 
        ? Text(subtitle!, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)) 
        : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, size: 20, color: Color(0xFFC7C7C7)) : null),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _Badge({required this.text, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          text,
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _ProfileEditSheet extends StatefulWidget {
  final SettingsViewModel viewModel;
  const _ProfileEditSheet({required this.viewModel});

  @override
  State<_ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<_ProfileEditSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  Map<String, dynamic>? _selectedCountry;
  Map<String, dynamic>? _selectedState;
  Map<String, dynamic>? _selectedCurrency;

  @override
  void initState() {
    super.initState();
    final profile = widget.viewModel.userProfile;
    _nameController = TextEditingController(text: profile?['full_name']?.toString() ?? '');
    _phoneController = TextEditingController(text: profile?['phone']?.toString() ?? '');
    
    if (widget.viewModel.countries.isNotEmpty && profile?['states'] != null) {
      final dynamic statesData = profile!['states'];
      Map<String, dynamic>? stateMap;
      
      if (statesData is List && statesData.isNotEmpty) {
        stateMap = Map<String, dynamic>.from(statesData.first);
      } else if (statesData is Map) {
        stateMap = Map<String, dynamic>.from(statesData);
      }

      if (stateMap != null && stateMap['countries'] != null) {
        final dynamic countryData = stateMap['countries'];
        Map<String, dynamic>? countryMap;
        
        if (countryData is List && countryData.isNotEmpty) {
          countryMap = Map<String, dynamic>.from(countryData.first);
        } else if (countryData is Map) {
          countryMap = Map<String, dynamic>.from(countryData);
        }

        if (countryMap != null) {
          final countryId = countryMap['country_id'];
          _selectedCountry = widget.viewModel.countries.firstWhere(
            (c) => c['country_id'] == countryId, 
            orElse: () => widget.viewModel.countries.first
          );
        }
      }
    }
    
    if (widget.viewModel.states.isNotEmpty && profile?['state_id'] != null) {
      _selectedState = widget.viewModel.states.firstWhere(
        (s) => s['state_id'] == profile!['state_id'], 
        orElse: () => widget.viewModel.states.first
      );
    }

    if (widget.viewModel.currencies.isNotEmpty && profile?['default_currency_id'] != null) {
      _selectedCurrency = widget.viewModel.currencies.firstWhere(
        (c) => c['currency_id'] == profile!['default_currency_id'], 
        orElse: () => widget.viewModel.currencies.first
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(32, 24, 32, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(strings.profileEditTitle, style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          RouteCashTextField(label: strings.fullNameLabel, controller: _nameController, hintText: '',),
          const SizedBox(height: 20),
          RouteCashTextField(label: strings.phoneLabel, controller: _phoneController, keyboardType: TextInputType.phone, hintText: '',),
          const SizedBox(height: 20),
          RouteCashDropdown<Map<String, dynamic>>(
            label: strings.countryLabel,
            value: _selectedCountry,
            items: widget.viewModel.countries,
            displayMember: 'name',
            onChanged: (val) {
              setState(() => _selectedCountry = val);
              if (val != null) widget.viewModel.loadStates(val['country_id']);
            },
          ),
          const SizedBox(height: 20),
          RouteCashDropdown<Map<String, dynamic>>(
            label: strings.stateLabel,
            value: _selectedState,
            items: widget.viewModel.states,
            displayMember: 'name',
            onChanged: (val) => setState(() => _selectedState = val),
          ),
          const SizedBox(height: 20),
          RouteCashDropdown<Map<String, dynamic>>(
            label: strings.mainCurrencyLabel,
            value: _selectedCurrency,
            items: widget.viewModel.currencies,
            displayMember: 'code',
            onChanged: (val) => setState(() => _selectedCurrency = val),
          ),
          const SizedBox(height: 32),
          RouteCashPrimaryButton(
            text: strings.saveChanges,
            onPressed: () async {
              final err = await widget.viewModel.updateProfile(
                fullName: _nameController.text.trim(),
                phone: _phoneController.text.trim(),
                stateId: _selectedState?['state_id'] ?? '',
                currencyId: _selectedCurrency?['currency_id'] ?? 0,
              );
              if (mounted) {
                if (err == null) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ResetPasswordInfoSheet extends StatelessWidget {
  final VoidCallback onConfirm;
  const _ResetPasswordInfoSheet({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          Text(
            strings.changePassword,
            style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Para garantizar tu seguridad, te enviaremos un código de verificación de 6 dígitos a tu correo electrónico registrado.',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700], height: 1.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Al confirmar, el código será generado y tendrás 5 minutos para ingresarlo en el siguiente paso.',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          RouteCashPrimaryButton(
            text: strings.resendCode,
            onPressed: onConfirm,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                strings.cancel,
                style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityEditSheet extends StatefulWidget {
  final SettingsViewModel viewModel;
  final String type;
  const _SecurityEditSheet({required this.viewModel, required this.type});

  @override
  State<_SecurityEditSheet> createState() => _SecurityEditSheetState();
}

class _SecurityEditSheetState extends State<_SecurityEditSheet> {
  final _oldEmailController = TextEditingController();
  final _controller = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldEmailController.dispose();
    _controller.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    String title = '';
    String label = '';
    bool isEmail = widget.type == 'email';
    bool isPassword = widget.type == 'password';

    if (isEmail) {
      title = strings.changeEmail;
      label = strings.newEmail;
    } else if (isPassword) {
      title = strings.changePassword;
      label = strings.newPassword;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(32, 24, 32, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          if (isEmail) ...[
            RouteCashTextField(
              label: strings.currentEmail,
              controller: _oldEmailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Ingresa tu correo actual',
            ),
            const SizedBox(height: 20),
          ],
          RouteCashTextField(
            label: label,
            controller: _controller,
            obscureText: isPassword,
            keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
            hintText: isPassword ? 'Mínimo 6 caracteres' : 'nuevo@ejemplo.com',
          ),
          if (isPassword) ...[
            const SizedBox(height: 20),
            RouteCashTextField(
              label: strings.confirmPasswordLabel,
              controller: _confirmController,
              obscureText: true,
              hintText: 'Repite la contraseña',
            ),
          ],
          const SizedBox(height: 32),
          RouteCashPrimaryButton(
            text: strings.update,
            isLoading: _isLoading,
            onPressed: () async {
              if (_controller.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor completa los campos')));
                return;
              }

              setState(() => _isLoading = true);
              String? err;
              if (isEmail) {
                if (_oldEmailController.text.isEmpty) {
                  err = 'Debes ingresar tu correo actual';
                } else {
                  final lang = Localizations.localeOf(context).languageCode;
                  err = await widget.viewModel.initiateEmailChange(
                    _oldEmailController.text.trim(),
                    _controller.text.trim(),
                    lang,
                  );
                }
              } else {
                if (_controller.text != _confirmController.text) {
                  err = 'Las contraseñas no coinciden';
                } else {
                  err = await widget.viewModel.updatePassword(_controller.text);
                }
              }
              
              if (mounted) {
                setState(() => _isLoading = false);
                if (err == null) {
                  if (isEmail) {
                    Navigator.pop(context); // Cerrar el sheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OtpVerificationScreen(
                          userId: widget.viewModel.userProfile!['user_id'],
                          email: _controller.text.trim(),
                          purpose: 'change_email',
                          password: '',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contraseña actualizada con éxito.')));
                    Navigator.pop(context);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
