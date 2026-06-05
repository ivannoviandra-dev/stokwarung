import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/empty_state.dart';

class KasirScreen extends StatefulWidget {
  const KasirScreen({super.key});

  @override
  State<KasirScreen> createState() => _KasirScreenState();
}

class _KasirScreenState extends State<KasirScreen> {
  final _searchController = TextEditingController();
  final List<String> _categories = [
    'Semua',
    'Minuman',
    'Sembako',
    'Rokok',
    'Snack',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final transactionProvider = context.watch<TransactionProvider>();
    final selectedCategory = productProvider.selectedCategory;

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('Kasir POS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.transactionHistory);
            },
          ),
          if (transactionProvider.cart.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep_outlined, color: context.appColors.error),
              onPressed: () {
                _showClearCartDialog(context, transactionProvider);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Search area
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SearchBarWidget(
              hintText: 'Cari barang untuk transaksi...',
              controller: _searchController,
              onChanged: (val) {
                productProvider.searchProducts(val);
              },
            ),
          ),

          // Horizontal Category list
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: context.appColors.primary.withValues(alpha: 0.15),
                    checkmarkColor: context.appColors.primary,
                    onSelected: (val) {
                      productProvider.filterByCategory(category);
                    },
                    labelStyle: TextStyle(
                      color: isSelected ? context.appColors.primary : context.appColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),

          // Product List
          Expanded(
            child: productProvider.isLoading
                ? Center(child: CircularProgressIndicator(color: context.appColors.primary))
                : productProvider.products.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off_outlined,
                        title: 'Barang tidak ditemukan',
                        description: 'Silakan cari dengan kata kunci lain atau periksa kategori Anda.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: productProvider.products.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final product = productProvider.products[index];
                          return ProductCard(
                            product: product,
                            onAddToCart: product.stock > 0
                                ? () {
                                    transactionProvider.addToCart(product);
                                  }
                                : null,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.productDetail,
                                arguments: product.id,
                              );
                            },
                          );
                        },
                      ),
          ),

          // Bottom Cart summary
          if (transactionProvider.cart.isNotEmpty)
            _buildCartSummaryPanel(context, transactionProvider),
        ],
      ),
    );
  }

  Widget _buildCartSummaryPanel(BuildContext context, TransactionProvider provider) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL KERANJANG',
                      style: textTheme.labelMedium?.copyWith(
                        color: context.appColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${provider.cartItemCount} Barang',
                      style: textTheme.bodyMedium?.copyWith(
                        color: context.appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  CurrencyFormatter.format(provider.cartTotal),
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.appColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.checkout);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_checkout, size: 20, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Lanjut Pembayaran'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, TransactionProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kosongkan Keranjang'),
          content: const Text('Apakah Anda yakin ingin menghapus semua barang di keranjang?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: context.appColors.error),
              onPressed: () {
                provider.clearCart();
                Navigator.pop(context);
              },
              child: const Text('Kosongkan'),
            ),
          ],
        );
      },
    );
  }
}