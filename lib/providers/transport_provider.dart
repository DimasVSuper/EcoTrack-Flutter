import 'package:flutter/material.dart';
import '../data/api/api_client.dart';

class TransportProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<dynamic> _logs = [];
  List<dynamic> get logs => _logs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchLogs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.dio.get('/transport-logs');
      if (response.statusCode == 200) {
        _logs = response.data['data'] as List<dynamic>;
      }
    } catch (_) {
      // Handle error or keep log list as is
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addLog({
    required int transportTypeId,
    required double distance,
    required String activityDate,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.dio.post(
        '/transport-logs',
        data: {
          'transport_type_id': transportTypeId,
          'distance': distance,
          'activity_date': activityDate,
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
