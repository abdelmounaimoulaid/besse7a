
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mobile_app/models/user_model.dart';

class AuthService {
  // Use a StreamController to broadcast user changes
  final StreamController<UserModel?> _userController = StreamController<UserModel?>.broadcast();

  AuthService() {
    // Initialize with no user (logged out)
    // In a real mock with persistence, you might check SharedPreferences here
    _userController.add(null);
  }

  // Retrieve current user stream
  Stream<UserModel?> get user => _userController.stream;

  // Sign in with email and password
  Future<UserModel?> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // Mock success - create a dummy user
    final user = UserModel(uid: 'mock_uid_123', email: email, displayName: 'Mock User');
    _userController.add(user);
    if (kDebugMode) {
      print("Mock Sign In: $email");
    }
    return user;
  }

  // Register with email and password
  Future<UserModel?> registerWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // Mock success
    final user = UserModel(uid: 'mock_uid_new', email: email, displayName: 'New User');
    _userController.add(user);
    if (kDebugMode) {
      print("Mock Register: $email");
    }
    return user;
  }

  // Sign out
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _userController.add(null);
    if (kDebugMode) {
      print("Mock Sign Out");
    }
  }

  // Forgot Password
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print("Mock Password Reset Sent to: $email");
    }
  }
  
  void dispose() {
    _userController.close();
  }
}
