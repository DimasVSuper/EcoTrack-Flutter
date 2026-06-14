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

  void _submit() async {
    if (_kwhController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap isi kwh')));
      return;
    }

    final provider = Provider.of<ElectricityProvider>(context, listen: false);
    final success = await provider.addLog(
      kwh: double.parse(_kwhController.text),
      period: _periodController.text,
      loggingDate: _dateController.text,
    );

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ElectricityProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Input Listrik')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _kwhController,
              keyboardType: TextInputType.number,
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
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: provider.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                child: provider.isLoading ? const CircularProgressIndicator() : const Text('Simpan'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
