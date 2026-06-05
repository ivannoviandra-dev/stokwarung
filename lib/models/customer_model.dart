/// Customer model with debt/receivable tracking.
class Customer {
  final String id;
  final String name;
  final String? phone;
  final double totalDebt;
  final int invoiceCount;
  final DateTime? lastTransaction;

  Customer({
    required this.id,
    required this.name,
    this.phone,
    this.totalDebt = 0,
    this.invoiceCount = 0,
    this.lastTransaction,
  });

  /// Status: Lunas or Belum Lunas
  bool get isFullyPaid => totalDebt <= 0;
  String get statusLabel => isFullyPaid ? 'Lunas' : 'Belum Lunas';

  Customer copyWith({
    String? id,
    String? name,
    String? phone,
    double? totalDebt,
    int? invoiceCount,
    DateTime? lastTransaction,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      totalDebt: totalDebt ?? this.totalDebt,
      invoiceCount: invoiceCount ?? this.invoiceCount,
      lastTransaction: lastTransaction ?? this.lastTransaction,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      totalDebt: (json['total_debt'] as num?)?.toDouble() ?? 0,
      invoiceCount: json['invoice_count'] as int? ?? 0,
      lastTransaction: json['last_transaction'] != null
          ? DateTime.parse(json['last_transaction'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'total_debt': totalDebt,
      'invoice_count': invoiceCount,
      'last_transaction': lastTransaction?.toIso8601String(),
    };
  }

  static List<Customer> sampleCustomers() {
    return [
      Customer(
        id: 'C001',
        name: 'Budi Warteg',
        phone: '081234567890',
        totalDebt: 150000,
        invoiceCount: 3,
        lastTransaction: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Customer(
        id: 'C002',
        name: 'Siti Toko Kelontong',
        phone: '082345678901',
        totalDebt: 85000,
        invoiceCount: 2,
        lastTransaction: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Customer(
        id: 'C003',
        name: 'Ahmad Pedagang',
        phone: '083456789012',
        totalDebt: 67000,
        invoiceCount: 1,
        lastTransaction: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Customer(
        id: 'C004',
        name: 'Dewi Catering',
        phone: '084567890123',
        totalDebt: 50000,
        invoiceCount: 1,
        lastTransaction: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Customer(
        id: 'C005',
        name: 'Eko Warnet',
        phone: '085678901234',
        totalDebt: 45000,
        invoiceCount: 2,
        lastTransaction: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Customer(
        id: 'C006',
        name: 'Fajar Angkringan',
        phone: '086789012345',
        totalDebt: 35000,
        invoiceCount: 1,
        lastTransaction: DateTime.now().subtract(const Duration(days: 7)),
      ),
      Customer(
        id: 'C007',
        name: 'Gita Salon',
        phone: '087890123456',
        totalDebt: 20000,
        invoiceCount: 1,
        lastTransaction: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Customer(
        id: 'C008',
        name: 'Hendra Bengkel',
        phone: '088901234567',
        totalDebt: 0,
        invoiceCount: 0,
        lastTransaction: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }
}
