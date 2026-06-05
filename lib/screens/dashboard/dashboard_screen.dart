import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/snackbar_helper.dart';
import '../../widgets/app_card.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_header.dart';
import '../../widgets/summary_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
      context.read<CustomerProvider>().loadCustomers();
      context.read<TransactionProvider>().loadTransactions();
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
    final user = context.watch<AuthProvider>().user;
    final productProvider = context.watch<ProductProvider>();
    final customerProvider = context.watch<CustomerProvider>();
    final transactionProvider = context.watch<TransactionProvider>();

    final lowStockCount = productProvider.lowStockProducts.length;
    final expiringCount = productProvider.expiringProducts.length;

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: Text(user?.storeName ?? 'StokWarung'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: lowStockCount + expiringCount > 0,
              backgroundColor: context.appColors.error,
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.reminder);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await productProvider.loadProducts();
          await customerProvider.loadCustomers();
          await transactionProvider.loadTransactions();
        },
        color: context.appColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Header
              Text(
                'Selamat Pagi,',
                style: textTheme.bodyLarge?.copyWith(
                  color: context.appColors.textSecondary,
                ),
              ),
              Text(
                user?.name ?? 'Pemilik Warung',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.appColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // KPI Cards
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Keuntungan Hari Ini',
                      value: CurrencyFormatter.format(transactionProvider.todayProfit),
                      icon: Icons.trending_up,
                      color: context.appColors.primary,
                      textColor: Colors.white,
                      onTap: () {
                        // Navigate to Reports tab (index 2)
                        context.read<NavigationProvider>().setIndex(2);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Utang Pelanggan',
                      value: CurrencyFormatter.format(customerProvider.totalReceivables),
                      subtitle: '${customerProvider.customersWithDebt} pelanggan belum lunas',
                      icon: Icons.assignment_late,
                      color: context.appColors.error.withValues(alpha: 0.08),
                      textColor: context.appColors.error,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.debtDetail, arguments: 'C001');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Alerts section
              if (lowStockCount > 0 || expiringCount > 0) ...[
                const SectionHeader(title: 'Peringatan Penting'),
                const SizedBox(height: 4),
                if (lowStockCount > 0)
                  _buildAlertCard(
                    context,
                    title: '$lowStockCount Barang Hampir Habis',
                    subtitle: 'Segera lakukan restok agar jualan tidak terhambat.',
                    icon: Icons.warning_amber_rounded,
                    color: context.appColors.warning,
                  ),
                if (expiringCount > 0) ...[
                  const SizedBox(height: 8),
                  _buildAlertCard(
                    context,
                    title: '$expiringCount Barang Expiring / Kadaluwarsa',
                    subtitle: 'Periksa tanggal kadaluwarsa produk Anda.',
                    icon: Icons.history_toggle_off_rounded,
                    color: context.appColors.error,
                  ),
                ],
                const SizedBox(height: 20),
              ],

              // Main Inventory Search & List
              SectionHeader(
                title: 'Stok Barang',
                actionLabel: 'Lihat Semua',
                onActionPressed: () {
                  // Direct to Kasir or list (let's keep search active)
                },
              ),
              const SizedBox(height: 8),
              SearchBarWidget(
                hintText: 'Cari produk (Indomie, Beras, Aqua...)',
                controller: _searchController,
                onChanged: (val) {
                  productProvider.searchProducts(val);
                },
                onFilterPressed: () {
                  _showCategoryFilterSheet(context, productProvider);
                },
              ),
              const SizedBox(height: 16),

              // Inventory Listing
              if (productProvider.isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: CircularProgressIndicator(color: context.appColors.primary),
                  ),
                )
              else if (productProvider.products.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 48, color: context.appColors.textHint),
                      const SizedBox(height: 12),
                      Text(
                        'Produk tidak ditemukan',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: productProvider.products.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final product = productProvider.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.productDetail,
                          arguments: product.id,
                        );
                      },
                      onAddToCart: (product.stock > 0)
                          ? () {
                              transactionProvider.addToCart(product);
                              SnackbarHelper.showSuccess(
                                context,
                                '${product.name} berhasil ditambahkan ke keranjang POS',
                              );
                            }
                          : null,
                    );
                  },
                ),
              const SizedBox(height: 80), // extra padding for fab space
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return AppCard(
      accentColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.reminder);
      },
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.appColors.textPrimary,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.appColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 20, color: context.appColors.textHint),
        ],
      ),
    );
  }

  void _showCategoryFilterSheet(BuildContext context, ProductProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Kategori',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Semua',
                  'Minuman',
                  'Sembako',
                  'Rokok',
                  'Snack',
                  'Lainnya',
                ].map((category) {
                  final isSelected = provider.selectedCategory == category;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: context.appColors.primary.withValues(alpha: 0.15),
                    checkmarkColor: context.appColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? context.appColors.primary : context.appColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (val) {
                      provider.filterByCategory(category);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}