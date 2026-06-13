import 'package:flutter/material.dart';
import '../data/api/api_client.dart';

class ElectricityProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<dynamic> _logs = [];
  List<dynamic> get logs => _logs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchLogs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.dio.get('/electricity-logs');
      if (response.statusCode == 200) {
        _logs = response.data['data'] as List<dynamic>;
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
          'kwh': kwh,
          'period': period,
          'logging_date': loggingDate,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh logs list after a successful creation
        await fetchLogs();
        return true;
      }
    } catch (_) {
      // Fail silently for simple MVP flow
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
