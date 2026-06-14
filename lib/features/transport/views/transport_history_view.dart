import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transport_provider.dart';

class TransportHistoryView extends StatelessWidget {
  const TransportHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransportProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transportasi')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.logs.length,
              itemBuilder: (context, index) {
                final log = provider.logs[index];
                return ListTile(
                  leading: const Icon(Icons.directions_car, color: Colors.blue),
                  title: Text(log.transportTypeName),
                  subtitle: Text('${log.distanceKm} km | ${log.activityDate}'),
                  trailing: Text('${log.emissionKg.toStringAsFixed(1)} kg CO2', style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              },
            ),
    );
  }
}
