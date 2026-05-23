// lib/providers/auth_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
String? _token;
User? _currentUser;

/// JWT token
String? get token => _token;

/// Giriş yapıldı mı?
bool get isLoggedIn => _token != null;

/// Aktif kullanıcı bilgisi
User? get currentUser => _currentUser;

/// Giriş yap, token ve kullanıcı bilgisini SharedPreferences'a kaydet
Future login(String token, User user) async {
_token = token;
_currentUser = user;

final prefs = await SharedPreferences.getInstance();
await prefs.setString('jwt_token', token);
await prefs.setString('user_data', jsonEncode(user.toJson()));

notifyListeners();

}

/// Uygulama başlangıcında kayıtlı oturumu geri yükle
Future tryAutoLogin() async {
final prefs = await SharedPreferences.getInstance();
if (!prefs.containsKey('jwt_token') || !prefs.containsKey('user_data')) {
return;
}

final storedToken = prefs.getString('jwt_token');
final storedUser = prefs.getString('user_data');
if (storedToken == null || storedUser == null) return;

_token = storedToken;
_currentUser = User.fromJson(jsonDecode(storedUser) as Map<String, dynamic>);

notifyListeners();

}

/// Çıkış yap, SharedPreferences'tan verileri sil ve state'i temizle
Future logout() async {
_token = null;
_currentUser = null;

final prefs = await SharedPreferences.getInstance();
await prefs.remove('jwt_token');
await prefs.remove('user_data');

notifyListeners();

}
}