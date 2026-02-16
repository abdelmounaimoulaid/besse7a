
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  FirebaseAuth? _auth;
  bool _useMock = false;

  AuthService() {
    try {
      _auth = FirebaseAuth.instance;
    } catch (e) {
      if (kDebugMode) {
        print("Firebase Auth not initialized, using mock: $e");
      }
      _useMock = true;
    }
  }

  // Retrieve current user
  Stream<UserModel?> get user {
    if (_useMock || _auth == null) {
      // Return a dummy user stream that mimics auth state changes if we were to implement full mock logic
      // For now, just return null (logged out) or a static stream if we implemented mock state
      return Stream.value(null); 
    }
    return _auth!.authStateChanges().map(_userFromFirebaseUser);
  }

  // Convert Firebase User to UserModel
  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid, email: user.email, displayName: user.displayName) : null;
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmail(String email, String password) async {
    if (_useMock || _auth == null) {
       await Future.delayed(const Duration(seconds: 1)); // Simulate network
       // Mock success
       return UserModel(uid: 'mock_uid_123', email: email, displayName: 'Mock User');
    }

    try {
      final UserCredential result = await _auth!.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      if (kDebugMode) {
        print("Error signing in: $e");
      }
      rethrow;
    }
  }

  // Register with email and password
  Future<UserModel?> registerWithEmail(String email, String password) async {
    if (_useMock || _auth == null) {
       await Future.delayed(const Duration(seconds: 1)); // Simulate network
       // Mock success
       return UserModel(uid: 'mock_uid_new', email: email, displayName: 'New User');
    }

    try {
      final UserCredential result = await _auth!.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      if (kDebugMode) {
        print("Error registering: $e");
      }
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    if (_useMock || _auth == null) {
      return; 
    }
    try {
      return await _auth!.signOut();
    } catch (e) {
      if (kDebugMode) {
        print("Error signing out: $e");
      }
      return;
    }
  }

  // Forgot Password
  Future<void> sendPasswordResetEmail(String email) async {
    if (_useMock || _auth == null) {
      await Future.delayed(const Duration(seconds: 1));
      return;
    }
    try {
      await _auth!.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (kDebugMode) {
        print("Error sending password reset email: $e");
      }
      rethrow;
    }
  }
}
