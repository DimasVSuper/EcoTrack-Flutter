import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../transport/providers/transport_provider.dart';
import '../../electricity/providers/electricity_provider.dart';

class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  String _selectedMonth = 'Bulan Ini';

  @override
  Widget build(BuildContext context) {
    final transportProvider = Provider.of<TransportProvider>(context);
    final electricityProvider = Provider.of<ElectricityProvider>(context);

    final double totalTransport = transportProvider.totalEmission;
    final double totalElectricity = electricityProvider.totalEmission;
    final double totalOverall = totalTransport + totalElectricity;

    // Calculate percentages
    final double transportPercent = totalOverall > 0 ? (totalTransport / totalOverall) * 100 : 0.0;
    final double electricityPercent = totalOverall > 0 ? (totalElectricity / totalOverall) * 100 : 0.0;

    // Calculate highest activity log dynamically
    double highestEmission = 0.0;
    String highestName = 'Belum ada data';
    double highestPct = 0.0;
    IconData highestIcon = Icons.info_outline;

    for (final log in transportProvider.logs) {
      if (log.emissionKg > highestEmission) {
        highestEmission = log.emissionKg;
        highestName = log.transportTypeName;
        highestIcon = Icons.directions_car_rounded;
      }
    }
    for (final log in electricityProvider.logs) {
      if (log.emissionKg > highestEmission) {
        highestEmission = log.emissionKg;
        highestName = 'Penggunaan Listrik';
        highestIcon = Icons.bolt_rounded;
      }
    }
    if (totalOverall > 0) {
      highestPct = (highestEmission / totalOverall) * 100;
    }

    // Calculate daily average (dividing total emission by current day of month)
    final int currentDay = DateTime.now().day;
    final double dailyAvg = currentDay > 0 ? totalOverall / currentDay : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Analisis Emisi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF0F172A)),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Emisi & Dropdown Row
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Emisi',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              totalOverall.toStringAsFixed(0),
                              style: const TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Kg CO₂',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Dropdown selector
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedMonth,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF475569)),
                        style: const TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Bulan Ini', child: Text('Bulan Ini')),
                          DropdownMenuItem(value: 'Bulan Lalu', child: Text('Bulan Lalu')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedMonth = val;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Kontribusi Emisi Donut Chart Card
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kontribusi Emisi',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Donut Chart Container
                    SizedBox(
                      height: 180,
                      child: Stack(
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 4,
                              centerSpaceRadius: 55,
                              startDegreeOffset: -90,
                              sections: [
                                PieChartSectionData(
                                  color: const Color(0xFF2E7D32),
                                  value: totalOverall > 0 ? totalTransport : 1.0,
                                  title: '',
                                  radius: 18,
                                ),
                                PieChartSectionData(
                                  color: const Color(0xFF94A3B8),
                                  value: totalOverall > 0 ? totalElectricity : 1.0,
                                  title: '',
                                  radius: 18,
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  totalOverall.toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const Text(
                                  'Kg CO₂',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Legends
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFF2E7D32), shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Transportasi', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                Text(
                                  '${totalTransport.toStringAsFixed(0)} Kg (${transportPercent.toStringAsFixed(0)}%)',
                                  style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFF94A3B8), shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Listrik', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                Text(
                                  '${totalElectricity.toStringAsFixed(0)} Kg (${electricityPercent.toStringAsFixed(0)}%)',
                                  style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Highest Activity and Daily Average Cards Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Aktivitas Tertinggi Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Aktivitas Tertinggi',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF1F5F9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(highestIcon, color: const Color(0xFF2E7D32), size: 20),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      highestName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFF0F172A),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${highestEmission.toStringAsFixed(0)} Kg CO₂',
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${highestPct.toStringAsFixed(0)}% dari total emisi',
                            style: const TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Rata-rata Harian Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rata-rata Harian',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F5E9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.local_fire_department_rounded, color: Color(0xFF2E7D32), size: 20),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dailyAvg.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Color(0xFF0F172A),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const Text(
                                      'Kg CO₂/hari',
                                      style: TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Placeholder subtext to keep card balanced
                          const Text(
                            'Diperbarui hari ini',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
