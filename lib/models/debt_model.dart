/// Individual debt record for a customer.
class Debt {
  final String id;
  final String customerId;
  final double amount;
  final String description;
  final DateTime date;
  final bool isPaid;
  final DateTime? paidDate;

  Debt({
    required this.id,
    required this.customerId,
    required this.amount,
    required this.description,
    DateTime? date,
    this.isPaid = false,
    this.paidDate,
  }) : date = date ?? DateTime.now();

  Debt copyWith({
    String? id,
    String? customerId,
    double? amount,
    String? description,
    DateTime? date,
    bool? isPaid,
    DateTime? paidDate,
  }) {
    return Debt(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      isPaid: isPaid ?? this.isPaid,
      paidDate: paidDate ?? this.paidDate,
    );
  }

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      isPaid: json['is_paid'] as bool? ?? false,
      paidDate: json['paid_date'] != null
          ? DateTime.parse(json['paid_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'is_paid': isPaid,
      'paid_date': paidDate?.toIso8601String(),
    };
  }

  static List<Debt> sampleDebts() {
    final now = DateTime.now();
    return [
      Debt(
        id: 'D001',
        customerId: 'C001',
        amount: 75000,
        description: 'Belanja sembako',
        date: now.subtract(const Duration(days: 5)),
      ),
      Debt(
        id: 'D002',
        customerId: 'C001',
        amount: 50000,
        description: 'Beli rokok dan minuman',
        date: now.subtract(const Duration(days: 3)),
      ),
      Debt(
        id: 'D003',
        customerId: 'C001',
        amount: 25000,
        description: 'Beli snack',
        date: now.subtract(const Duration(days: 1)),
      ),
      Debt(
        id: 'D004',
        customerId: 'C002',
        amount: 85000,
        description: 'Belanja bulanan',
        date: now.subtract(const Duration(days: 2)),
      ),
      Debt(
        id: 'D005',
        customerId: 'C003',
        amount: 67000,
        description: 'Beli beras dan minyak',
        date: now.subtract(const Duration(days: 4)),
      ),
    ];
  }
}
