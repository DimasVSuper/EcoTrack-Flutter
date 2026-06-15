import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transport_provider.dart';
import '../models/transport_type.dart';
import 'package:intl/intl.dart';

class TransportInputView extends StatefulWidget {
  const TransportInputView({super.key});

  @override
  State<TransportInputView> createState() => _TransportInputViewState();
}

class _TransportInputViewState extends State<TransportInputView> {
  TransportType? _selectedType;
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _didRequestTypes = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Future.microtask(() {
      if (!mounted || _didRequestTypes) {
        return;
      }

      _didRequestTypes = true;
      Provider.of<TransportProvider>(context, listen: false).fetchTypes();
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
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Transportasi')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Consumer<TransportProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Dropdown kendaraan ──────────────────────────────────────
                if (provider.typesLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (provider.typesError != null)
                  Column(
                    children: [
                      Text(
                        provider.typesError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: provider.fetchTypes,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  )
                else if (provider.types.isEmpty)
                  const Column(
                    children: [
                      Text('Tidak ada data kendaraan.'),
                      SizedBox(height: 8),
                    ],
                  )
                else
                  DropdownButtonFormField<TransportType>(
                    isExpanded: true,
                    value: _selectedType,
                    hint: const Text('Pilih Kendaraan'),
                    items: provider.types.map((type) {
                      return DropdownMenuItem<TransportType>(
                        value: type,
                        child: Text(type.name),
                      );
                    }).toList(),
                    onChanged: (TransportType? val) {
                      setState(() => _selectedType = val);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),

                const SizedBox(height: 16),

                // ── Jarak ──────────────────────────────────────────────────
                TextField(
                  controller: _distanceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Jarak (km)',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Tanggal ────────────────────────────────────────────────
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Submit ─────────────────────────────────────────────────
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                    ),
                    child: provider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Simpan'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
