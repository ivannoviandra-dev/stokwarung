import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../providers/customer_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../utils/snackbar_helper.dart';
import '../../widgets/app_card.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final productProvider = context.watch<ProductProvider>();
    final customerProvider = context.watch<CustomerProvider>();

    final lowStockItems = productProvider.lowStockProducts;
    final outOfStockItems = productProvider.outOfStockProducts;
    final expiringItems = productProvider.expiringProducts;
    final customersWithDebt = customerProvider.allCustomers.where((c) => c.totalDebt > 0).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: context.appColors.background,
        appBar: AppBar(
          title: const Text('Pusat Pengingat Toko'),
          bottom: TabBar(
            indicatorColor: context.appColors.primary,
            labelColor: context.appColors.primary,
            unselectedLabelColor: context.appColors.textSecondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                child: Badge(
                  isLabelVisible: lowStockItems.length + outOfStockItems.length > 0,
                  label: Text('${lowStockItems.length + outOfStockItems.length}'),
                  backgroundColor: context.appColors.error,
                  child: const Text('Stok Habis'),
                ),
              ),
              Tab(
                child: Badge(
                  isLabelVisible: expiringItems.isNotEmpty,
                  label: Text('${expiringItems.length}'),
                  backgroundColor: context.appColors.warning,
                  child: const Text('Masa Berlaku'),
                ),
              ),
              Tab(
                child: Badge(
                  isLabelVisible: customersWithDebt.isNotEmpty,
                  label: Text('${customersWithDebt.length}'),
                  backgroundColor: context.appColors.error,
                  child: const Text('Jatuh Tempo'),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Low Stock / Out of Stock
            _buildStockReminders(context, lowStockItems, outOfStockItems, textTheme),

            // Tab 2: Expiring Items
            _buildExpiryReminders(context, expiringItems, textTheme),

            // Tab 3: Late Customer Debts
            _buildDebtReminders(context, customersWithDebt, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildStockReminders(
    BuildContext context,
    List<dynamic> lowStock,
    List<dynamic> outOfStock,
    TextTheme textTheme,
  ) {
    final all = [...outOfStock, ...lowStock];

    if (all.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 48, color: context.appColors.success),
            SizedBox(height: 12),
            Text('Semua stok barang aman!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: all.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = all[index];
        final isOutOfStock = item.stock <= 0;
        return AppCard(
          accentColor: isOutOfStock ? context.appColors.error : context.appColors.warning,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(
                isOutOfStock ? Icons.dangerous_outlined : Icons.warning_amber_rounded,
                color: isOutOfStock ? context.appColors.error : context.appColors.warning,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isOutOfStock ? 'Stok HABIS' : 'Tersisa ${item.stock} item (Batas: ${item.minStock})',
                      style: textTheme.bodySmall?.copyWith(color: context.appColors.textSecondary),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(72, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.productDetail,
                    arguments: item.id,
                  );
                },
                child: const Text('Restok'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpiryReminders(
    BuildContext context,
    List<dynamic> items,
    TextTheme textTheme,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 48, color: context.appColors.success),
            SizedBox(height: 12),
            Text('Tidak ada barang mendekati kadaluwarsa!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];
        final isExpired = item.isExpired;
        return AppCard(
          accentColor: isExpired ? context.appColors.error : context.appColors.warning,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(
                isExpired ? Icons.history_toggle_off_rounded : Icons.calendar_today_outlined,
                color: isExpired ? context.appColors.error : context.appColors.warning,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isExpired
                          ? 'SUDAH KADALUWARSA (${DateFormatter.formatShort(item.expiryDate!)})'
                          : 'Kadaluwarsa: ${DateFormatter.formatShort(item.expiryDate!)}',
                      style: textTheme.bodySmall?.copyWith(color: context.appColors.textSecondary),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appColors.error.withValues(alpha: 0.1),
                  foregroundColor: context.appColors.error,
                  minimumSize: const Size(72, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onPressed: () {
                  SnackbarHelper.showSuccess(context, 'Tindakan restok / return barang diajukan');
                },
                child: const Text('Return'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDebtReminders(
    BuildContext context,
    List<dynamic> customers,
    TextTheme textTheme,
  ) {
    if (customers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 48, color: context.appColors.success),
            SizedBox(height: 12),
            Text('Semua piutang pelanggan lunas!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: customers.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final customer = customers[index];
        return AppCard(
          accentColor: context.appColors.error,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(
                Icons.assignment_late_outlined,
                color: context.appColors.error,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tunggakan: ${CurrencyFormatter.format(customer.totalDebt)}',
                      style: textTheme.bodySmall?.copyWith(color: context.appColors.textSecondary),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appColors.primaryContainer,
                  minimumSize: const Size(72, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onPressed: () {
                  SnackbarHelper.showSuccess(
                    context,
                    'Kirim tagihan via WhatsApp ke ${customer.name} (+62 8xx-xxxx-xxxx)',
                  );
                },
                child: const Text('Tagih'),
              ),
            ],
          ),
        );
      },
    );
  }
}
