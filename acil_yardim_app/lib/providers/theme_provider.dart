// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  bool get isDarkMode => _isDark;
  void toggleTheme(bool value) {
    _isDark = value;
    notifyListeners();
  }
}

