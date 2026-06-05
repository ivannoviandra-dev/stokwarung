/// Transaction model representing a completed sale.
class Transaction {
  final String id;
  final List<TransactionItem> items;
  final double totalAmount;
  final double totalProfit;
  final String paymentMethod;
  final String? customerName;
  final DateTime date;
  final String? notes;

  Transaction({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.totalProfit,
    required this.paymentMethod,
    this.customerName,
    DateTime? date,
    this.notes,
  }) : date = date ?? DateTime.now();

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      totalProfit: (json['total_profit'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String,
      customerName: json['customer_name'] as String?,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((e) => e.toJson()).toList(),
      'total_amount': totalAmount,
      'total_profit': totalProfit,
      'payment_method': paymentMethod,
      'customer_name': customerName,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  static List<Transaction> sampleTransactions() {
    final now = DateTime.now();
    return [
      Transaction(
        id: 'TRX001',
        items: [
          TransactionItem(productName: 'Indomie Goreng', price: 3500, quantity: 5, buyPrice: 2500),
          TransactionItem(productName: 'Aqua 600ml', price: 3000, quantity: 2, buyPrice: 2000),
        ],
        totalAmount: 23500,
        totalProfit: 7000,
        paymentMethod: 'Tunai',
        date: now,
      ),
      Transaction(
        id: 'TRX002',
        items: [
          TransactionItem(productName: 'Gudang Garam Filter', price: 28000, quantity: 1, buyPrice: 24000),
        ],
        totalAmount: 28000,
        totalProfit: 4000,
        paymentMethod: 'QRIS',
        customerName: 'Budi',
        date: now.subtract(const Duration(hours: 2)),
      ),
      Transaction(
        id: 'TRX003',
        items: [
          TransactionItem(productName: 'Beras Rojo Lele 5kg', price: 65000, quantity: 1, buyPrice: 55000),
          TransactionItem(productName: 'Minyak Goreng Bimoli 1L', price: 22000, quantity: 2, buyPrice: 18000),
        ],
        totalAmount: 109000,
        totalProfit: 18000,
        paymentMethod: 'Transfer',
        date: now.subtract(const Duration(hours: 5)),
      ),
      Transaction(
        id: 'TRX004',
        items: [
          TransactionItem(productName: 'Teh Pucuk Harum 350ml', price: 4000, quantity: 3, buyPrice: 2500),
        ],
        totalAmount: 12000,
        totalProfit: 4500,
        paymentMethod: 'Tunai',
        date: now.subtract(const Duration(days: 1)),
      ),
      Transaction(
        id: 'TRX005',
        items: [
          TransactionItem(productName: 'Chitato Sapi Panggang', price: 10000, quantity: 2, buyPrice: 7500),
          TransactionItem(productName: 'Aqua 600ml', price: 3000, quantity: 4, buyPrice: 2000),
        ],
        totalAmount: 32000,
        totalProfit: 9000,
        paymentMethod: 'Tunai',
        date: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}

/// Individual item within a transaction.
class TransactionItem {
  final String productName;
  final double price;
  final double buyPrice;
  final int quantity;

  TransactionItem({
    required this.productName,
    required this.price,
    required this.quantity,
    required this.buyPrice,
  });

  double get subtotal => price * quantity;
  double get profit => (price - buyPrice) * quantity;

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      productName: json['product_name'] as String,
      price: (json['price'] as num).toDouble(),
      buyPrice: (json['buy_price'] as num?)?.toDouble() ?? 0,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'price': price,
      'buy_price': buyPrice,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}
