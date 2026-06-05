import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../utils/validators.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/section_header.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? productId;

  const ProductDetailScreen({super.key, this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _buyPriceController = TextEditingController();
  final _sellPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _minStockController = TextEditingController(text: '5');
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Sembako';
  DateTime? _selectedExpiryDate;
  double _profitMargin = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.productId != null) {
        final product = context.read<ProductProvider>().getProductById(widget.productId!);
        if (product != null) {
          _populateProductData(product);
        }
      }
    });
  }

  void _populateProductData(Product product) {
    setState(() {
      _nameController.text = product.name;
      _barcodeController.text = product.barcode ?? '';
      _buyPriceController.text = product.buyPrice.toStringAsFixed(0);
      _sellPriceController.text = product.sellPrice.toStringAsFixed(0);
      _stockController.text = product.stock.toString();
      _minStockController.text = product.minStock.toString();
      _descriptionController.text = product.description ?? '';
      _selectedCategory = product.category;
      _selectedExpiryDate = product.expiryDate;
      _calculateMargin();
    });
  }

  void _calculateMargin() {
    final buy = double.tryParse(_buyPriceController.text) ?? 0;
    final sell = double.tryParse(_sellPriceController.text) ?? 0;
    setState(() {
      if (sell > 0) {
        _profitMargin = ((sell - buy) / sell) * 100;
      } else {
        _profitMargin = 0;
      }
    });
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedExpiryDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.appColors.primary,
              onPrimary: Colors.white,
              onSurface: context.appColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedExpiryDate = picked;
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final buyPrice = double.tryParse(_buyPriceController.text) ?? 0;
    final sellPrice = double.tryParse(_sellPriceController.text) ?? 0;
    final stock = int.tryParse(_stockController.text) ?? 0;
    final minStock = int.tryParse(_minStockController.text) ?? 5;

    final productProvider = context.read<ProductProvider>();

    final updatedProduct = Product(
      id: widget.productId ?? 'P${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      barcode: _barcodeController.text.trim().isNotEmpty ? _barcodeController.text.trim() : null,
      buyPrice: buyPrice,
      sellPrice: sellPrice,
      stock: stock,
      minStock: minStock,
      category: _selectedCategory,
      expiryDate: _selectedExpiryDate,
      description: _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : null,
    );

    if (widget.productId == null) {
      await productProvider.addProduct(updatedProduct);
      if (mounted) SnackbarHelper.showSuccess(context, 'Produk berhasil ditambahkan!');
    } else {
      await productProvider.updateProduct(updatedProduct);
      if (mounted) SnackbarHelper.showSuccess(context, 'Produk berhasil diperbarui!');
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _triggerBarcodeScan() {
    SnackbarHelper.showInfo(context, 'Membuka kamera pemindai barcode...');
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final mockBarcode = (8990000000000 + DateTime.now().millisecond).toString();
        setState(() {
          _barcodeController.text = mockBarcode;
        });
        SnackbarHelper.showSuccess(context, 'Barcode terpindai: $mockBarcode');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isEditMode = widget.productId != null;
    final isLoading = context.watch<ProductProvider>().isLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      message: 'Menyimpan produk...',
      child: Scaffold(
        backgroundColor: context.appColors.background,
        appBar: AppBar(
          title: Text(isEditMode ? 'Edit Produk' : 'Tambah Produk Baru'),
          actions: [
            if (isEditMode)
              IconButton(
                icon: Icon(Icons.delete_outline, color: context.appColors.error),
                onPressed: () {
                  _showDeleteConfirmDialog();
                },
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Dasar Card
                const SectionHeader(title: 'Informasi Dasar'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.appColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x05000000),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AppTextField(
                        label: 'Nama Produk',
                        hint: 'Contoh: Indomie Goreng Spesial',
                        controller: _nameController,
                        validator: (val) => Validators.required(val, 'Nama produk'),
                      ),
                      const SizedBox(height: 16),
                      // Barcode Scan
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Barcode / SKU (Opsional)',
                              hint: 'Pindai atau masukkan manual',
                              controller: _barcodeController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _triggerBarcodeScan,
                            child: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: context.appColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.qr_code_scanner, color: context.appColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Kategori',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        items: AppConstants.productCategories
                            .where((c) => c != 'Semua')
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedCategory = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Harga & Profit Margin Card
                const SectionHeader(title: 'Harga & Margin Keuntungan'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.appColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x05000000),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Harga Beli (Rp)',
                              hint: '0',
                              controller: _buyPriceController,
                              keyboardType: TextInputType.number,
                              validator: (val) => Validators.number(val, 'Harga beli'),
                              onChanged: (_) => _calculateMargin(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              label: 'Harga Jual (Rp)',
                              hint: '0',
                              controller: _sellPriceController,
                              keyboardType: TextInputType.number,
                              validator: (val) => Validators.number(val, 'Harga jual'),
                              onChanged: (_) => _calculateMargin(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Profit Margin Indicator Row
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: context.appColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Estimasi Margin Keuntungan:',
                              style: textTheme.bodyMedium?.copyWith(
                                color: context.appColors.textSecondary,
                              ),
                            ),
                            Text(
                              '${_profitMargin.toStringAsFixed(1)}%',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _profitMargin > 0 ? context.appColors.primary : context.appColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stok & Kadaluwarsa Card
                const SectionHeader(title: 'Stok & Masa Berlaku'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.appColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x05000000),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Stok Awal',
                              hint: '0',
                              controller: _stockController,
                              keyboardType: TextInputType.number,
                              validator: (val) => Validators.number(val, 'Stok awal'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              label: 'Batas Stok Minimum',
                              hint: '5',
                              controller: _minStockController,
                              keyboardType: TextInputType.number,
                              validator: (val) => Validators.number(val, 'Stok minimum'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Expiry date picker
                      InkWell(
                        onTap: () => _selectExpiryDate(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: context.appColors.inputBorder),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tanggal Kadaluwarsa',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: context.appColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _selectedExpiryDate != null
                                        ? DateFormatter.formatShort(_selectedExpiryDate!)
                                        : 'Pilih Tanggal (Opsional)',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: _selectedExpiryDate != null ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(Icons.calendar_month, color: context.appColors.primary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Tambahan Catatan
                const SectionHeader(title: 'Catatan Tambahan (Opsional)'),
                AppTextField(
                  label: 'Deskripsi Produk',
                  hint: 'Masukkan keterangan detail produk (ukuran, kemasan, dll.)',
                  controller: _descriptionController,
                  maxLines: 3,
                ),
                const SizedBox(height: 40),

                AppButton(
                  label: isEditMode ? 'Simpan Perubahan' : 'Tambah Produk',
                  onPressed: _saveProduct,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: const Text('Apakah Anda yakin ingin menghapus produk ini dari katalog? Tindakan ini tidak dapat dibatalkan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: context.appColors.error),
              onPressed: () {
                context.read<ProductProvider>().deleteProduct(widget.productId!);
                SnackbarHelper.showSuccess(context, 'Produk berhasil dihapus');
                Navigator.pop(context); // Pop dialog
                Navigator.pop(context); // Pop screen
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}