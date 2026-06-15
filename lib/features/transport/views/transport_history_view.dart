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
                              content: const Text('Yakin ingin menghapus log transportasi ini?'),
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

  Future<void> _showEditDialog(BuildContext context, TransportProvider provider, dynamic log) async {
    final distanceController = TextEditingController(text: log.distanceKm.toString());
    final dateController = TextEditingController(text: log.activityDate);
    int selectedTypeId = log.transportTypeId;

    if (provider.types.isEmpty) {
      await provider.fetchTypes();
    }

    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Log Transportasi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    value: selectedTypeId,
                    items: provider.types.map((type) => DropdownMenuItem(value: type.id, child: Text(type.name))).toList(),
                    onChanged: (value) => setState(() => selectedTypeId = value ?? selectedTypeId),
                    decoration: const InputDecoration(labelText: 'Jenis Kendaraan'),
                  ),
                  TextField(controller: distanceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jarak (km)')),
                  TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Tanggal Aktivitas')),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                FilledButton(
                  onPressed: () async {
                    final ok = await provider.updateLog(
                      id: log.id,
                      transportTypeId: selectedTypeId,
                      distance: double.tryParse(distanceController.text) ?? log.distanceKm,
                      activityDate: dateController.text,
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
      },
    );
  }
}
