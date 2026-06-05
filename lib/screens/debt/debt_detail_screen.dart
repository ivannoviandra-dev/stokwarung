import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/customer_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/validators.dart';

import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_chip.dart';

class DebtDetailScreen extends StatefulWidget {
  final String customerId;

  const DebtDetailScreen({super.key, required this.customerId});

  @override
  State<DebtDetailScreen> createState() => _DebtDetailScreenState();
}

class _DebtDetailScreenState extends State<DebtDetailScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showAddDebtDialog(BuildContext context, CustomerProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Catatan Utang'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  label: 'Nominal Utang (Rp)',
                  hint: 'Contoh: 15000',
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  validator: (val) => Validators.number(val, 'Nominal utang'),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Keterangan Belanja',
                  hint: 'Beras 1kg, Telur 1/2kg, dll.',
                  controller: _descriptionController,
                  validator: (val) => Validators.required(val, 'Keterangan'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _amountController.clear();
                _descriptionController.clear();
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: context.appColors.primary),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final amount = double.tryParse(_amountController.text) ?? 0;
                  provider.addDebt(
                    customerId: widget.customerId,
                    amount: amount,
                    description: _descriptionController.text.trim(),
                  );
                  SnackbarHelper.showSuccess(context, 'Catatan utang ditambahkan');
                  _amountController.clear();
                  _descriptionController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final customerProvider = context.watch<CustomerProvider>();
    final customer = customerProvider.getCustomerById(widget.customerId);

    if (customer == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Pelanggan')),
        body: const Center(child: Text('Pelanggan tidak ditemukan')),
      );
    }

    final debts = customerProvider.getDebtsForCustomer(widget.customerId);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: Text(customer.name),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: context.appColors.primary),
            onPressed: () => _showAddDebtDialog(context, customerProvider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer debt overview card
            AppCard(
              accentColor: customer.totalDebt > 0 ? context.appColors.error : context.appColors.success,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL TAGIHAN UTANG',
                            style: textTheme.labelMedium?.copyWith(
                              color: context.appColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            CurrencyFormatter.format(customer.totalDebt),
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: customer.totalDebt > 0 ? context.appColors.error : context.appColors.success,
                            ),
                          ),
                        ],
                      ),
                      StatusChip(
                        label: customer.statusLabel,
                        type: customer.totalDebt > 0 ? StatusChipType.danger : StatusChipType.success,
                      ),
                    ],
                  ),
                  if (customer.phone != null) ...[
                    const Divider(height: 32),
                    Row(
                      children: [
                        Icon(Icons.phone_outlined, size: 20, color: context.appColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          customer.phone!,
                          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Invoices logs
            const SectionHeader(title: 'Riwayat Tagihan & Pembayaran'),
            const SizedBox(height: 8),
            if (debts.isEmpty)
              AppCard(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  child: Text(
                    'Belum ada riwayat transaksi utang.',
                    style: textTheme.bodyMedium?.copyWith(color: context.appColors.textSecondary),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: debts.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final debt = debts[index];
                  return AppCard(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: debt.isPaid ? Colors.white.withValues(alpha: 0.6) : Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    CurrencyFormatter.format(debt.amount),
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: debt.isPaid ? context.appColors.textSecondary : context.appColors.error,
                                      decoration: debt.isPaid ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  StatusChip(
                                    label: debt.isPaid ? 'Lunas' : 'Belum Lunas',
                                    type: debt.isPaid ? StatusChipType.success : StatusChipType.danger,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                debt.description,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: debt.isPaid ? context.appColors.textSecondary : context.appColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormatter.formatShort(debt.date),
                                style: textTheme.bodySmall?.copyWith(color: context.appColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        if (!debt.isPaid)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.appColors.primaryContainer,
                              minimumSize: const Size(64, 36),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            onPressed: () {
                              customerProvider.markDebtPaid(debt.id);
                              SnackbarHelper.showSuccess(context, 'Tagihan ditandai LUNAS');
                            },
                            child: const Text('Bayar'),
                          ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}