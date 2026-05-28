import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/customer_model.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/customer_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/snackbar_helper.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/cart_item_tile.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/section_header.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _customerController = TextEditingController();
  final _notesController = TextEditingController();
  final _cashReceivedController = TextEditingController();
  double _change = 0;

  @override
  void dispose() {
    _customerController.dispose();
    _notesController.dispose();
    _cashReceivedController.dispose();
    super.dispose();
  }

  void _calculateChange(double cartTotal) {
    final cash = double.tryParse(_cashReceivedController.text) ?? 0;
    setState(() {
      _change = cash - cartTotal;
      if (_change < 0) _change = 0;
    });
  }

  Future<void> _handleCheckout(TransactionProvider provider, double total) async {
    // If QRIS or Bank Transfer, customer name is useful. If Cash, check cash received
    final paymentMethod = provider.selectedPaymentMethod;
    if (paymentMethod == 'Tunai') {
      final cash = double.tryParse(_cashReceivedController.text) ?? 0;
      if (cash < total) {
        SnackbarHelper.showError(context, 'Uang tunai yang diterima kurang!');
        return;
      }
    }

    final success = await provider.checkout(
      customerName: _customerController.text.trim().isNotEmpty
          ? _customerController.text.trim()
          : null,
    );

    if (mounted) {
      if (success) {
        // If customer was specified and it is transfer/qris or even cash, log customer stats
        if (_customerController.text.trim().isNotEmpty) {
          final customerProvider = context.read<CustomerProvider>();
          // Find or create customer
          final existing = customerProvider.allCustomers.where(
            (c) => c.name.toLowerCase() == _customerController.text.trim().toLowerCase(),
          );
          if (existing.isEmpty) {
            customerProvider.addCustomer(
              Customer(
                id: 'C${DateTime.now().millisecondsSinceEpoch}',
                name: _customerController.text.trim(),
                totalDebt: 0,
                invoiceCount: 0,
                lastTransaction: DateTime.now(),
              ),
            );
          }
        }

        _showSuccessDialog(total);
      } else {
        SnackbarHelper.showError(context, 'Transaksi gagal diproses.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final transactionProvider = context.watch<TransactionProvider>();
    final cartItems = transactionProvider.cart;
    final total = transactionProvider.cartTotal;
    final selectedMethod = transactionProvider.selectedPaymentMethod;

    return LoadingOverlay(
      isLoading: transactionProvider.isLoading,
      message: 'Memproses transaksi...',
      child: Scaffold(
        backgroundColor: context.appColors.background,
        appBar: AppBar(
          title: const Text('Pembayaran'),
        ),
        body: cartItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 64, color: context.appColors.textHint),
                    const SizedBox(height: 16),
                    Text(
                      'Keranjang belanja kosong',
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    AppButton(
                      label: 'Kembali ke Kasir',
                      isFullWidth: false,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cart lists
                    const SectionHeader(title: 'Rincian Belanja'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.appColors.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x05000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return CartItemTile(
                            cartItem: item,
                            onIncrement: () =>
                                transactionProvider.incrementQuantity(item.product.id),
                            onDecrement: () =>
                                transactionProvider.decrementQuantity(item.product.id),
                            onRemove: () =>
                                transactionProvider.removeFromCart(item.product.id),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Payment Method selector
                    const SectionHeader(title: 'Metode Pembayaran'),
                    Row(
                      children: ['Tunai', 'Transfer', 'QRIS'].map((method) {
                        final isSelected = selectedMethod == method;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => transactionProvider.setPaymentMethod(method),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? context.appColors.primary : context.appColors.cardBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? context.appColors.primary : context.appColors.inputBorder,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x05000000),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    method == 'Tunai'
                                        ? Icons.payments_outlined
                                        : method == 'Transfer'
                                            ? Icons.account_balance_outlined
                                            : Icons.qr_code_2_outlined,
                                    color: isSelected ? Colors.white : context.appColors.textSecondary,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    method,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : context.appColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Cash Received (if Cash method)
                    if (selectedMethod == 'Tunai') ...[
                      const SectionHeader(title: 'Penerimaan Uang'),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.appColors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.appColors.inputBorder),
                        ),
                        child: Column(
                          children: [
                            AppTextField(
                              label: 'Uang Diterima (Rp)',
                              hint: 'Masukkan jumlah tunai',
                              controller: _cashReceivedController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => _calculateChange(total),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Kembalian:',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: context.appColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.format(_change),
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _change > 0 ? context.appColors.primary : context.appColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Customer Name (Optional / Mandatory for Debt tracking)
                    const SectionHeader(title: 'Informasi Pelanggan (Opsional)'),
                    AppTextField(
                      label: 'Nama Pelanggan',
                      hint: 'Masukkan nama pelanggan (misal: Pak Budi)',
                      controller: _customerController,
                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      label: 'Catatan Transaksi',
                      hint: 'Tambahkan catatan jika ada',
                      controller: _notesController,
                      prefixIcon: const Icon(Icons.edit_note_outlined, size: 20),
                    ),
                    const SizedBox(height: 40),

                    // Checkout Total Invoice bar
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.appColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TOTAL TAGIHAN',
                                style: textTheme.labelMedium?.copyWith(
                                  color: context.appColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                CurrencyFormatter.format(total),
                                style: textTheme.headlineMedium?.copyWith(
                                  color: context.appColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            label: 'Konfirmasi Pembayaran',
                            onPressed: () => _handleCheckout(transactionProvider, total),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  void _showSuccessDialog(double total) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          icon: Icon(
            Icons.check_circle,
            color: context.appColors.success,
            size: 64,
          ),
          title: const Text('Transaksi Berhasil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pembayaran senilai',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(total),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: context.appColors.primary,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Stok barang otomatis terpotong.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
              ),
              onPressed: () {
                // Clear dialog
                Navigator.pop(context);
                // Go back to main cashier screen
                Navigator.pop(context);
              },
              child: const Text('Selesai'),
            ),
          ],
        );
      },
    );
  }
}