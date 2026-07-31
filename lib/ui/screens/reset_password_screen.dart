import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../viewmodels/register_view_model.dart';
import '../components/route_cash_buttons.dart';
import '../components/route_cash_inputs.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // Reutilizamos el RegisterViewModel para la lógica de validación de contraseñas
  final _validationModel = RegisterViewModel();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _validationModel.dispose();
    super.dispose();
  }

  void _updatePassword() async {
    if (!_validationModel.isStep3Valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, cumple con todos los requisitos de seguridad.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _passwordController.text),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña actualizada con éxito')),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _validationModel,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 42),
                  Text(
                    'NUEVA CONTRASEÑA',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9D9D9D),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Restablecer\nSeguridad.',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.black,
                      fontSize: 48,
                      height: 0.88,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.8,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Reutilizamos el componente de requisitos que creamos para el registro
                  _PasswordRequirements(viewModel: _validationModel),
                  
                  const SizedBox(height: 32),
                  RouteCashTextField(
                    label: 'NUEVA CONTRASEÑA',
                    controller: _passwordController,
                    obscureText: _validationModel.obscurePassword,
                    hintText: '••••••••••',
                    onChanged: _validationModel.updatePassword,
                    suffixIcon: IconButton(
                      onPressed: _validationModel.togglePasswordVisibility,
                      icon: Icon(
                        _validationModel.obscurePassword 
                          ? Icons.visibility_outlined 
                          : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RouteCashTextField(
                    label: 'CONFIRMAR CONTRASEÑA',
                    controller: _confirmController,
                    obscureText: _validationModel.obscureConfirmPassword,
                    hintText: '••••••••••',
                    onChanged: _validationModel.updateConfirmPassword,
                    suffixIcon: IconButton(
                      onPressed: _validationModel.toggleConfirmPasswordVisibility,
                      icon: Icon(
                        _validationModel.obscureConfirmPassword 
                          ? Icons.visibility_outlined 
                          : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  RouteCashPrimaryButton(
                    text: 'ACTUALIZAR CONTRASEÑA',
                    onPressed: _validationModel.isStep3Valid ? _updatePassword : () {},
                    isLoading: _isLoading,
                    backgroundColor: _validationModel.isStep3Valid ? Colors.black : Colors.grey.shade400,
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

// Para que el código sea realmente reutilizable, deberíamos mover _PasswordRequirements 
// a un archivo de componentes, pero por ahora lo duplicamos aquí para que funcione 
// de inmediato con el mismo estilo.

class _PasswordRequirements extends StatelessWidget {
  final RegisterViewModel viewModel;
  const _PasswordRequirements({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          _RequirementRow(text: "8+ caracteres", isMet: viewModel.hasMinLength),
          const SizedBox(height: 8),
          _RequirementRow(text: "Una mayúscula", isMet: viewModel.hasUppercase),
          const SizedBox(height: 8),
          _RequirementRow(text: "Un número", isMet: viewModel.hasNumber),
          const SizedBox(height: 8),
          _RequirementRow(text: r"Carácter especial (!@#$)", isMet: viewModel.hasSpecialChar),
          const SizedBox(height: 8),
          _RequirementRow(text: "Las contraseñas coinciden", isMet: viewModel.passwordsMatch),
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String text;
  final bool isMet;
  const _RequirementRow({required this.text, required this.isMet});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle_outlined,
          size: 16,
          color: isMet ? Colors.green : Colors.grey.shade300,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: isMet ? Colors.black : Colors.grey,
            fontWeight: isMet ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
