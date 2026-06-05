import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/loading_overlay.dart';

class RegisterStoreScreen extends StatefulWidget {
  const RegisterStoreScreen({super.key});

  @override
  State<RegisterStoreScreen> createState() => _RegisterStoreScreenState();
}

class _RegisterStoreScreenState extends State<RegisterStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ownerNameController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _ownerNameController.dispose();
    _storeNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signUp(
      ownerName: _ownerNameController.text.trim(),
      storeName: _storeNameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      if (authProvider.needsEmailConfirmation) {
        SnackbarHelper.showSuccess(
          context,
          'Akun dibuat. Cek email untuk konfirmasi sebelum masuk.',
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (_) => false,
        );
      } else {
        SnackbarHelper.showSuccess(context, 'Akun toko berhasil dibuat!');
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.main,
          (_) => false,
        );
      }
    } else {
      SnackbarHelper.showError(
        context,
        authProvider.errorMessage ?? 'Registrasi gagal. Silakan coba lagi.',
      );
    }
  }

  String? _confirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Konfirmasi password tidak sama';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isLoading = context.watch<AuthProvider>().isLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      message: 'Membuat akun toko...',
      child: Scaffold(
        backgroundColor: context.appColors.background,
        appBar: AppBar(
          title: const Text('Daftar Toko'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: context.appColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_business_rounded,
                        color: context.appColors.primary,
                        size: 52,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Buat Akun Toko',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      color: context.appColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Daftar langsung dan mulai kelola stok warung tanpa menunggu sales atau support.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.appColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        AppTextField(
                          label: 'Nama Pemilik',
                          hint: 'Contoh: Andi Pratama',
                          controller: _ownerNameController,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validators.required(value, 'Nama pemilik'),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: context.appColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 18),
                        AppTextField(
                          label: 'Nama Toko',
                          hint: 'Contoh: Warung Berkah Jaya',
                          controller: _storeNameController,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validators.required(value, 'Nama toko'),
                          prefixIcon: Icon(
                            Icons.storefront_outlined,
                            color: context.appColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 18),
                        AppTextField(
                          label: 'Nomor WhatsApp',
                          hint: 'Contoh: 081234567890',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: Validators.phone,
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: context.appColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 18),
                        AppTextField(
                          label: 'Email',
                          hint: 'Contoh: warung@berkah.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: Validators.email,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: context.appColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 18),
                        AppTextField(
                          label: 'Password',
                          hint: 'Minimal 6 karakter',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          validator: Validators.password,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: context.appColors.textSecondary,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: context.appColors.textSecondary,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                        const SizedBox(height: 18),
                        AppTextField(
                          label: 'Konfirmasi Password',
                          hint: 'Ulangi password',
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          validator: _confirmPassword,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: context.appColors.textSecondary,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: context.appColors.textSecondary,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscureConfirmPassword = !_obscureConfirmPassword,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          label: 'Daftar Sekarang',
                          icon: Icons.arrow_forward_rounded,
                          onPressed: _handleRegister,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun?',
                        style: textTheme.bodyMedium?.copyWith(
                          color: context.appColors.textSecondary,
                        ),
                      ),
                      AppButton.text(
                        label: 'Masuk',
                        isFullWidth: false,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
