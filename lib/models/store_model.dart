/// Store settings model for business identity configuration.
class Store {
  final String name;
  final String phone;
  final String address;
  final String? logoUrl;
  final String openTime;
  final String closeTime;
  final bool isOpen;

  Store({
    required this.name,
    required this.phone,
    required this.address,
    this.logoUrl,
    this.openTime = '07:00',
    this.closeTime = '22:00',
    this.isOpen = true,
  });

  Store copyWith({
    String? name,
    String? phone,
    String? address,
    String? logoUrl,
    String? openTime,
    String? closeTime,
    bool? isOpen,
  }) {
    return Store(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      logoUrl: logoUrl ?? this.logoUrl,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      isOpen: isOpen ?? this.isOpen,
    );
  }

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      name: json['name'] as String? ?? 'Toko Saya',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      logoUrl: json['logo_url'] as String?,
      openTime: json['open_time'] as String? ?? '07:00',
      closeTime: json['close_time'] as String? ?? '22:00',
      isOpen: json['is_open'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'logo_url': logoUrl,
      'open_time': openTime,
      'close_time': closeTime,
      'is_open': isOpen,
    };
  }

  static Store empty() {
    return Store(
      name: 'Toko Saya',
      phone: '',
      address: '',
    );
  }

  static Store sampleStore() {
    return Store(
      name: 'Warung Berkah Jaya',
      phone: '081234567890',
      address: 'Jl. Merdeka No. 45, Jakarta Selatan',
      openTime: '07:00',
      closeTime: '22:00',
      isOpen: true,
    );
  }
}
