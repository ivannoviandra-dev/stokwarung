import 'package:flutter/material.dart';

/// Navigation provider for bottom nav bar tab index.
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void goToHome() => setIndex(0);
  void goToKasir() => setIndex(1);
  void goToLaporan() => setIndex(2);
  void goToProfil() => setIndex(3);
}
