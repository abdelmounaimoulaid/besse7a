
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/config/api_config.dart';
import 'package:mobile_app/models/user_model.dart';

class AuthService {
  final StreamController<UserModel?> _userController = StreamController<UserModel?>.broadcast();
  static const String _tokenKey = 'auth_token';

  AuthService() {
    _checkAuthStatus();
  }

  Stream<UserModel?> get user => _userController.stream;

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token != null) {
      // Ideally, verify token validity with backend here
      // For now, assume logged in if token exists
      // You might want to store user details in prefs too or fetch 'me' endpoint
      try {
        await _fetchUser(token);
      } catch (e) {
        _userController.add(null);
      }
    } else {
      _userController.add(null);
    }
  }

  Future<void> _fetchUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = UserModel(
          uid: data['id'].toString(),
          email: data['email'],
          displayName: data['name'],
        );
        _userController.add(user);
      } else {
        await _clearToken();
        _userController.add(null);
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching user: $e');
      _userController.add(null);
    }
  }

  Future<UserModel?> signInWithEmail(String email, String password, {String? locale}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (locale != null) {
        headers['Accept-Language'] = locale;
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/login'),
        headers: headers,
        body: json.encode({'email': email, 'password': password}),
      );

      if (kDebugMode) {
        print('Login response status: ${response.statusCode}');
        print('Login response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          final token = data['access_token'];
          await _saveToken(token);
          
          final user = UserModel(
            uid: data['user']['id'].toString(),
            email: data['user']['email'],
            displayName: data['user']['name'],
          );
          _userController.add(user);
          return user;
        } catch (e) {
          if (kDebugMode) print('Error parsing login response: $e');
          throw Exception('Invalid response from server. Please check your backend configuration.');
        }
      } else {
        try {
          final error = json.decode(response.body);
          throw Exception(error['message'] ?? 'Login failed');
        } catch (e) {
          if (e is FormatException) {
            throw Exception('Server error: Unable to connect to backend. Please ensure the backend is running at ${ApiConfig.baseUrl}');
          }
          rethrow;
        }
      }
    } catch (e) {
      if (kDebugMode) print('Login error: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<UserModel?> registerWithEmail(String email, String password, String name, {String? locale}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (locale != null) {
        headers['Accept-Language'] = locale;
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/register'),
        headers: headers,
        body: json.encode({
          'email': email,
          'password': password,
          'password_confirmation': password,
          'name': name,
        }),
      );

      if (kDebugMode) {
        print('Register response status: ${response.statusCode}');
        print('Register response body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = json.decode(response.body);
          final token = data['access_token'];
          await _saveToken(token);
          
          final user = UserModel(
            uid: data['user']['id'].toString(),
            email: data['user']['email'],
            displayName: data['user']['name'],
          );
          _userController.add(user);
          return user;
        } catch (e) {
          if (kDebugMode) print('Error parsing registration response: $e');
          throw Exception('Invalid response from server. Please check your backend configuration.');
        }
      } else {
        try {
          final error = json.decode(response.body);
          throw Exception(error['message'] ?? 'Registration failed');
        } catch (e) {
          if (e is FormatException) {
            throw Exception('Server error: Unable to connect to backend. Please ensure the backend is running at ${ApiConfig.baseUrl}');
          }
          rethrow;
        }
      }
    } catch (e) {
      if (kDebugMode) print('Registration error: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      
      if (token != null) {
        await http.post(
          Uri.parse('${ApiConfig.baseUrl}/logout'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
      }
    } catch (e) {
      if (kDebugMode) print('Logout error: $e');
    } finally {
      await _clearToken();
      _userController.add(null);
    }
  }

  Future<void> sendPasswordResetEmail(String email, {String? locale}) async {
    // Note: The backend does not yet have a 'forgot-password' endpoint implemented.
    // This is a placeholder for when that functionality is added.
    try {
       final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (locale != null) {
        headers['Accept-Language'] = locale;
      }
      
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/forgot-password'),
         headers: headers,
        body: json.encode({'email': email}),
      );
      
      if (response.statusCode != 200) {
         final error = json.decode(response.body);
         throw Exception(error['message'] ?? 'Failed to send reset email');
      }
    } catch (e) {
      if (kDebugMode) print('Reset password error: $e');
      // For now, since backend doesn't implement it, we might want to simulate success or throw
      // rethrow; 
      // User asked why it is not working. It is expected not to work.
      throw Exception('Password reset service is not available yet.');
    }
  }

  Future<bool> verifyCode(String email, String token, {String? locale}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (locale != null) {
        headers['Accept-Language'] = locale;
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/verify-code'),
        headers: headers,
        body: json.encode({'email': email, 'token': token}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
         final error = json.decode(response.body);
         throw Exception(error['message'] ?? 'Invalid code');
      }
    } catch (e) {
      if (kDebugMode) print('Verify code failed: $e');
      rethrow;
    }
  }

  Future<bool> resetPassword(String email, String token, String password, String confirmation, {String? locale}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (locale != null) {
        headers['Accept-Language'] = locale;
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/reset-password'),
        headers: headers,
        body: json.encode({
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': confirmation,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
         final error = json.decode(response.body);
         throw Exception(error['message'] ?? 'Reset password failed');
      }
    } catch (e) {
      if (kDebugMode) print('Reset password failed: $e');
      rethrow;
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
  
  void dispose() {
    _userController.close();
  }
}
