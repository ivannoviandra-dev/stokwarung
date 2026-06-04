import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import '../models/debt_model.dart';

/// Customer & debt state provider.
///
/// Manages customer list, debt records, and search functionality.
class CustomerProvider extends ChangeNotifier {
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  List<Debt> _debts = [];
  String _searchQuery = '';
  bool _isLoading = false;

  List<Customer> get customers => _filteredCustomers;
  List<Customer> get allCustomers => _customers;
  List<Debt> get debts => _debts;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  /// Total receivables across all customers
  double get totalReceivables =>
      _customers.fold(0, (sum, c) => sum + c.totalDebt);

  /// Number of customers with outstanding debt
  int get customersWithDebt =>
      _customers.where((c) => !c.isFullyPaid).length;

  /// Load customer data.
  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    _customers = [];
    _debts = [];
    _applySearch();
    _isLoading = false;
    notifyListeners();
  }

  /// Search customers by name.
  void searchCustomers(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredCustomers = List.from(_customers);
    } else {
      _filteredCustomers = _customers
          .where((c) =>
              c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  /// Get debts for a specific customer.
  List<Debt> getDebtsForCustomer(String customerId) {
    return _debts.where((d) => d.customerId == customerId).toList();
  }

  /// Get customer by ID.
  Customer? getCustomerById(String id) {
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add new debt for a customer.
  Future<void> addDebt({
    required String customerId,
    required double amount,
    required String description,
  }) async {
    final debt = Debt(
      id: 'D${DateTime.now().millisecondsSinceEpoch}',
      customerId: customerId,
      amount: amount,
      description: description,
    );

    _debts.add(debt);

    // Update customer total debt
    final index = _customers.indexWhere((c) => c.id == customerId);
    if (index != -1) {
      _customers[index] = _customers[index].copyWith(
        totalDebt: _customers[index].totalDebt + amount,
        invoiceCount: _customers[index].invoiceCount + 1,
        lastTransaction: DateTime.now(),
      );
    }

    _applySearch();
    notifyListeners();
  }

  /// Mark a debt as paid.
  Future<void> markDebtPaid(String debtId) async {
    final debtIndex = _debts.indexWhere((d) => d.id == debtId);
    if (debtIndex != -1) {
      final debt = _debts[debtIndex];
      _debts[debtIndex] = debt.copyWith(isPaid: true, paidDate: DateTime.now());

      // Update customer total debt
      final customerIndex =
          _customers.indexWhere((c) => c.id == debt.customerId);
      if (customerIndex != -1) {
        final newDebt = _customers[customerIndex].totalDebt - debt.amount;
        _customers[customerIndex] = _customers[customerIndex].copyWith(
          totalDebt: newDebt < 0 ? 0 : newDebt,
        );
      }

      _applySearch();
      notifyListeners();
    }
  }

  /// Add a new customer.
  Future<void> addCustomer(Customer customer) async {
    _customers.add(customer);
    _applySearch();
    notifyListeners();
  }
}
