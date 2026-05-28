import 'package:flutter/material.dart';
import '../models/product_model.dart';

/// Product state provider.
///
/// Manages product inventory list, CRUD operations, search, and filtering.
class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  bool _isLoading = false;
  Product? _selectedProduct;

  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  Product? get selectedProduct => _selectedProduct;

  /// Products with low stock
  List<Product> get lowStockProducts =>
      _products.where((p) => p.isLowStock).toList();

  /// Products that are out of stock
  List<Product> get outOfStockProducts =>
      _products.where((p) => p.isOutOfStock).toList();

  /// Products expiring soon
  List<Product> get expiringProducts =>
      _products.where((p) => p.isExpiringSoon || p.isExpired).toList();

  /// Total product count
  int get totalProducts => _products.length;

  /// Total stock value (sell price)
  double get totalStockValue =>
      _products.fold(0, (sum, p) => sum + (p.sellPrice * p.stock));

  /// Load initial product data.
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _products = Product.sampleProducts();
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  /// Search products by name.
  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Filter by category.
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  /// Apply search + category filters.
  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Semua' ||
          product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  /// Select a product for detail view.
  void selectProduct(Product? product) {
    _selectedProduct = product;
    notifyListeners();
  }

  /// Add a new product.
  Future<void> addProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _products.add(product);
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  /// Update an existing product.
  Future<void> updateProduct(Product product) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  /// Delete a product.
  Future<void> deleteProduct(String productId) async {
    _products.removeWhere((p) => p.id == productId);
    _applyFilters();
    notifyListeners();
  }

  /// Update stock quantity for a product.
  void updateStock(String productId, int newStock) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index] = _products[index].copyWith(stock: newStock);
      _applyFilters();
      notifyListeners();
    }
  }

  /// Get product by ID.
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
