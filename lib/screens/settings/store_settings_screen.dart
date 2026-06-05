import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';

import '../../providers/store_provider.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/section_header.dart';

class StoreSettingsScreen extends StatefulWidget {
  const StoreSettingsScreen({super.key});

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<StoreProvider>();
      await provider.loadStore();
      if (!mounted) return;

      final store = provider.store;
      _nameController.text = store.name;
      _phoneController.text = store.phone;
      _addressController.text = store.address;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings(StoreProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final updated = provider.store.copyWith(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
    );

    await provider.updateStore(updated);
    if (mounted) {
      if (provider.errorMessage == null) {
        SnackbarHelper.showSuccess(context, 'Identitas toko berhasil disimpan!');
        Navigator.pop(context);
      } else {
        SnackbarHelper.showError(context, provider.errorMessage!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final storeProvider = context.watch<StoreProvider>();
    final store = storeProvider.store;

    return LoadingOverlay(
      isLoading: storeProvider.isLoading,
      message: 'Menyimpan identitas toko...',
      child: Scaffold(
        backgroundColor: context.appColors.background,
        appBar: AppBar(
          title: const Text('Identitas Toko'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store logo upload mock area
                const SectionHeader(title: 'Logo Toko'),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: context.appColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: context.appColors.inputBorder, width: 2),
                        ),
                        child: Icon(
                          Icons.storefront,
                          size: 48,
                          color: context.appColors.primary,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: context.appColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Core Info
                const SectionHeader(title: 'Informasi Utama'),
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      AppTextField(
                        label: 'Nama Toko',
                        hint: 'Masukkan nama warung/toko',
                        controller: _nameController,
                        validator: (val) => Validators.required(val, 'Nama toko'),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Nomor Telepon Toko',
                        hint: 'Masukkan nomor WhatsApp/kontak toko',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: Validators.phone,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Alamat Lengkap Toko',
                        hint: 'Jalan, RT/RW, Kecamatan, Kota',
                        controller: _addressController,
                        maxLines: 2,
                        validator: (val) => Validators.required(val, 'Alamat toko'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Operational hours
                const SectionHeader(title: 'Waktu Operasional'),
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status Warung Buka:',
                            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Switch(
                            value: store.isOpen,
                            onChanged: (val) async {
                              await storeProvider.toggleOpenStatus();
                              if (!context.mounted) return;
                              SnackbarHelper.showInfo(
                                context,
                                val ? 'Status warung diatur BUKA' : 'Status warung diatur TUTUP',
                              );
                            },
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                SnackbarHelper.showInfo(context, 'Pilih waktu buka');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: context.appColors.inputBorder),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Jam Buka', style: textTheme.bodySmall),
                                    const SizedBox(height: 2),
                                    Text(store.openTime, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                SnackbarHelper.showInfo(context, 'Pilih waktu tutup');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: context.appColors.inputBorder),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Jam Tutup', style: textTheme.bodySmall),
                                    const SizedBox(height: 2),
                                    Text(store.closeTime, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                AppButton(
                  label: 'Simpan Identitas Toko',
                  onPressed: () => _saveSettings(storeProvider),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
