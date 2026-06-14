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

  Future<void> fetchLogs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.dio.get('/electricity-logs');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _logs = data.map((e) => ElectricityLog.fromJson(e)).toList();
      }
    } catch (_) {
      // Keep logs as is on failure
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addLog({
    required double kwh,
    required String period,
    required String loggingDate,
  }) async {
    _isLoading = true;
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
        await fetchLogs();
        return true;
      }
    } catch (_) {
      // Fail silently for MVP
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
