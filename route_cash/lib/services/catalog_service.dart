import 'package:supabase_flutter/supabase_flutter.dart';

class CatalogService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getCountries() async {
    final data = await _supabase
        .from('countries')
        .select('country_id, name, phone_code, iso_code')
        .order('name');
    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> getStates(String countryId) async {
    final data = await _supabase
        .from('states')
        .select('state_id, name')
        .eq('country_id', countryId)
        .order('name');
    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> getCurrencies() async {
    final data = await _supabase
        .from('currencies')
        .select('currency_id, code, name, symbol')
        .order('name');
    return List<Map<String, dynamic>>.from(data);
  }
}
