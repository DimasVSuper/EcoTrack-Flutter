import 'package:flutter/material.dart';
import '../../../core/api/api_client.dart';
import '../models/electricity_log.dart';

class ElectricityProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<ElectricityLog> _logs = [];
  List<ElectricityLog> get logs => _logs;

  double get totalEmission => _logs.fold(0, (sum, log) => sum + log.emissionKg);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchLogs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.dio.get('/electricity-logs');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _logs = data.map((e) => ElectricityLog.fromJson(e)).toList();
      }
    } catch (_) {
      // keep existing logs on failure
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addLog({
    required double kwh,
    required String period,
    required String loggingDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.dio.post(
        '/electricity-logs',
        data: {
          'usage_kwh': kwh,
          'period_month': period,
          'record_date': loggingDate,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // fetchLogs handles resetting _isLoading via finally block
        await fetchLogs();
        return true;
      } else {
        _error = 'Gagal menyimpan (${response.statusCode})';
      }
    } catch (e) {
      _error = 'Koneksi gagal. Pastikan server backend berjalan.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
