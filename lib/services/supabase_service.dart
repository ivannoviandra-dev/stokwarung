import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_constants.dart';
import '../models/store_model.dart';
import '../models/user_model.dart';

/// Supabase integration layer.
///
/// Replace [AppConstants.supabaseUrl] and [AppConstants.supabaseAnonKey]
/// with your actual Supabase project credentials.
class SupabaseService {
  SupabaseService._();
  static final SupabaseService _instance = SupabaseService._();
  static SupabaseService get instance => _instance;

  SupabaseClient? _client;

  SupabaseClient? get client => _client;

  bool get isConfigured =>
      AppConstants.supabaseUrl.startsWith('https://') &&
      !AppConstants.supabaseUrl.contains('your-project') &&
      AppConstants.supabaseAnonKey.isNotEmpty &&
      AppConstants.supabaseAnonKey != 'your-anon-key';

  Future<void> initialize() async {
    if (!isConfigured) {
      _client = null;
      return;
    }

    try {
      await Supabase.initialize(
        url: AppConstants.supabaseUrl,
        anonKey: AppConstants.supabaseAnonKey,
      );
      _client = Supabase.instance.client;
    } catch (_) {
      _client = null;
    }
  }

  bool get isConnected => _client != null;

  SupabaseClient get _requiredClient {
    final activeClient = _client;
    if (activeClient == null) {
      throw const AuthException(
        'Supabase belum dikonfigurasi. Isi supabaseUrl dan supabaseAnonKey di AppConstants.',
      );
    }
    return activeClient;
  }

  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _requiredClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('Akun tidak ditemukan atau password salah.');
    }

    return await getCurrentUserProfile() ?? _profileFromAuthUser(user);
  }

  Future<SignUpResult> signUp({
    required String ownerName,
    required String storeName,
    required String phone,
    required String email,
    required String password,
  }) async {
    final response = await _requiredClient.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': ownerName,
        'store_name': storeName,
        'phone': phone,
      },
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('Registrasi gagal. Coba lagi beberapa saat lagi.');
    }

    return SignUpResult(
      profile: UserProfile(
        id: user.id,
        name: ownerName,
        email: email,
        storeName: storeName,
      ),
      hasActiveSession: response.session != null,
    );
  }

  Future<void> signOut() async {
    await _requiredClient.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _requiredClient.auth.resetPasswordForEmail(email);
  }

  Future<UserProfile?> getCurrentUserProfile() async {
    final user = _client?.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await _requiredClient
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      if (data != null) {
        return UserProfile.fromJson(data);
      }
    } catch (_) {
      // Fall back to auth metadata if the profile row is still being created.
    }

    return _profileFromAuthUser(user);
  }

  UserProfile _profileFromAuthUser(User user) {
    final metadata = user.userMetadata ?? {};
    return UserProfile(
      id: user.id,
      name: metadata['name'] as String? ?? 'Pemilik Toko',
      email: user.email ?? metadata['email'] as String? ?? '',
      storeName: metadata['store_name'] as String? ?? 'Toko Saya',
    );
  }

  Future<Store?> getCurrentStore() async {
    final user = _client?.auth.currentUser;
    if (user == null) return null;

    final data = await _requiredClient
        .from('stores')
        .select()
        .eq('owner_id', user.id)
        .maybeSingle();

    if (data == null) return null;
    return Store.fromJson(data);
  }

  Future<void> updateCurrentStore(Store store) async {
    final user = _client?.auth.currentUser;
    if (user == null) {
      throw const AuthException('Sesi login tidak ditemukan.');
    }

    await _requiredClient.from('stores').upsert({
      'owner_id': user.id,
      ...store.toJson(),
    }, onConflict: 'owner_id');

    await _requiredClient.from('profiles').update({
      'store_name': store.name,
      'phone': store.phone,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    return await _client?.from('products').select() ?? [];
  }

  Future<void> addProduct(Map<String, dynamic> product) async {
    await _client?.from('products').insert(product);
  }

  Future<void> updateProduct(String id, Map<String, dynamic> product) async {
    await _client?.from('products').update(product).eq('id', id);
  }

  Future<void> deleteProduct(String id) async {
    await _client?.from('products').delete().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    return await _client?.from('transactions').select() ?? [];
  }

  Future<void> addTransaction(Map<String, dynamic> transaction) async {
    await _client?.from('transactions').insert(transaction);
  }

  Future<List<Map<String, dynamic>>> getCustomers() async {
    return await _client?.from('customers').select() ?? [];
  }

  Future<void> addDebt(Map<String, dynamic> debt) async {
    await _client?.from('debts').insert(debt);
  }

  Future<void> markDebtPaid(String debtId) async {
    await _client?.from('debts').update({'is_paid': true}).eq('id', debtId);
  }
}

class SignUpResult {
  final UserProfile profile;
  final bool hasActiveSession;

  const SignUpResult({
    required this.profile,
    required this.hasActiveSession,
  });
}
