import 'package:flutter/material.dart';
import '../../../core/api/api_client.dart';
import '../models/transport_log.dart';
import '../models/transport_type.dart';

class TransportProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<TransportLog> _logs = [];
  List<TransportLog> get logs => _logs;

  List<TransportType> _types = [];
  List<TransportType> get types => _types;

  double get totalEmission => _logs.fold(0, (sum, log) => sum + log.emissionKg);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchTypes() async {
    try {
      final response = await _apiClient.dio.get('/transport-types');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _types = data.map((e) => TransportType.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (_) {
      // Keep types as is on failure
    }
  }

  Future<void> fetchLogs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.dio.get('/transport-logs');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _logs = data.map((e) => TransportLog.fromJson(e)).toList();
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
          'distance_km': distance,
          'activity_date': activityDate,
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
