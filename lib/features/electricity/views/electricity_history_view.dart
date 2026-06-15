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
                  subtitle: Text('Periode: ${log.periodMonth} | ${log.recordDate}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _showEditDialog(context, provider, log),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Hapus riwayat?'),
                              content: const Text('Yakin ingin menghapus log listrik ini?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                                FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            final ok = await provider.deleteLog(log.id);
                            if (!ok && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menghapus log.')));
                            }
                          }
                        },
                      ),
                      Text('${log.emissionKg.toStringAsFixed(1)} kg CO2', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, ElectricityProvider provider, dynamic log) async {
    final usageController = TextEditingController(text: log.usageKwh.toString());
    final periodController = TextEditingController(text: log.periodMonth);
    final dateController = TextEditingController(text: log.recordDate);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Log Listrik'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: usageController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Penggunaan (kWh)')),
              TextField(controller: periodController, decoration: const InputDecoration(labelText: 'Periode (YYYY-MM)')),
              TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Tanggal Catat')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            FilledButton(
              onPressed: () async {
                final ok = await provider.updateLog(
                  id: log.id,
                  usageKwh: double.tryParse(usageController.text) ?? log.usageKwh,
                  periodMonth: periodController.text,
                  recordDate: dateController.text,
                );
                if (!context.mounted) return;
                Navigator.pop(context);
                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengubah log.')));
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
