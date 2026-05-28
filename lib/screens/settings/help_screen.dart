import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../utils/snackbar_helper.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_header.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _searchController = TextEditingController();

  final List<Map<String, String>> _faqs = [
    {
      'q': 'Bagaimana cara menambahkan stok barang baru?',
      'a': 'Masuk ke menu Dashboard, klik tombol "+" di pojok kanan atas atau klik tombol "Katalog Produk" lalu pilih "Tambah Produk Baru". Masukkan info dasar, harga beli/jual, stok awal, dan simpan.'
    },
    {
      'q': 'Bagaimana cara mencatat pembayaran utang pelanggan?',
      'a': 'Masuk ke Buku Utang Pelanggan di menu Profil / Dashboard. Cari nama pelanggan, lalu klik tombol "Bayar" di samping baris invoice yang ingin dilunasi.'
    },
    {
      'q': 'Apakah aplikasi ini bisa digunakan tanpa internet?',
      'a': 'Ya. StokWarung dirancang agar dapat mencatat transaksi penjualan dan melacak stok secara offline. Data akan disinkronisasikan ke database cloud Supabase secara otomatis saat Anda terhubung kembali ke internet.'
    },
    {
      'q': 'Bagaimana cara membagikan struk penjualan ke pelanggan?',
      'a': 'Setiap kali transaksi diselesaikan di Kasir POS, Anda akan diberikan pilihan untuk mencetak struk lewat printer thermal bluetooth atau membagikan gambar/teks struk digital langsung ke nomor WhatsApp pelanggan.'
    },
  ];

  List<Map<String, String>> _filteredFaqs = [];

  @override
  void initState() {
    super.initState();
    _filteredFaqs = List.from(_faqs);
  }

  void _filterFaqs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFaqs = List.from(_faqs);
      } else {
        _filteredFaqs = _faqs
            .where((faq) =>
                faq['q']!.toLowerCase().contains(query.toLowerCase()) ||
                faq['a']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('Bantuan & Dukungan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CS Contact Card
            const SectionHeader(title: 'Hubungi Customer Service'),
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Butuh Bantuan Lebih Cepat?',
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tim support kami siap membantu operasional warung Anda setiap hari pukul 08:00 - 21:00 WIB.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(color: context.appColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'WhatsApp Support',
                          icon: Icons.chat_bubble_outline,
                          onPressed: () {
                            SnackbarHelper.showSuccess(context, 'Membuka chat WhatsApp Support (+62 812-3456-7890)');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton.outlined(
                          label: 'Call Center',
                          icon: Icons.phone_in_talk_outlined,
                          onPressed: () {
                            SnackbarHelper.showSuccess(context, 'Melakukan panggilan ke Call Center 1500-999');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // FAQs search
            const SectionHeader(title: 'Pertanyaan Populer (FAQ)'),
            SearchBarWidget(
              hintText: 'Cari topik bantuan...',
              controller: _searchController,
              onChanged: _filterFaqs,
            ),
            const SizedBox(height: 12),

            // FAQs list
            _filteredFaqs.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Topik tidak ditemukan.',
                        style: textTheme.bodyMedium?.copyWith(color: context.appColors.textSecondary),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredFaqs.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final faq = _filteredFaqs[index];
                      return AppCard(
                        padding: const EdgeInsets.all(16),
                        child: ExpansionTile(
                          title: Text(
                            faq['q']!,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.appColors.textPrimary,
                            ),
                          ),
                          childrenPadding: const EdgeInsets.all(8),
                          tilePadding: EdgeInsets.zero,
                          collapsedIconColor: context.appColors.primary,
                          iconColor: context.appColors.primary,
                          shape: const Border(),
                          collapsedShape: const Border(),
                          children: [
                            Text(
                              faq['a']!,
                              style: textTheme.bodyMedium?.copyWith(
                                color: context.appColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
