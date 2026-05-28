import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/customer_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/customer_card.dart';
import '../../widgets/search_bar_widget.dart';

import '../../widgets/empty_state.dart';

class DebtListScreen extends StatefulWidget {
  const DebtListScreen({super.key});

  @override
  State<DebtListScreen> createState() => _DebtListScreenState();
}

class _DebtListScreenState extends State<DebtListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().loadCustomers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final customerProvider = context.watch<CustomerProvider>();

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('Buku Utang Pelanggan'),
      ),
      body: Column(
        children: [
          // Global outstanding receivables header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: context.appColors.error.withValues(alpha: 0.08),
            child: Column(
              children: [
                Text(
                  'TOTAL UTANG PELANGGAN',
                  style: textTheme.labelMedium?.copyWith(
                    color: context.appColors.error,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  CurrencyFormatter.format(customerProvider.totalReceivables),
                  style: textTheme.headlineLarge?.copyWith(
                    color: context.appColors.error,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dari ${customerProvider.customersWithDebt} pelanggan belum lunas',
                  style: textTheme.bodySmall?.copyWith(color: context.appColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchBarWidget(
              hintText: 'Cari nama pelanggan...',
              controller: _searchController,
              onChanged: (val) {
                customerProvider.searchCustomers(val);
              },
            ),
          ),
          const SizedBox(height: 8),

          // Customers List
          Expanded(
            child: customerProvider.isLoading
                ? Center(child: CircularProgressIndicator(color: context.appColors.primary))
                : customerProvider.customers.isEmpty
                    ? const EmptyState(
                        icon: Icons.assignment_turned_in_outlined,
                        title: 'Tidak ada data utang',
                        description: 'Semua utang pelanggan telah lunas atau nama tidak ditemukan.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: customerProvider.customers.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final customer = customerProvider.customers[index];
                          return CustomerCard(
                            customer: customer,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.debtDetail,
                                arguments: customer.id,
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}