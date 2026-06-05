import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/transaction_provider.dart';
import '../dashboard/dashboard_screen.dart';
import '../kasir/kasir_screen.dart';
import '../reports/report_screen.dart';
import '../profile/profile_screen.dart';
import '../../utils/snackbar_helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = const [
    DashboardScreen(),
    KasirScreen(),
    ReportScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
        final navProvider = context.watch<NavigationProvider>();
    final cartProvider = context.watch<TransactionProvider>();
    final currentIndex = navProvider.currentIndex;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => navProvider.setIndex(index),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.dashboard_outlined),
                  activeIcon: Icon(Icons.dashboard, color: context.appColors.primary),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                    label: Text(cartProvider.cartItemCount.toString()),
                    isLabelVisible: cartProvider.cartItemCount > 0,
                    backgroundColor: context.appColors.primaryContainer,
                    textColor: Colors.white,
                    child: const Icon(Icons.point_of_sale_outlined),
                  ),
                  activeIcon: Icon(Icons.point_of_sale, color: context.appColors.primary),
                  label: 'Kasir',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.bar_chart_outlined),
                  activeIcon: Icon(Icons.bar_chart, color: context.appColors.primary),
                  label: 'Laporan',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person, color: context.appColors.primary),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                _simulateBarcodeScan(context);
              },
              backgroundColor: context.appColors.primary,
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            )
          : null,
    );
  }

  void _simulateBarcodeScan(BuildContext context) {
    SnackbarHelper.showInfo(
      context,
      'Scanner barcode akan aktif setelah data produk tersambung ke Supabase.',
    );
  }
}
