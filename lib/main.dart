import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'services/supabase_service.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/customer_provider.dart';
import 'providers/report_provider.dart';
import 'providers/employee_provider.dart';
import 'providers/store_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system navigation overlay styling for premium mobile-first look
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Supabase client placeholder
  final supabase = SupabaseService.instance;
  await supabase.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const StokWarungApp(),
    ),
  );
}

class StokWarungApp extends StatelessWidget {
  const StokWarungApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthProvider>().isAuthenticated;
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'StokWarung',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: isAuthenticated ? AppRoutes.main : AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
