/// User profile model.
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String storeName;
  final bool isPro;
  final int totalTransactions;
  final int activeCustomers;
  final String? avatarUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.storeName,
    this.isPro = false,
    this.totalTransactions = 0,
    this.activeCustomers = 0,
    this.avatarUrl,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? storeName,
    bool? isPro,
    int? totalTransactions,
    int? activeCustomers,
    String? avatarUrl,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      storeName: storeName ?? this.storeName,
      isPro: isPro ?? this.isPro,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      activeCustomers: activeCustomers ?? this.activeCustomers,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      storeName: json['store_name'] as String,
      isPro: json['is_pro'] as bool? ?? false,
      totalTransactions: json['total_transactions'] as int? ?? 0,
      activeCustomers: json['active_customers'] as int? ?? 0,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'store_name': storeName,
      'is_pro': isPro,
      'total_transactions': totalTransactions,
      'active_customers': activeCustomers,
      'avatar_url': avatarUrl,
    };
  }

  static UserProfile sampleUser() {
    return UserProfile(
      id: 'U001',
      name: 'Andi Pratama',
      email: 'andi@warungberkah.com',
      storeName: 'Warung Berkah Jaya',
      isPro: true,
      totalTransactions: 1247,
      activeCustomers: 8,
    );
  }
}
