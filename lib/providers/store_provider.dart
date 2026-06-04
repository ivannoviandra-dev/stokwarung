import 'package:flutter/material.dart';
import '../models/store_model.dart';
import '../services/supabase_service.dart';

/// Store settings provider.
class StoreProvider extends ChangeNotifier {
  Store _store = Store.empty();
  bool _isLoading = false;
  String? _errorMessage;

  Store get store => _store;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadStore() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _store = await SupabaseService.instance.getCurrentStore() ?? Store.empty();
    } catch (e) {
      _errorMessage = 'Gagal memuat toko: ${e.toString()}';
      _store = Store.empty();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateStore(Store store) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await SupabaseService.instance.updateCurrentStore(store);
      _store = store;
    } catch (e) {
      _errorMessage = 'Gagal menyimpan toko: ${e.toString()}';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleOpenStatus() async {
    await updateStore(_store.copyWith(isOpen: !_store.isOpen));
  }

  void clear() {
    _store = Store.empty();
    _errorMessage = null;
    notifyListeners();
  }
}
