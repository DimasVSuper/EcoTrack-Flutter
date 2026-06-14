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

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransportProvider>(context, listen: false).fetchTypes();
    });
  }

  void _submit() async {
    if (_selectedType == null || _distanceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap isi semua data')));
      return;
    }

    final provider = Provider.of<TransportProvider>(context, listen: false);
    final success = await provider.addLog(
      transportTypeId: _selectedType!.id,
      distance: double.parse(_distanceController.text),
      activityDate: _dateController.text,
    );

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransportProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Input Transportasi')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            DropdownButtonFormField<TransportType>(
              value: _selectedType,
              hint: const Text('Pilih Kendaraan'),
              items: provider.types.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedType = val;
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _distanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jarak (km)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Tanggal (YYYY-MM-DD)',
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
