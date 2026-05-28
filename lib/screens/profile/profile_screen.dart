import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/snackbar_helper.dart';
import '../../widgets/app_card.dart';
import '../../widgets/status_chip.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('Profil Toko & Owner'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User header with PRO badge
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: context.appColors.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: context.appColors.primary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user?.name ?? 'Andi Pratama',
                        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      if (user?.isPro ?? true)
                        const StatusChip(
                          label: 'PRO',
                          type: StatusChipType.success,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'owner@warungberkah.com',
                    style: textTheme.bodySmall?.copyWith(color: context.appColors.textSecondary),
                  ),
                  const Divider(height: 32),
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProfileStat(
                        context,
                        label: 'Transaksi Bulan Ini',
                        value: user?.totalTransactions.toString() ?? '1,247',
                      ),
                      _buildProfileStat(
                        context,
                        label: 'Pelanggan Aktif',
                        value: user?.activeCustomers.toString() ?? '8',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Settings Navigation Tiles
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  _buildThemeToggleTile(context),
                  const Divider(indent: 56),
                  _buildNavTile(
                    context,
                    icon: Icons.storefront_outlined,
                    title: 'Pengaturan Identitas Toko',
                    subtitle: 'Ubah logo, nama, telepon, dan alamat toko',
                    route: AppRoutes.storeSettings,
                  ),
                  const Divider(indent: 56),
                  _buildNavTile(
                    context,
                    icon: Icons.people_alt_outlined,
                    title: 'Kelola Karyawan / Akses',
                    subtitle: 'Atur admin, kasir, dan status aktif staf',
                    route: AppRoutes.employees,
                  ),
                  const Divider(indent: 56),
                  _buildNavTile(
                    context,
                    icon: Icons.payments_outlined,
                    title: 'Metode Pembayaran Toko',
                    subtitle: 'Aktifkan QRIS, Transfer Bank, Tunai',
                    route: AppRoutes.paymentSettings,
                  ),
                  const Divider(indent: 56),
                  _buildNavTile(
                    context,
                    icon: Icons.help_outline,
                    title: 'Bantuan & Dukungan',
                    subtitle: 'Pertanyaan populer, kontak CS, manual digital',
                    route: AppRoutes.help,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appColors.error.withValues(alpha: 0.1),
                foregroundColor: context.appColors.error,
                side: BorderSide(color: context.appColors.error),
                elevation: 0,
              ),
              onPressed: () {
                _showLogoutConfirmDialog(context, authProvider);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 8),
                  Text('Keluar Akun'),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(BuildContext context, {required String label, required String value}) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          value,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: context.appColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: context.appColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildNavTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
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
      trailing: Icon(Icons.chevron_right, size: 20, color: context.appColors.textHint),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }

  Widget _buildThemeToggleTile(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeProvider = context.watch<ThemeProvider>();

    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.appColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          themeProvider.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
          color: context.appColors.primary,
          size: 22,
        ),
      ),
      title: Text(
        'Mode Gelap (Dark Mode)',
        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Ubah tampilan menjadi gelap',
        style: textTheme.bodySmall?.copyWith(color: context.appColors.textSecondary),
      ),
      value: themeProvider.isDarkMode,
      activeThumbColor: context.appColors.onPrimary,
      activeTrackColor: context.appColors.primaryContainer,
      onChanged: (val) {
        themeProvider.toggleTheme();
      },
    );
  }

  void _showLogoutConfirmDialog(BuildContext context, AuthProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Keluar Aplikasi'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun toko Anda?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: context.appColors.error),
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                await provider.signOut();
                if (context.mounted) {
                  SnackbarHelper.showSuccess(context, 'Berhasil keluar');
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                }
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}