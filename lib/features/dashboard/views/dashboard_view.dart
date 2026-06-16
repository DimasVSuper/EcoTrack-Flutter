import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../auth/providers/auth_provider.dart';
import '../../transport/providers/transport_provider.dart';
import '../../electricity/providers/electricity_provider.dart';
import '../../analysis/views/analysis_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> with WidgetsBindingObserver {
  String _selectedChartPeriod = 'Mingguan';

  void _loadDashboardData() {
    Provider.of<AuthProvider>(context, listen: false).fetchUserProfile();
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
    final authProvider = Provider.of<AuthProvider>(context);
    final transportProvider = Provider.of<TransportProvider>(context);
    final electricityProvider = Provider.of<ElectricityProvider>(context);

    final double totalTransport = transportProvider.totalEmission;
    final double totalElectricity = electricityProvider.totalEmission;
    final double totalOverall = totalTransport + totalElectricity;

    // Calculate percentages
    final double transportPercent = totalOverall > 0 ? (totalTransport / totalOverall) * 100 : 0.0;
    final double electricityPercent = totalOverall > 0 ? (totalElectricity / totalOverall) * 100 : 0.0;

    // Greeting name
    final String userName = authProvider.userName ?? 'User';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadDashboardData();
          },
          color: const Color(0xFF2E7D32),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: Greeting and Notification Bell
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, $userName! 👋',
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Yuk kelola jejak karbonmu hari ini.',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF0F172A), size: 28),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Belum ada notifikasi baru.')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Total Emisi Bulan Ini Card
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AnalysisView()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Emisi Bulan Ini',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  totalOverall.toStringAsFixed(0),
                                  style: const TextStyle(
                                    color: Color(0xFF0F172A),
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Kg CO₂',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: const [
                                Icon(Icons.arrow_upward_rounded, color: Color(0xFF2E7D32), size: 16),
                                SizedBox(width: 4),
                                Text(
                                  '12% dari bulan lalu',
                                  style: TextStyle(
                                    color: Color(0xFF2E7D32),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Cloud Graphic Placeholder or Icon
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.cloud_queue_rounded,
                            color: Color(0xFF64748B),
                            size: 44,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Grafik Emisi Section
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Grafik Emisi (Kg CO₂)',
                            style: TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedChartPeriod,
                                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF475569), size: 18),
                                style: const TextStyle(
                                  color: Color(0xFF475569),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                dropdownColor: Colors.white,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Mingguan',
                                    child: Text('Mingguan'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Bulanan',
                                    child: Text('Bulanan'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedChartPeriod = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 180,
                        child: _buildBarChart(transportProvider.logs, electricityProvider.logs),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Ringkasan Section Title
                const Text(
                  'Ringkasan',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Side-by-Side Ringkasan Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        context: context,
                        title: 'Transportasi',
                        value: '${totalTransport.toStringAsFixed(0)} Kg CO₂',
                        percent: '${transportPercent.toStringAsFixed(0)}%',
                        icon: Icons.directions_car_rounded,
                        iconColor: const Color(0xFF2E7D32),
                        bgColor: const Color(0xFFE8F5E9),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        context: context,
                        title: 'Listrik',
                        value: '${totalElectricity.toStringAsFixed(0)} Kg CO₂',
                        percent: '${electricityPercent.toStringAsFixed(0)}%',
                        icon: Icons.bolt_rounded,
                        iconColor: const Color(0xFFF59E0B),
                        bgColor: const Color(0xFFFEF3C7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Rekomendasi Hari Ini Card
                const Text(
                  'Rekomendasi Hari Ini',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F5E9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.spa_rounded,
                          color: Color(0xFF2E7D32),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Gunakan transportasi umum',
                              style: TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'untuk mengurangi emisi karbon.',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required String value,
    required String percent,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Text(
                percent,
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<dynamic> transportLogs, List<dynamic> electricityLogs) {
    if (_selectedChartPeriod == 'Bulanan') {
      return _buildMonthlyBarChart(transportLogs, electricityLogs);
    } else {
      return _buildWeeklyBarChart(transportLogs, electricityLogs);
    }
  }

  Widget _buildWeeklyBarChart(List<dynamic> transportLogs, List<dynamic> electricityLogs) {
    // Get emission totals for the last 7 days (Sen to Min)
    final DateTime now = DateTime.now();
    // Monday is weekday 1, Sunday is 7. Let's calculate the dates of the current week.
    final DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final DateTime startOfWeekDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    final Map<int, double> dayTotals = {1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0, 6: 0.0, 7: 0.0};

    for (final log in transportLogs) {
      try {
        final DateTime date = DateTime.parse(log.activityDate);
        if (date.isAfter(startOfWeekDay.subtract(const Duration(seconds: 1))) &&
            date.isBefore(startOfWeekDay.add(const Duration(days: 7)))) {
          dayTotals[date.weekday] = (dayTotals[date.weekday] ?? 0.0) + log.emissionKg;
        }
      } catch (_) {}
    }

    for (final log in electricityLogs) {
      try {
        final DateTime date = DateTime.parse(log.recordDate);
        if (date.isAfter(startOfWeekDay.subtract(const Duration(seconds: 1))) &&
            date.isBefore(startOfWeekDay.add(const Duration(days: 7)))) {
          dayTotals[date.weekday] = (dayTotals[date.weekday] ?? 0.0) + log.emissionKg;
        }
      } catch (_) {}
    }

    // Determine the max value to set scale
    double maxVal = 10.0;
    for (final val in dayTotals.values) {
      if (val > maxVal) {
        maxVal = val;
      }
    }
    maxVal = (maxVal * 1.1).ceilToDouble(); // pad by 10%

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxVal,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF1E293B),
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(1)} Kg',
                const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
                String text;
                switch (value.toInt()) {
                  case 1:
                    text = 'Sen';
                    break;
                  case 2:
                    text = 'Sel';
                    break;
                  case 3:
                    text = 'Rab';
                    break;
                  case 4:
                    text = 'Kam';
                    break;
                  case 5:
                    text = 'Jum';
                    break;
                  case 6:
                    text = 'Sab';
                    break;
                  case 7:
                    text = 'Min';
                    break;
                  default:
                    text = '';
                    break;
                }
                return SideTitleWidget(
                  meta: meta,
                  space: 4,
                  child: Text(text, style: style),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 10,
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          for (int i = 1; i <= 7; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: dayTotals[i] ?? 0.0,
                  color: const Color(0xFF2E7D32),
                  width: 14,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxVal,
                    color: const Color(0xFFF1F5F9),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMonthlyBarChart(List<dynamic> transportLogs, List<dynamic> electricityLogs) {
    final List<DateTime> last6Months = [];
    final DateTime now = DateTime.now();
    for (int i = 5; i >= 0; i--) {
      int year = now.year;
      int month = now.month - i;
      if (month <= 0) {
        month += 12;
        year -= 1;
      }
      last6Months.add(DateTime(year, month, 1));
    }

    final Map<String, double> monthTotals = {};
    for (final m in last6Months) {
      final key = DateFormat('yyyy-MM').format(m);
      monthTotals[key] = 0.0;
    }

    for (final log in transportLogs) {
      try {
        final DateTime date = DateTime.parse(log.activityDate);
        final key = DateFormat('yyyy-MM').format(date);
        if (monthTotals.containsKey(key)) {
          monthTotals[key] = monthTotals[key]! + log.emissionKg;
        }
      } catch (_) {}
    }

    for (final log in electricityLogs) {
      try {
        final DateTime date = DateTime.parse(log.recordDate);
        final key = DateFormat('yyyy-MM').format(date);
        if (monthTotals.containsKey(key)) {
          monthTotals[key] = monthTotals[key]! + log.emissionKg;
        }
      } catch (_) {}
    }

    double maxVal = 10.0;
    for (final val in monthTotals.values) {
      if (val > maxVal) {
        maxVal = val;
      }
    }
    maxVal = (maxVal * 1.1).ceilToDouble();

    String getMonthLabel(int index) {
      final DateTime m = last6Months[index];
      switch (m.month) {
        case 1: return 'Jan';
        case 2: return 'Feb';
        case 3: return 'Mar';
        case 4: return 'Apr';
        case 5: return 'Mei';
        case 6: return 'Jun';
        case 7: return 'Jul';
        case 8: return 'Agu';
        case 9: return 'Sep';
        case 10: return 'Okt';
        case 11: return 'Nov';
        case 12: return 'Des';
        default: return '';
      }
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxVal,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF1E293B),
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(1)} Kg',
                const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                );
                final int idx = value.toInt() - 1;
                final String text = (idx >= 0 && idx < 6) ? getMonthLabel(idx) : '';
                return SideTitleWidget(
                  meta: meta,
                  space: 4,
                  child: Text(text, style: style),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 10,
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          for (int i = 0; i < 6; i++)
            BarChartGroupData(
              x: i + 1,
              barRods: [
                BarChartRodData(
                  toY: monthTotals[DateFormat('yyyy-MM').format(last6Months[i])] ?? 0.0,
                  color: const Color(0xFF2E7D32),
                  width: 16,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxVal,
                    color: const Color(0xFFF1F5F9),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
