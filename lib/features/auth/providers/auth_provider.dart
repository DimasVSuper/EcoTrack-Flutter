import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/api_client.dart';

class AuthProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _token;
  String? get token => _token;

  String? _userName;
  String? get userName => _userName;

  String? _userEmail;
  String? get userEmail => _userEmail;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'];
        _token = data['access_token']?.toString();

        final userData = data['user'];
        if (userData != null) {
          _userName = userData['name']?.toString();
          _userEmail = userData['email']?.toString();
        }

        if (_token != null && _token!.isNotEmpty) {
          await _storage.write(key: 'auth_token', value: _token);
        }

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (_) {
      // Keep the failure simple for MVP flow.
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String password, String passwordConfirmation) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.dio.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'];
        _token = data['access_token']?.toString();

        final userData = data['user'];
        if (userData != null) {
          _userName = userData['name']?.toString();
          _userEmail = userData['email']?.toString();
        }

        if (_token != null && _token!.isNotEmpty) {
          await _storage.write(key: 'auth_token', value: _token);
        }

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (_) {
      // Keep the failure simple for MVP flow.
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await _apiClient.dio.get('/user/profile');
      if (response.statusCode == 200) {
        final userData = response.data['user'];
        if (userData != null) {
          _userName = userData['name']?.toString();
          _userEmail = userData['email']?.toString();
          notifyListeners();
        }
      }
    } catch (_) {
      // Gentle catch
    }
  }

  Future<bool> tryAutoLogin() async {
    final savedToken = await _storage.read(key: 'auth_token');
    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
      fetchUserProfile();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/logout');
    } catch (_) {}

    _token = null;
    _userName = null;
    _userEmail = null;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }
}
