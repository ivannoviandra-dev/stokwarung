import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../models/transaction_model.dart';

/// Transaction & cart state provider.
///
/// Manages POS cart operations and transaction history.
class TransactionProvider extends ChangeNotifier {
  final List<CartItem> _cart = [];
  List<Transaction> _transactions = [];
  String _selectedPaymentMethod = 'Tunai';
  bool _isLoading = false;

  List<CartItem> get cart => _cart;
  List<Transaction> get transactions => _transactions;
  String get selectedPaymentMethod => _selectedPaymentMethod;
  bool get isLoading => _isLoading;

  /// Total items in cart
  int get cartItemCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  /// Cart total amount
  double get cartTotal => _cart.fold(0, (sum, item) => sum + item.subtotal);

  /// Cart total profit
  double get cartProfit => _cart.fold(
      0, (sum, item) => sum + (item.product.profitPerUnit * item.quantity));

  /// Today's transactions
  List<Transaction> get todayTransactions {
    final today = DateTime.now();
    return _transactions.where((t) {
      return t.date.year == today.year &&
          t.date.month == today.month &&
          t.date.day == today.day;
    }).toList();
  }

  /// Today's total revenue
  double get todayRevenue =>
      todayTransactions.fold(0, (sum, t) => sum + t.totalAmount);

  /// Today's total profit
  double get todayProfit =>
      todayTransactions.fold(0, (sum, t) => sum + t.totalProfit);

  /// Load transaction history.
  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _transactions = Transaction.sampleTransactions();
    _isLoading = false;
    notifyListeners();
  }

  /// Add product to cart.
  void addToCart(Product product) {
    final existingIndex =
        _cart.indexWhere((item) => item.product.id == product.id);
    if (existingIndex != -1) {
      _cart[existingIndex].quantity++;
    } else {
      _cart.add(CartItem(product: product));
    }
    notifyListeners();
  }

  /// Remove product from cart.
  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// Update cart item quantity.
  void updateQuantity(String productId, int quantity) {
    final index = _cart.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (quantity <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  /// Increment cart item quantity.
  void incrementQuantity(String productId) {
    final index = _cart.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _cart[index].quantity++;
      notifyListeners();
    }
  }

  /// Decrement cart item quantity.
  void decrementQuantity(String productId) {
    final index = _cart.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Set payment method.
  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  /// Process checkout — create transaction and clear cart.
  Future<bool> checkout({String? customerName}) async {
    if (_cart.isEmpty) return false;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    final transaction = Transaction(
      id: 'TRX${DateTime.now().millisecondsSinceEpoch}',
      items: _cart.map((item) {
        return TransactionItem(
          productName: item.product.name,
          price: item.product.sellPrice,
          buyPrice: item.product.buyPrice,
          quantity: item.quantity,
        );
      }).toList(),
      totalAmount: cartTotal,
      totalProfit: cartProfit,
      paymentMethod: _selectedPaymentMethod,
      customerName: customerName,
    );

    _transactions.insert(0, transaction);
    _cart.clear();
    _selectedPaymentMethod = 'Tunai';
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Clear the cart.
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
