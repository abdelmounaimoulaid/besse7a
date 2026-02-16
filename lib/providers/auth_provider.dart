
import 'package:flutter/material.dart';
import 'package:mobile_app/models/user_model.dart';
import 'package:mobile_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _authService.user.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password, {String? locale}) async {
    _setLoading(true);
    try {
      await _authService.signInWithEmail(email, password, locale: locale);
      _setLoading(false);
      return true;
    } catch (e) {
      String message = e.toString();
      if (message.startsWith('Exception: ')) {
        message = message.substring(11);
      }
      _setError(message);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String email, String password, String name, {String? locale}) async {
    _setLoading(true);
    try {
      await _authService.registerWithEmail(email, password, name, locale: locale);
      _setLoading(false);
      return true;
    } catch (e) {
      // Clean up error message to be more user friendly
      String message = e.toString();
      if (message.startsWith('Exception: ')) {
        message = message.substring(11);
      }
      _setError(message);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> verifyCode(String email, String token, {String? locale}) async {
    _setLoading(true);
    try {
      await _authService.verifyCode(email, token, locale: locale);
      _setLoading(false);
      return true;
    } catch (e) {
      String message = e.toString();
      if (message.startsWith('Exception: ')) {
        message = message.substring(11);
      }
      _setError(message);
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<bool> resetPassword(String email, {String? locale}) async {
    _setLoading(true);
    try {
      await _authService.sendPasswordResetEmail(email, locale: locale);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> completePasswordReset(String email, String token, String password, String confirmation, {String? locale}) async {
    _setLoading(true);
    try {
      await _authService.resetPassword(email, token, password, confirmation, locale: locale);
      _setLoading(false);
      return true;
    } catch (e) {
      String message = e.toString();
      if (message.startsWith('Exception: ')) {
        message = message.substring(11);
      }
      _setError(message);
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
