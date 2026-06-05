import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/supabase_service.dart';

/// Authentication state provider.
///
/// Manages login/logout flow, current user session, and loading states.
class AuthProvider extends ChangeNotifier {
  UserProfile? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  bool _needsEmailConfirmation = false;
  String? _errorMessage;

  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  bool get needsEmailConfirmation => _needsEmailConfirmation;
  String? get errorMessage => _errorMessage;

  Future<void> restoreSession() async {
    final currentUser = await SupabaseService.instance.getCurrentUserProfile();
    if (currentUser == null) return;

    _user = currentUser;
    _isAuthenticated = true;
    _needsEmailConfirmation = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Attempt to sign in with email and password.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Email dan password tidak boleh kosong';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _user = await SupabaseService.instance.signIn(
        email: email,
        password: password,
      );
      _isAuthenticated = true;
      _needsEmailConfirmation = false;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal masuk: ${_friendlyError(e)}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String ownerName,
    required String storeName,
    required String phone,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await SupabaseService.instance.signUp(
        ownerName: ownerName,
        storeName: storeName,
        phone: phone,
        email: email,
        password: password,
      );
      _user = result.profile;
      _isAuthenticated = result.hasActiveSession;
      _needsEmailConfirmation = !result.hasActiveSession;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal daftar: ${_friendlyError(e)}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await SupabaseService.instance.signOut();
    } catch (_) {
      // Local session state should still be cleared even if server sign-out fails.
    }

    _user = null;
    _isAuthenticated = false;
    _needsEmailConfirmation = false;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> sendPasswordReset(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await SupabaseService.instance.resetPassword(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal kirim reset password: ${_friendlyError(e)}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString();
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('over_email_send_rate_limit') ||
        lowerMessage.contains('email rate limit exceeded')) {
      return 'Terlalu banyak permintaan email verifikasi. Tunggu beberapa menit, lalu coba daftar lagi.';
    }

    if (lowerMessage.contains('user already registered') ||
        lowerMessage.contains('already registered') ||
        lowerMessage.contains('already exists')) {
      return 'Email ini sudah terdaftar. Silakan masuk atau gunakan email lain.';
    }

    if (lowerMessage.contains('email not confirmed')) {
      return 'Email belum dikonfirmasi. Cek inbox email Anda terlebih dulu.';
    }

    if (lowerMessage.contains('invalid login credentials')) {
      return 'Email atau password salah.';
    }

    if (lowerMessage.contains('password should be at least')) {
      return 'Password terlalu pendek.';
    }

    return message
        .replaceFirst(RegExp(r'AuthApiException\(message: '), '')
        .replaceFirst(RegExp(r'AuthException\(message: '), '')
        .replaceFirst(RegExp(r'PostgrestException\(message: '), '')
        .replaceFirst(RegExp(r', statusCode: .*'), '')
        .replaceFirst(RegExp(r', code: .*'), '')
        .replaceAll(')', '');
  }

  /// Clear error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
