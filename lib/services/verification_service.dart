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
      
      String finalPurpose = purpose;
      if (purpose == 'recovery') finalPurpose = 'reset_password';

      final response = await http.post(
        Uri.parse('$_baseUrl/rapid-service'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $anonKey',
          'apikey': anonKey,
        },
        body: jsonEncode({
          'user_id': userId,
          'email': email.trim().toLowerCase(), // Forzamos limpieza aquí también
          'purpose': finalPurpose,
          'lang': lang,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 400) {
        final body = jsonDecode(response.body);
        return {'success': false, 'error': body['error'] ?? body['message'] ?? 'Error (${response.statusCode})'};
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
    String? email,
  }) async {
    try {
      final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

      String finalPurpose = purpose;
      if (purpose == 'recovery') finalPurpose = 'reset_password';

      final Map<String, dynamic> body = {
        'user_id': userId,
        'code': code,
        'purpose': finalPurpose,
        'lang': lang,
      };
      
      if (email != null) body['email'] = email.trim().toLowerCase();

      final response = await http.post(
        Uri.parse('$_baseUrl/Verificaci-n-de-c-digo-'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $anonKey',
          'apikey': anonKey,
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 400) {
        final body = jsonDecode(response.body);
        return {'success': false, 'error': body['error'] ?? body['message'] ?? 'Error de validación'};
      }

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>?> getLatestOtpStatus(String userId, String purpose) async {
    try {
      String finalPurpose = purpose;
      if (purpose == 'recovery') finalPurpose = 'reset_password';

      final response = await _supabase
          .from('user_otps')
          .select()
          .eq('user_id', userId)
          .eq('purpose', finalPurpose)
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
