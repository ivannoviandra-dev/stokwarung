/// StokWarung Constants — Spacing, Radius, and Design Tokens
///
/// Based on the 8px rhythm from the Pro-Micro Merchant design system.
class AppConstants {
  AppConstants._();

  // ─── Spacing (8px base rhythm) ───
  static const double spacingXxs = 2;
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 20;
  static const double spacingXxl = 24;
  static const double spacingXxxl = 32;

  // ─── Container ───
  static const double containerMargin = 16;
  static const double gutter = 12;
  static const double cardPadding = 20;
  static const double sectionGap = 24;

  // ─── Border Radius ───
  static const double radiusSm = 4;
  static const double radiusDefault = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 9999;

  // ─── Touch Target ───
  static const double minTouchTarget = 44;

  // ─── Icon Size ───
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;

  // ─── Elevation ───
  static const double elevationCard = 0;
  static const double elevationFloating = 4;

  // ─── Animation Duration ───
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);

  // ─── App Strings ───
  static const String appName = 'StokWarung';
  static const String appTagline = 'Kelola warung lebih mudah';

  // ─── Supabase (Placeholder) ───
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key';

  // ─── Categories ───
  static const List<String> productCategories = [
    'Semua',
    'Minuman',
    'Sembako',
    'Rokok',
    'Snack',
    'Bumbu',
    'Frozen',
    'Lainnya',
  ];

  // ─── Payment Methods ───
  static const List<String> paymentMethods = [
    'Tunai',
    'Transfer',
    'QRIS',
  ];
}
