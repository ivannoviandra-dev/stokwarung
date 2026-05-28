import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../utils/snackbar_helper.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'owner@warungku.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (mounted) {
      if (success) {
        SnackbarHelper.showSuccess(context, 'Selamat datang kembali!');
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      } else {
        SnackbarHelper.showError(
          context,
          authProvider.errorMessage ?? 'Gagal masuk. Silakan periksa kembali akun Anda.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isLoading = context.watch<AuthProvider>().isLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      message: 'Menghubungkan ke server...',
      child: Scaffold(
        backgroundColor: context.appColors.background,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Brand Logo & Title
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.appColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.storefront,
                        color: context.appColors.primary,
                        size: 64,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'StokWarung',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineLarge?.copyWith(
                      color: context.appColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Aplikasi manajemen stok dan transaksi warung mikro',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Input Fields Card
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Masuk Akun',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppTextField(
                          label: 'Email Toko',
                          hint: 'Contoh: warung@berkah.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
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
                          hint: 'Masukkan password Anda',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
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
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: AppButton.text(
                            label: 'Lupa Password?',
                            isFullWidth: false,
                            onPressed: () {
                              SnackbarHelper.showInfo(
                                context,
                                'Fitur lupa password sedang dalam pengembangan.',
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        AppButton(
                          label: 'Masuk Sekarang',
                          onPressed: _handleLogin,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun?',
                        style: textTheme.bodyMedium?.copyWith(
                          color: context.appColors.textSecondary,
                        ),
                      ),
                      AppButton.text(
                        label: 'Daftar Toko',
                        isFullWidth: false,
                        onPressed: () {
                          SnackbarHelper.showInfo(
                            context,
                            'Hubungi Sales/Support untuk registrasi kemitraan.',
                          );
                        },
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
