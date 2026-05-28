import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:stokwarung/main.dart';
import 'package:stokwarung/providers/auth_provider.dart';
import 'package:stokwarung/providers/product_provider.dart';
import 'package:stokwarung/providers/transaction_provider.dart';
import 'package:stokwarung/providers/customer_provider.dart';
import 'package:stokwarung/providers/report_provider.dart';
import 'package:stokwarung/providers/employee_provider.dart';
import 'package:stokwarung/providers/store_provider.dart';
import 'package:stokwarung/providers/navigation_provider.dart';

void main() {
  testWidgets('App smoke test - verifies brand presence', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
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
        ],
        child: const StokWarungApp(),
      ),
    );

    // Verify that the login page brand name is displayed.
    expect(find.text('StokWarung'), findsAtLeast(1));
    expect(find.text('Masuk Sekarang'), findsOneWidget);
  });
}
