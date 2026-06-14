import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/electricity_provider.dart';

class ElectricityHistoryView extends StatelessWidget {
  const ElectricityHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ElectricityProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Listrik')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.logs.length,
              itemBuilder: (context, index) {
                final log = provider.logs[index];
                return ListTile(
                  leading: const Icon(Icons.electric_bolt, color: Colors.amber),
                  title: Text('${log.usageKwh} kWh'),
                  subtitle: Text('Periode: ${log.periodMonth}'),
                  trailing: Text('${log.emissionKg.toStringAsFixed(1)} kg CO2', style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              },
            ),
    );
  }
}
