import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transport_provider.dart';
import '../models/transport_type.dart';
import '../models/transport_log.dart';

class TransportView extends StatefulWidget {
  const TransportView({super.key});

  @override
  State<TransportView> createState() => _TransportViewState();
}

class _TransportViewState extends State<TransportView> {
  TransportType? _selectedType;
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Future.microtask(() {
      if (!mounted) return;
      final provider = Provider.of<TransportProvider>(context, listen: false);
      provider.fetchLogs();
      provider.fetchTypes();
    });
  }

  @override
  void dispose() {
    _distanceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_selectedType == null || _distanceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap pilih kendaraan dan isi jarak')),
      );
      return;
    }

    final provider = Provider.of<TransportProvider>(context, listen: false);
    final success = await provider.addLog(
      transportTypeId: _selectedType!.id,
      distance: double.tryParse(_distanceController.text) ?? 0,
      activityDate: _dateController.text,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aktivitas transportasi disimpan!'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
      setState(() {
        _showForm = false;
        _distanceController.clear();
        _selectedType = null;
      });
      provider.fetchLogs();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan. Coba lagi.')),
      );
    }
  }

  IconData _getVehicleIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('mobil') || lower.contains('car')) {
      return Icons.directions_car_rounded;
    } else if (lower.contains('motor') || lower.contains('bike') || lower.contains('sepeda motor')) {
      return Icons.motorcycle_rounded;
    } else if (lower.contains('bus')) {
      return Icons.directions_bus_rounded;
    } else if (lower.contains('kereta') || lower.contains('train')) {
      return Icons.directions_train_rounded;
    } else if (lower.contains('jalan') || lower.contains('walk')) {
      return Icons.directions_walk_rounded;
    }
    return Icons.directions_car_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransportProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Aktivitas Transportasi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF0F172A)),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showForm ? Icons.remove : Icons.add, color: const Color(0xFF2E7D32), size: 28),
            onPressed: () {
              setState(() {
                _showForm = !_showForm;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Expandable Input Form Card
            if (_showForm)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Tambah Aktivitas',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 16),
                      // Dropdown Jenis Kendaraan
                      if (provider.typesLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        DropdownButtonFormField<TransportType>(
                          initialValue: _selectedType,
                          hint: const Text('Pilih jenis kendaraan'),
                          items: provider.types.map((type) {
                            return DropdownMenuItem<TransportType>(
                              value: type,
                              child: Text(type.name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => _selectedType = val);
                          },
                          decoration: InputDecoration(
                            labelText: 'Jenis Kendaraan',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Jarak Tempuh input
                      TextField(
                        controller: _distanceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Jarak Tempuh (km)',
                          hintText: 'Masukkan jarak',
                          suffixText: 'km',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tanggal input
                      TextField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Tanggal',
                          hintText: 'Pilih tanggal',
                          suffixIcon: const Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() {
                              _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      // Simpan Button
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: provider.isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: provider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // History Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Riwayat Aktivitas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
            // History List View
            Expanded(
              child: provider.isLoading && provider.logs.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () async {
                        provider.fetchLogs();
                      },
                      color: const Color(0xFF2E7D32),
                      child: provider.logs.isEmpty
                          ? ListView(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40.0),
                                  child: Center(
                                    child: Text(
                                      'Belum ada aktivitas transportasi.',
                                      style: TextStyle(color: Color(0xFF64748B)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              itemCount: provider.logs.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final log = provider.logs[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Row(
                                    children: [
                                      // Vehicle category icon container
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF1F5F9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _getVehicleIcon(log.transportTypeName),
                                          color: const Color(0xFF2E7D32),
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Log Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              log.transportTypeName,
                                              style: const TextStyle(
                                                color: Color(0xFF0F172A),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${log.distanceKm} km • ${log.activityDate}',
                                              style: const TextStyle(
                                                color: Color(0xFF64748B),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Emission and edit/delete trigger
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            log.emissionKg.toStringAsFixed(1),
                                            style: const TextStyle(
                                              color: Color(0xFF0F172A),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'Kg CO₂',
                                            style: TextStyle(
                                              color: Color(0xFF64748B),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert, color: Color(0xFF64748B), size: 20),
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _showEditDialog(provider, log);
                                          } else if (value == 'delete') {
                                            _confirmDelete(provider, log);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Text('Ubah'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Hapus', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(TransportProvider provider, TransportLog log) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus riwayat?'),
        content: const Text('Yakin ingin menghapus log transportasi ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final ok = await provider.deleteLog(log.id);
      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log berhasil dihapus.')));
        provider.fetchLogs();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menghapus log.')));
      }
    }
  }

  void _showEditDialog(TransportProvider provider, TransportLog log) async {
    final distanceController = TextEditingController(text: log.distanceKm.toString());
    final dateController = TextEditingController(text: log.activityDate);
    int selectedTypeId = log.transportTypeId;

    if (provider.types.isEmpty) {
      await provider.fetchTypes();
    }

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: const Text('Edit Log Transportasi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: selectedTypeId,
                    items: provider.types.map((type) => DropdownMenuItem(value: type.id, child: Text(type.name))).toList(),
                    onChanged: (value) => setState(() => selectedTypeId = value ?? selectedTypeId),
                    decoration: const InputDecoration(labelText: 'Jenis Kendaraan'),
                  ),
                  TextField(
                    controller: distanceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Jarak (km)'),
                  ),
                  TextField(
                    controller: dateController,
                    decoration: const InputDecoration(labelText: 'Tanggal Aktivitas'),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                FilledButton(
                  onPressed: () async {
                    final ok = await provider.updateLog(
                      id: log.id,
                      transportTypeId: selectedTypeId,
                      distance: double.tryParse(distanceController.text) ?? log.distanceKm,
                      activityDate: dateController.text,
                    );
                    if (!ctx.mounted) return;
                    Navigator.pop(ctx);
                    if (!mounted) return;
                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log berhasil diubah.')));
                      provider.fetchLogs();
                    } else {
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
