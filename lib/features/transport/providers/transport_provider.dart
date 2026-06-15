import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/transport_log.dart';
import '../models/transport_type.dart';

class TransportProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  // ── Logs ───────────────────────────────────────────────────
  List<TransportLog> _logs = [];
  List<TransportLog> get logs => _logs;

  double get totalEmission => _logs.fold(0, (sum, log) => sum + log.emissionKg);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ── Transport Types ────────────────────────────────────────
  List<TransportType> _types = [];
  List<TransportType> get types => _types;

  bool _typesLoading = false;
  bool get typesLoading => _typesLoading;

  String? _typesError;
  String? get typesError => _typesError;

  // ── Methods ────────────────────────────────────────────────

  Future<void> fetchTypes() async {
    _typesLoading = true;
    _typesError = null;
    notifyListeners();

    try {
      final response = await _apiClient.dio.get('/transport-types');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _types = data.map((e) => TransportType.fromJson(e)).toList();
      } else {
        _typesError = 'Gagal memuat kendaraan (${response.statusCode})';
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        _typesError = 'Sesi login habis. Silakan login ulang.';
      } else {
        _typesError = 'Koneksi gagal. Pastikan server backend berjalan.';
      }
    } catch (_) {
      _typesError = 'Gagal memuat kendaraan.';
    } finally {
      _typesLoading = false;
      notifyListeners();
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
      // keep existing logs on failure
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
        // fetchLogs resets _isLoading via finally block
        await fetchLogs();
        return true;
      }
    } catch (_) {
      // fall through
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updateLog({
    required int id,
    required int transportTypeId,
    required double distance,
    required String activityDate,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.dio.put(
        '/transport-logs/$id',
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
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> deleteLog(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.dio.delete('/transport-logs/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchLogs();
        return true;
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
