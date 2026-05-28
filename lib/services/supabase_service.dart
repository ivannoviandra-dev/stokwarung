import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_constants.dart';

/// Supabase Service — Placeholder integration layer.
///
/// Replace [AppConstants.supabaseUrl] and [AppConstants.supabaseAnonKey]
/// with your actual Supabase project credentials.
class SupabaseService {
  SupabaseService._();
  static final SupabaseService _instance = SupabaseService._();
  static SupabaseService get instance => _instance;

  SupabaseClient? _client;

  /// Get the Supabase client (may be null if not initialized).
  SupabaseClient? get client => _client;

  /// Initialize Supabase. Call this in main() before runApp().
  Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: AppConstants.supabaseUrl,
        anonKey: AppConstants.supabaseAnonKey,
      );
      _client = Supabase.instance.client;
    } catch (e) {
      // Supabase initialization failed — app will run with mock data
      _client = null;
    }
  }

  /// Check if Supabase is connected
  bool get isConnected => _client != null;

  // ─── Auth Placeholders ───

  Future<bool> signIn({required String email, required String password}) async {
    // TODO: Implement with Supabase Auth
    // final response = await _client?.auth.signInWithPassword(
    //   email: email,
    //   password: password,
    // );
    return true; // Mock success
  }

  Future<bool> signUp({required String email, required String password}) async {
    // TODO: Implement with Supabase Auth
    return true;
  }

  Future<void> signOut() async {
    // TODO: Implement with Supabase Auth
    // await _client?.auth.signOut();
  }

  // ─── Product Placeholders ───

  Future<List<Map<String, dynamic>>> getProducts() async {
    // TODO: Implement with Supabase
    // return await _client?.from('products').select() ?? [];
    return [];
  }

  Future<void> addProduct(Map<String, dynamic> product) async {
    // TODO: Implement with Supabase
    // await _client?.from('products').insert(product);
  }

  Future<void> updateProduct(String id, Map<String, dynamic> product) async {
    // TODO: Implement with Supabase
    // await _client?.from('products').update(product).eq('id', id);
  }

  Future<void> deleteProduct(String id) async {
    // TODO: Implement with Supabase
    // await _client?.from('products').delete().eq('id', id);
  }

  // ─── Transaction Placeholders ───

  Future<List<Map<String, dynamic>>> getTransactions() async {
    // TODO: Implement
    return [];
  }

  Future<void> addTransaction(Map<String, dynamic> transaction) async {
    // TODO: Implement
  }

  // ─── Customer Placeholders ───

  Future<List<Map<String, dynamic>>> getCustomers() async {
    // TODO: Implement
    return [];
  }

  Future<void> addDebt(Map<String, dynamic> debt) async {
    // TODO: Implement
  }

  Future<void> markDebtPaid(String debtId) async {
    // TODO: Implement
  }
}
