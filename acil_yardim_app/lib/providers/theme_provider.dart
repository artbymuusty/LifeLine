// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  bool get isDarkMode => _isDark;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDark = prefs.getBool('is_dark_mode') ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Tema yükleme hatası: $e');
    }
  }

  Future<void> toggleTheme(bool value) async {
    _isDark = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_dark_mode', value);
    } catch (e) {
      debugPrint('Tema kaydetme hatası: $e');
    }
  }
}
