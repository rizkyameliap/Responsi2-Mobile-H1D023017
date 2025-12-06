import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:responsi2_mobile_paket1_h1d023017/models/user_model.dart';
import 'package:responsi2_mobile_paket1_h1d023017/services/api_service.dart';
import 'package:responsi2_mobile_paket1_h1d023017/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  // Register
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _apiService.post(
      AppConstants.registerEndpoint,
      request.toJson(),
    );

    return AuthResponse.fromJson(response);
  }

  // Login
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _apiService.post(
      AppConstants.loginEndpoint,
      request.toJson(),
    );

    final authResponse = AuthResponse.fromJson(response);

    _apiService.setToken(authResponse.token);
    _currentUser = authResponse.user;

    await _saveUserData(authResponse);
    notifyListeners(); // ← KASIH TAHU UI ADA PERUBAHAN

    return authResponse;
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _apiService.clearToken();
    _currentUser = null;

    notifyListeners(); // ← Perubahan status login
  }

  // Check login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);

    if (token != null && token.isNotEmpty) {
      _apiService.setToken(token);

      final userJson = prefs.getString(AppConstants.userKey);
      if (userJson != null) {
        try {
          final userData = json.decode(userJson);
          _currentUser = User.fromJson(userData);

          notifyListeners(); // ← User berhasil di-load
        } catch (e) {
          print('Error parsing user data: $e');
        }
      }

      return true;
    }

    return false;
  }

  Future<void> _saveUserData(AuthResponse authResponse) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(AppConstants.tokenKey, authResponse.token);
    await prefs.setString(
      AppConstants.userKey,
      json.encode(authResponse.user.toJson()),
    );
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }
}
