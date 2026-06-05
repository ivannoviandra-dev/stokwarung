import 'package:flutter/material.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_store_screen.dart';
import '../../screens/main/main_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/products/product_detail_screen.dart';
import '../../screens/kasir/checkout_screen.dart';
import '../../screens/debt/debt_detail_screen.dart';
import '../../screens/settings/store_settings_screen.dart';
import '../../screens/settings/employee_screen.dart';
import '../../screens/settings/payment_settings_screen.dart';
import '../../screens/settings/help_screen.dart';
import '../../screens/reminder/reminder_screen.dart';
import '../../screens/transactions/transaction_history_screen.dart';

/// StokWarung Route Configuration
///
/// Centralized named route definitions and route generator.
class AppRoutes {
  AppRoutes._();

  // ─── Route Names ───
  static const String splash = '/splash';
  static const String login = '/login';
  static const String registerStore = '/register-store';
  static const String main = '/main';
  static const String productDetail = '/product-detail';
  static const String checkout = '/checkout';
  static const String debtDetail = '/debt-detail';
  static const String storeSettings = '/store-settings';
  static const String employees = '/employees';
  static const String paymentSettings = '/payment-settings';
  static const String help = '/help';
  static const String reminder = '/reminder';
  static const String transactionHistory = '/transaction-history';

  // ─── Route Generator ───
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashScreen(), settings);

      case login:
        return _buildRoute(const LoginScreen(), settings);

      case registerStore:
        return _buildRoute(const RegisterStoreScreen(), settings);

      case main:
        return _buildRoute(const MainScreen(), settings);

      case productDetail:
        final productId = settings.arguments as String?;
        return _buildRoute(
          ProductDetailScreen(productId: productId),
          settings,
        );

      case checkout:
        return _buildRoute(const CheckoutScreen(), settings);

      case debtDetail:
        final customerId = settings.arguments as String;
        return _buildRoute(
          DebtDetailScreen(customerId: customerId),
          settings,
        );

      case storeSettings:
        return _buildRoute(const StoreSettingsScreen(), settings);

      case employees:
        return _buildRoute(const EmployeeScreen(), settings);

      case paymentSettings:
        return _buildRoute(const PaymentSettingsScreen(), settings);

      case help:
        return _buildRoute(const HelpScreen(), settings);

      case reminder:
        return _buildRoute(const ReminderScreen(), settings);

      case transactionHistory:
        return _buildRoute(const TransactionHistoryScreen(), settings);

      default:
        return _buildRoute(
          const Scaffold(
            body: Center(child: Text('Halaman tidak ditemukan')),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
