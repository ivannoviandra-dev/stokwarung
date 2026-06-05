/// Employee model for staff management.
class Employee {
  final String id;
  final String name;
  final String role; // 'Admin' or 'Kasir'
  final String phone;
  final bool isActive;
  final DateTime joinedAt;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    this.isActive = true,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  Employee copyWith({
    String? id,
    String? name,
    String? role,
    String? phone,
    bool? isActive,
    DateTime? joinedAt,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      phone: json['phone'] as String,
      isActive: json['is_active'] as bool? ?? true,
      joinedAt: json['joined_at'] != null
          ? DateTime.parse(json['joined_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'phone': phone,
      'is_active': isActive,
      'joined_at': joinedAt.toIso8601String(),
    };
  }

  static List<Employee> sampleEmployees() {
    return [
      Employee(
        id: 'E001',
        name: 'Ahmad Fauzi',
        role: 'Admin',
        phone: '081234567890',
        isActive: true,
        joinedAt: DateTime(2024, 1, 15),
      ),
      Employee(
        id: 'E002',
        name: 'Siti Rahayu',
        role: 'Kasir',
        phone: '082345678901',
        isActive: true,
        joinedAt: DateTime(2024, 3, 20),
      ),
      Employee(
        id: 'E003',
        name: 'Budi Santoso',
        role: 'Kasir',
        phone: '083456789012',
        isActive: false,
        joinedAt: DateTime(2024, 2, 10),
      ),
    ];
  }
}
