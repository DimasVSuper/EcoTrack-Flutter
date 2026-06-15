import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../auth/providers/auth_provider.dart';
import '../../transport/providers/transport_provider.dart';
import '../../transport/models/transport_log.dart';
import '../../electricity/providers/electricity_provider.dart';
import '../../electricity/models/electricity_log.dart';
import '../../transport/views/transport_input_view.dart';
import '../../transport/views/transport_history_view.dart';
import '../../electricity/views/electricity_input_view.dart';
import '../../electricity/views/electricity_history_view.dart';
import '../widgets/tree_equivalency_card.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> with WidgetsBindingObserver {
  void _loadDashboardData() {
    Provider.of<TransportProvider>(context, listen: false).fetchLogs();
    Provider.of<ElectricityProvider>(context, listen: false).fetchLogs();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadDashboardData();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadDashboardData();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final transportProvider = Provider.of<TransportProvider>(context);
    final electricityProvider = Provider.of<ElectricityProvider>(context);
    
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoTrack Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Emisi Anda',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildChartSection(context, transportProvider.logs, electricityProvider.logs)),
                        const SizedBox(width: 24),
                        Expanded(flex: 1, child: _buildSummarySection(context, transportProvider, electricityProvider)),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildSummarySection(context, transportProvider, electricityProvider),
                        const SizedBox(height: 24),
                        _buildChartSection(context, transportProvider.logs, electricityProvider.logs),
                      ],
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBottomSheet(context);
        },
        child: const Icon(Icons.add),
        tooltip: 'Tambah Aktivitas',
      ),
    );
  }

  void _showAddBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.directions_car),
                title: const Text('Input Transportasi'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const TransportInputView()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.electric_bolt),
                title: const Text('Input Listrik'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ElectricityInputView()));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummarySection(BuildContext context, TransportProvider tp, ElectricityProvider ep) {
    final double totalTransport = tp.totalEmission;
    final double totalElectricity = ep.totalEmission;
    final double totalOverall = totalTransport + totalElectricity;

    return Column(
      children: [
        _buildSummaryCard(context, 'Total Emisi', '${totalOverall.toStringAsFixed(1)} kg', Icons.cloud, Colors.orange),
        const SizedBox(height: 16),
        TreeEquivalencyCard(totalEmissionKg: totalOverall),
        const SizedBox(height: 16),
        _buildSummaryCard(
          context, 
          'Emisi Transportasi', 
          '${totalTransport.toStringAsFixed(1)} kg', 
          Icons.directions_car, 
          Colors.blue,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TransportHistoryView()));
          },
        ),
        const SizedBox(height: 16),
        _buildSummaryCard(
          context, 
          'Emisi Listrik', 
          '${totalElectricity.toStringAsFixed(1)} kg', 
          Icons.electric_bolt, 
          Colors.amber,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ElectricityHistoryView()));
          },
        ),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(color: Color(0xFF0F172A), fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(
    BuildContext context,
    List<TransportLog> transportLogs,
    List<ElectricityLog> electricityLogs,
  ) {
    final chartPoints = _buildChartPoints(transportLogs, electricityLogs);
    final chartDates = chartPoints.$2;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Emisi Karbon',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 32),
          if (chartPoints.$1.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: Text('Belum ada data untuk grafik.')),
            )
          else
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (chartPoints.$1.length - 1).toDouble(),
                  minY: 0,
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= chartDates.length) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              chartDates[index],
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        interval: _chartInterval(chartPoints.$1),
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toStringAsFixed(0)} kg',
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartPoints.$1,
                      isCurved: true,
                      color: const Color(0xFF10B981),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF10B981).withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  (List<FlSpot>, List<String>) _buildChartPoints(
    List<TransportLog> transportLogs,
    List<ElectricityLog> electricityLogs,
  ) {
    final Map<String, double> totalsByDate = <String, double>{};

    for (final log in transportLogs) {
      totalsByDate.update(
        log.activityDate,
        (value) => value + log.emissionKg,
        ifAbsent: () => log.emissionKg,
      );
    }

    for (final log in electricityLogs) {
      totalsByDate.update(
        log.recordDate,
        (value) => value + log.emissionKg,
        ifAbsent: () => log.emissionKg,
      );
    }

    final sortedDates = totalsByDate.keys.toList()..sort();
    final spots = <FlSpot>[];

    for (var i = 0; i < sortedDates.length; i++) {
      spots.add(FlSpot(i.toDouble(), totalsByDate[sortedDates[i]] ?? 0));
    }

    final labels = sortedDates
        .map((date) => DateFormat('dd/MM').format(DateTime.parse(date)))
        .toList();

    return (spots, labels);
  }

  double _chartInterval(List<FlSpot> spots) {
    if (spots.isEmpty) {
      return 1;
    }

    final maxValue = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    if (maxValue <= 5) {
      return 1;
    }

    return (maxValue / 5).ceilToDouble();
  }
}
