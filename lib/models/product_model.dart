/// Product model representing an inventory item in the store.
class Product {
  final String id;
  final String name;
  final String? barcode;
  final String? sku;
  final double buyPrice;
  final double sellPrice;
  final int stock;
  final int minStock;
  final String category;
  final String? imageUrl;
  final DateTime? expiryDate;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    this.barcode,
    this.sku,
    required this.buyPrice,
    required this.sellPrice,
    required this.stock,
    this.minStock = 5,
    this.category = 'Lainnya',
    this.imageUrl,
    this.expiryDate,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Calculate profit margin percentage
  double get margin => sellPrice > 0 ? ((sellPrice - buyPrice) / sellPrice) * 100 : 0;

  /// Calculate profit per unit
  double get profitPerUnit => sellPrice - buyPrice;

  /// Check if stock is low
  bool get isLowStock => stock <= minStock && stock > 0;

  /// Check if out of stock
  bool get isOutOfStock => stock <= 0;

  /// Check if expiring soon (within 7 days)
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    return expiryDate!.difference(DateTime.now()).inDays <= 7 &&
        expiryDate!.isAfter(DateTime.now());
  }

  /// Check if expired
  bool get isExpired {
    if (expiryDate == null) return false;
    return expiryDate!.isBefore(DateTime.now());
  }

  Product copyWith({
    String? id,
    String? name,
    String? barcode,
    String? sku,
    double? buyPrice,
    double? sellPrice,
    int? stock,
    int? minStock,
    String? category,
    String? imageUrl,
    DateTime? expiryDate,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      sku: sku ?? this.sku,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      expiryDate: expiryDate ?? this.expiryDate,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      barcode: json['barcode'] as String?,
      sku: json['sku'] as String?,
      buyPrice: (json['buy_price'] as num).toDouble(),
      sellPrice: (json['sell_price'] as num).toDouble(),
      stock: json['stock'] as int,
      minStock: json['min_stock'] as int? ?? 5,
      category: json['category'] as String? ?? 'Lainnya',
      imageUrl: json['image_url'] as String?,
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'] as String)
          : null,
      description: json['description'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'sku': sku,
      'buy_price': buyPrice,
      'sell_price': sellPrice,
      'stock': stock,
      'min_stock': minStock,
      'category': category,
      'image_url': imageUrl,
      'expiry_date': expiryDate?.toIso8601String(),
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Sample data for development
  static List<Product> sampleProducts() {
    return [
      Product(
        id: '1',
        name: 'Indomie Goreng',
        barcode: '8886008101053',
        buyPrice: 2500,
        sellPrice: 3500,
        stock: 48,
        minStock: 10,
        category: 'Sembako',
        expiryDate: DateTime.now().add(const Duration(days: 180)),
      ),
      Product(
        id: '2',
        name: 'Beras Rojo Lele 5kg',
        buyPrice: 55000,
        sellPrice: 65000,
        stock: 12,
        minStock: 5,
        category: 'Sembako',
      ),
      Product(
        id: '3',
        name: 'Aqua 600ml',
        barcode: '8886008101091',
        buyPrice: 2000,
        sellPrice: 3000,
        stock: 3,
        minStock: 10,
        category: 'Minuman',
        expiryDate: DateTime.now().add(const Duration(days: 365)),
      ),
      Product(
        id: '4',
        name: 'Gudang Garam Filter',
        barcode: '8998866200318',
        buyPrice: 24000,
        sellPrice: 28000,
        stock: 25,
        minStock: 10,
        category: 'Rokok',
      ),
      Product(
        id: '5',
        name: 'Teh Pucuk Harum 350ml',
        barcode: '8996001600146',
        buyPrice: 2500,
        sellPrice: 4000,
        stock: 0,
        minStock: 10,
        category: 'Minuman',
        expiryDate: DateTime.now().add(const Duration(days: 5)),
      ),
      Product(
        id: '6',
        name: 'Minyak Goreng Bimoli 1L',
        buyPrice: 18000,
        sellPrice: 22000,
        stock: 8,
        minStock: 5,
        category: 'Sembako',
      ),
      Product(
        id: '7',
        name: 'Chitato Sapi Panggang 68g',
        barcode: '8886008101999',
        buyPrice: 7500,
        sellPrice: 10000,
        stock: 15,
        minStock: 5,
        category: 'Snack',
        expiryDate: DateTime.now().add(const Duration(days: 3)),
      ),
    ];
  }
}
