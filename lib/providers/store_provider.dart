import 'package:flutter/material.dart';
import '../models/store_model.dart';

/// Store settings provider.
class StoreProvider extends ChangeNotifier {
  Store _store = Store.sampleStore();
  bool _isLoading = false;

  Store get store => _store;
  bool get isLoading => _isLoading;

  Future<void> loadStore() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _store = Store.sampleStore();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateStore(Store store) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _store = store;
    _isLoading = false;
    notifyListeners();
  }

  void toggleOpenStatus() {
    _store = _store.copyWith(isOpen: !_store.isOpen);
    notifyListeners();
  }
}
