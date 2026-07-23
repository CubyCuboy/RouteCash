import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class VerificationService {
  final _supabase = Supabase.instance.client;
  final String _baseUrl = 'https://gpufgmlpbpydojnvgwid.supabase.co/functions/v1';

  Future<Map<String, dynamic>> sendOtp({
    required String userId,
    required String email,
    required String purpose,
    required String lang,
  }) async {
    try {
      final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
      final sessionToken = _supabase.auth.currentSession?.accessToken;
      
      final response = await http.post(
        Uri.parse('$_baseUrl/rapid-service'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${sessionToken ?? anonKey}',
          'apikey': anonKey,
        },
        body: jsonEncode({
          'user_id': userId,
          'email': email,
          'purpose': purpose,
          'lang': lang,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 400) {
        final body = jsonDecode(response.body);
        return {'success': false, 'error': body['error'] ?? body['message'] ?? 'Error del servidor (${response.statusCode})'};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String userId,
    required String code,
    required String purpose,
    required String lang,
  }) async {
    try {
      final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
      final sessionToken = _supabase.auth.currentSession?.accessToken;

      final response = await http.post(
        Uri.parse('$_baseUrl/Verificaci-n-de-c-digo-'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${sessionToken ?? anonKey}',
          'apikey': anonKey,
        },
        body: jsonEncode({
          'user_id': userId,
          'code': code,
          'purpose': purpose,
          'lang': lang,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 400) {
        final body = jsonDecode(response.body);
        return {'success': false, 'error': body['error'] ?? body['message'] ?? 'Error de validación (${response.statusCode})'};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión: $e'};
    }
  }

  // Obtener datos de la tabla user_otps para mostrar intentos y tiempo
  Future<Map<String, dynamic>?> getLatestOtpStatus(String userId, String purpose) async {
    try {
      final response = await _supabase
          .from('user_otps')
          .select()
          .eq('user_id', userId)
          .eq('purpose', purpose)
          .eq('is_used', false)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      
      return response;
    } catch (e) {
      debugPrint('Error fetching OTP status: $e');
      return null;
    }
  }
}
