import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// Authentication state provider.
///
/// Manages login/logout flow, current user session, and loading states.
class AuthProvider extends ChangeNotifier {
  UserProfile? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;

  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  /// Attempt to sign in with email and password.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock validation
      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Email dan password tidak boleh kosong';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Mock successful login
      _user = UserProfile.sampleUser().copyWith(email: email);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal masuk: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _user = null;
    _isAuthenticated = false;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
