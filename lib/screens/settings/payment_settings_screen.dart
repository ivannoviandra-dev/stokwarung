import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../utils/snackbar_helper.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_header.dart';

class PaymentSettingsScreen extends StatefulWidget {
  const PaymentSettingsScreen({super.key});

  @override
  State<PaymentSettingsScreen> createState() => _PaymentSettingsScreenState();
}

class _PaymentSettingsScreenState extends State<PaymentSettingsScreen> {
  bool _tunaiActive = true;
  bool _transferActive = true;
  bool _qrisActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('Metode Pembayaran Toko'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Metode Pembayaran Tersedia'),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  _buildPaymentSwitchTile(
                    title: 'Tunai / Cash',
                    subtitle: 'Pembayaran langsung dengan uang kertas/logam',
                    icon: Icons.payments_outlined,
                    value: _tunaiActive,
                    onChanged: (val) {
                      setState(() {
                        _tunaiActive = val;
                      });
                      SnackbarHelper.showInfo(
                        context,
                        val ? 'Metode Tunai diaktifkan' : 'Metode Tunai dinonaktifkan',
                      );
                    },
                  ),
                  const Divider(indent: 56),
                  _buildPaymentSwitchTile(
                    title: 'Transfer Bank',
                    subtitle: 'Rekening bank toko manual (BCA, Mandiri, BRI)',
                    icon: Icons.account_balance_outlined,
                    value: _transferActive,
                    onChanged: (val) {
                      setState(() {
                        _transferActive = val;
                      });
                      SnackbarHelper.showInfo(
                        context,
                        val ? 'Metode Transfer Bank diaktifkan' : 'Metode Transfer Bank dinonaktifkan',
                      );
                    },
                  ),
                  const Divider(indent: 56),
                  _buildPaymentSwitchTile(
                    title: 'QRIS e-Wallet',
                    subtitle: 'Pembayaran praktis dengan GoPay, OVO, Dana, LinkAja',
                    icon: Icons.qr_code_2_outlined,
                    value: _qrisActive,
                    onChanged: (val) {
                      setState(() {
                        _qrisActive = val;
                      });
                      SnackbarHelper.showInfo(
                        context,
                        val ? 'Metode QRIS diaktifkan' : 'Metode QRIS dinonaktifkan',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.appColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: context.appColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: textTheme.bodySmall?.copyWith(color: context.appColors.textSecondary),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
