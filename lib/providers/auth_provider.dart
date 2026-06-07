// lib/providers/auth_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User _user;

  // FIX: Also restore the token from SharedPreferences on construction so
  // ApiService._authHeaders() finds a valid token after app restart.
  // This is called once in main() before runApp(), so the token is already
  // in SharedPreferences by the time any screen makes an API call.
  AuthProvider({User? initialUser}) : _user = initialUser ?? User.guest();

  User get user => _user;
  bool get isLoggedIn => !_user.isGuest;
  bool get isGuest => _user.isGuest;
  bool get isIntern => _user.isIntern;
  bool get isCompany => _user.isCompany;

  /// Called after a successful login or register.
  /// Persists BOTH the user object and the token.
  Future<void> setUser(User user, {String? token}) async {
    _user = user;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
    // FIX: if a fresh token is provided (from the login response), save it.
    if (token != null && token.isNotEmpty) {
      await prefs.setString('token', token);
    }
  }

  Future<void> clearAuth() async {
    _user = User.guest();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('token');
  }
}
