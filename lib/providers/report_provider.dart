import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

/// Report & analytics data provider.
///
/// Provides chart data, metrics, and revenue calculations for the reports screen.
class ReportProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Transaction> _transactions = [];
  String _selectedPeriod = 'Minggu Ini';

  bool get isLoading => _isLoading;
  String get selectedPeriod => _selectedPeriod;

  /// Total revenue
  double get totalOmzet =>
      _transactions.fold(0, (sum, t) => sum + t.totalAmount);

  /// Total profit
  double get totalProfit =>
      _transactions.fold(0, (sum, t) => sum + t.totalProfit);

  /// Total number of transactions
  int get totalTransactions => _transactions.length;

  /// Daily profit data for chart (last 7 days)
  List<DailyData> get dailyProfitData {
    final now = DateTime.now();
    final List<DailyData> data = [];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayTransactions = _transactions.where((t) {
        return t.date.year == date.year &&
            t.date.month == date.month &&
            t.date.day == date.day;
      });

      final profit = dayTransactions.fold<double>(
          0, (sum, t) => sum + t.totalProfit);

      data.add(DailyData(
        date: date,
        value: profit,
      ));
    }

    return data;
  }

  /// Daily revenue data for chart
  List<DailyData> get dailyRevenueData {
    final now = DateTime.now();
    final List<DailyData> data = [];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayTransactions = _transactions.where((t) {
        return t.date.year == date.year &&
            t.date.month == date.month &&
            t.date.day == date.day;
      });

      final revenue = dayTransactions.fold<double>(
          0, (sum, t) => sum + t.totalAmount);

      data.add(DailyData(
        date: date,
        value: revenue,
      ));
    }

    return data;
  }

  /// Recent transactions (latest first)
  List<Transaction> get recentTransactions {
    final sorted = List<Transaction>.from(_transactions);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(10).toList();
  }

  /// Load report data.
  Future<void> loadReportData(List<Transaction> transactions) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _transactions = transactions;
    _isLoading = false;
    notifyListeners();
  }

  /// Change selected period.
  void setPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
  }
}

/// Daily data point for charts.
class DailyData {
  final DateTime date;
  final double value;

  DailyData({
    required this.date,
    required this.value,
  });
}
