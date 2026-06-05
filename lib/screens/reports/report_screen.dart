import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/report_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/summary_card.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final txProvider = context.read<TransactionProvider>();
      context.read<ReportProvider>().loadReportData(txProvider.transactions);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final reportProvider = context.watch<ReportProvider>();
    final productProvider = context.watch<ProductProvider>();

    final lowStockCount = productProvider.lowStockProducts.length;

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('Laporan & Laba'),
        actions: [
          DropdownButton<String>(
            value: reportProvider.selectedPeriod,
            items: ['Hari Ini', 'Minggu Ini', 'Bulan Ini'].map((p) {
              return DropdownMenuItem(
                value: p,
                child: Text(
                  p,
                  style: TextStyle(fontWeight: FontWeight.bold, color: context.appColors.primary),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                reportProvider.setPeriod(val);
              }
            },
            underline: const SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: context.appColors.primary),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: reportProvider.isLoading
          ? Center(child: CircularProgressIndicator(color: context.appColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Grid
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Total Omzet',
                          value: CurrencyFormatter.format(reportProvider.totalOmzet),
                          icon: Icons.payments_outlined,
                          color: context.appColors.primary,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Total Laba Kotor',
                          value: CurrencyFormatter.format(reportProvider.totalProfit),
                          icon: Icons.auto_graph,
                          color: context.appColors.success.withValues(alpha: 0.08),
                          textColor: context.appColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          title: 'Transaksi',
                          value: reportProvider.totalTransactions.toString(),
                          icon: Icons.shopping_bag_outlined,
                          color: context.appColors.info.withValues(alpha: 0.08),
                          textColor: context.appColors.info,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'SKU Stok Menipis',
                          value: lowStockCount.toString(),
                          icon: Icons.report_problem_outlined,
                          color: context.appColors.warning.withValues(alpha: 0.08),
                          textColor: context.appColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Profit Chart
                  const SectionHeader(title: 'Grafik Laba (7 Hari Terakhir)'),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: _getMaxY(reportProvider.dailyProfitData),
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (val, meta) {
                                  final index = val.toInt();
                                  if (index >= 0 && index < reportProvider.dailyProfitData.length) {
                                    final date = reportProvider.dailyProfitData[index].date;
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        _getDayName(date.weekday),
                                        style: textTheme.bodySmall?.copyWith(fontSize: 10),
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(show: false),
                          barGroups: reportProvider.dailyProfitData.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final data = entry.value;
                            return BarChartGroupData(
                              x: idx,
                              barRods: [
                                BarChartRodData(
                                  toY: data.value,
                                  color: context.appColors.primary,
                                  width: 14,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recent transaction feed
                  const SectionHeader(title: 'Aktivitas Transaksi Terbaru'),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: reportProvider.recentTransactions.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Text(
                                'Belum ada transaksi terekam',
                                style: textTheme.bodyMedium?.copyWith(color: context.appColors.textSecondary),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: reportProvider.recentTransactions.length,
                            separatorBuilder: (_, _) => const Divider(),
                            itemBuilder: (context, index) {
                              final tx = reportProvider.recentTransactions[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tx.id,
                                          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          DateFormatter.formatTime(tx.date),
                                          style: textTheme.bodySmall?.copyWith(color: context.appColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '+ ${CurrencyFormatter.format(tx.totalAmount)}',
                                      style: textTheme.titleSmall?.copyWith(
                                        color: context.appColors.success,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  double _getMaxY(List<DailyData> data) {
    double max = 100000;
    for (final d in data) {
      if (d.value > max) {
        max = d.value;
      }
    }
    return max * 1.15;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Sen';
      case 2:
        return 'Sel';
      case 3:
        return 'Rab';
      case 4:
        return 'Kam';
      case 5:
        return 'Jum';
      case 6:
        return 'Sab';
      case 7:
        return 'Min';
      default:
        return '';
    }
  }
}