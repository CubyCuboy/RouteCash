import 'package:flutter/material.dart';
import '/ui/screens/home_screen.dart'; // Importamos tu nuevo archivo aquí

void main() {
  runApp(const MyApp());
}

// Clase principal de la app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const PinCodeScreen(),
    );
  }
}

// Pantalla del PIN
class PinCodeScreen extends StatefulWidget {
  const PinCodeScreen({super.key});

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  String pin = "";

  void _onKeyPress(String value) {
    setState(() {
      if (pin.length < 4) {
        pin += value;
      }
    });
  }

  void _onDeletePress() {
    setState(() {
      if (pin.isNotEmpty) {
        pin = pin.substring(0, pin.length - 1);
      }
    });
  }

  void _onFingerprintPress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Autenticación con huella solicitada')),
    );
  }

  void _onConfirmPress() {
    if (pin.length == 4) {
      // Navega al HomeScreen importado y elimina el PIN del historial
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa los 4 dígitos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/wallpaper_pin1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 80),
              // Título
              const Text(
                'Ingresa tu clave',
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Times New Roman',
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 60),

              // Indicadores del PIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPinIndicator(0),
                  const SizedBox(width: 12),
                  _buildPinIndicator(1),
                  const SizedBox(width: 32),
                  _buildPinIndicator(2),
                  const SizedBox(width: 12),
                  _buildPinIndicator(3),
                ],
              ),

              const Spacer(),

              // Teclado Numérico
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    _buildKeyboardRow(['1', '2', '3']),
                    const SizedBox(height: 20),
                    _buildKeyboardRow(['4', '5', '6']),
                    const SizedBox(height: 20),
                    _buildKeyboardRow(['7', '8', '9']),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildConfirmButton(),
                        _buildKeypadButton('0'),
                        pin.isEmpty
                            ? _buildFingerprintButton()
                            : _buildDeleteButton(),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para los indicadores ovalados del PIN
  Widget _buildPinIndicator(int index) {
    bool isFilled = pin.length > index;
    return Container(
      width: 35,
      height: 20,
      decoration: BoxDecoration(
        color: isFilled ? Colors.white : const Color(0xFF8E8E8E),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // Fila del teclado
  Widget _buildKeyboardRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((num) => _buildKeypadButton(num)).toList(),
    );
  }

  // Botones numéricos
  Widget _buildKeypadButton(String number) {
    return GestureDetector(
      onTap: () => _onKeyPress(number),
      child: Container(
        width: 75,
        height: 75,
        decoration: const BoxDecoration(
          color: Color(0xFF8E8E8E),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Botón de Confirmar
  Widget _buildConfirmButton() {
    return GestureDetector(
      onTap: _onConfirmPress,
      child: SizedBox(
        width: 75,
        height: 75,
        child: const Center(
          child: Icon(Icons.check, size: 45, color: Colors.white),
        ),
      ),
    );
  }

  // Botón de Huella
  Widget _buildFingerprintButton() {
    return GestureDetector(
      onTap: _onFingerprintPress,
      child: SizedBox(
        width: 75,
        height: 75,
        child: const Center(
          child: Icon(Icons.fingerprint, size: 55, color: Colors.white),
        ),
      ),
    );
  }

  // Botón de Borrar
  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _onDeletePress,
      child: SizedBox(
        width: 75,
        height: 75,
        child: const Center(
          child: Icon(Icons.backspace_outlined, size: 35, color: Colors.white),
        ),
      ),
    );
  }
}
