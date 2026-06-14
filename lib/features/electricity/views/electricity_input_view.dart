import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/electricity_provider.dart';
import 'package:intl/intl.dart';

class ElectricityInputView extends StatefulWidget {
  const ElectricityInputView({super.key});

  @override
  State<ElectricityInputView> createState() => _ElectricityInputViewState();
}

class _ElectricityInputViewState extends State<ElectricityInputView> {
  final TextEditingController _kwhController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _periodController.text = DateFormat('yyyy-MM').format(DateTime.now());
  }

  @override
  void dispose() {
    _kwhController.dispose();
    _periodController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _submit() async {
    final kwh = double.tryParse(_kwhController.text);
    if (kwh == null || _periodController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua data dengan benar')),
      );
      return;
    }

    final provider = Provider.of<ElectricityProvider>(context, listen: false);
    final success = await provider.addLog(
      kwh: kwh,
      period: _periodController.text,
      loggingDate: _dateController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Input Listrik')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Consumer<ElectricityProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _kwhController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Pemakaian (kWh)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _periodController,
                  decoration: const InputDecoration(
                    labelText: 'Periode (YYYY-MM)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Catat (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
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
