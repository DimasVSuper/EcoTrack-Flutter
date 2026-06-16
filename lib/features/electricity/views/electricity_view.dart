import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/electricity_provider.dart';
import '../models/electricity_log.dart';

class ElectricityView extends StatefulWidget {
  const ElectricityView({super.key});

  @override
  State<ElectricityView> createState() => _ElectricityViewState();
}

class _ElectricityViewState extends State<ElectricityView> {
  final TextEditingController _kwhController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedPeriod;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _selectedPeriod = DateFormat('yyyy-MM').format(DateTime.now());
    Future.microtask(() {
      if (!mounted) return;
      final provider = Provider.of<ElectricityProvider>(context, listen: false);
      provider.fetchLogs();
    });
  }

  @override
  void dispose() {
    _kwhController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  List<String> _getPeriodOptions() {
    final List<String> options = [];
    final DateTime now = DateTime.now();
    for (int i = 0; i < 6; i++) {
      final DateTime date = DateTime(now.year, now.month - i, 1);
      options.add(DateFormat('yyyy-MM').format(date));
    }
    return options;
  }

  void _submit() async {
    final kwh = double.tryParse(_kwhController.text);
    if (kwh == null || _selectedPeriod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua data dengan benar')),
      );
      return;
    }

    final provider = Provider.of<ElectricityProvider>(context, listen: false);
    final success = await provider.addLog(
      kwh: kwh,
      period: _selectedPeriod!,
      loggingDate: _dateController.text,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data penggunaan listrik disimpan!'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
      setState(() {
        _showForm = false;
        _kwhController.clear();
      });
      provider.fetchLogs();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Gagal menyimpan. Coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ElectricityProvider>(context);
    final periods = _getPeriodOptions();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Penggunaan Listrik',
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
                        'Tambah Data Listrik',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 16),
                      // Jumlah kWh Input
                      TextField(
                        controller: _kwhController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Jumlah kWh',
                          hintText: 'Masukkan jumlah kWh',
                          suffixText: 'kWh',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Dropdown Periode
                      DropdownButtonFormField<String>(
                        initialValue: _selectedPeriod,
                        hint: const Text('Pilih periode'),
                        items: periods.map((period) {
                          return DropdownMenuItem<String>(
                            value: period,
                            child: Text(period),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() => _selectedPeriod = val);
                        },
                        decoration: InputDecoration(
                          labelText: 'Periode',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tanggal Catat Input
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
                  'Riwayat Penggunaan',
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
                                      'Belum ada data listrik.',
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
                                      // Lightning bolt icon container
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFFFBEB),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.electric_bolt_rounded,
                                          color: Color(0xFFF59E0B),
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
                                              '${log.usageKwh} kWh',
                                              style: const TextStyle(
                                                color: Color(0xFF0F172A),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Periode: ${log.periodMonth} • ${log.recordDate}',
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

  void _confirmDelete(ElectricityProvider provider, ElectricityLog log) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus riwayat?'),
        content: const Text('Yakin ingin menghapus log listrik ini?'),
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

  void _showEditDialog(ElectricityProvider provider, ElectricityLog log) async {
    final usageController = TextEditingController(text: log.usageKwh.toString());
    final periodController = TextEditingController(text: log.periodMonth);
    final dateController = TextEditingController(text: log.recordDate);

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Log Listrik'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usageController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Penggunaan (kWh)'),
              ),
              TextField(
                controller: periodController,
                decoration: const InputDecoration(labelText: 'Periode (YYYY-MM)'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Tanggal Catat'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            FilledButton(
              onPressed: () async {
                final ok = await provider.updateLog(
                  id: log.id,
                  usageKwh: double.tryParse(usageController.text) ?? log.usageKwh,
                  periodMonth: periodController.text,
                  recordDate: dateController.text,
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
  }
}
