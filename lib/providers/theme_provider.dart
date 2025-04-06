import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider extends ChangeNotifier {
  // Secure storage to persist theme preference
  final _storage = const FlutterSecureStorage();

  // Default theme mode
  ThemeMode _themeMode = ThemeMode.light;

  // Getter for current theme mode
  ThemeMode get themeMode => _themeMode;

  // Helper to check if dark mode is active
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Constructor: load saved theme preference
  ThemeProvider() {
    _loadTheme(); // Load theme on initialization
  }

  // Toggle theme and save preference
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    _storage.write(key: 'themeMode', value: isOn ? 'dark' : 'light');
    notifyListeners();
  }

  // Load theme preference from secure storage
  Future<void> _loadTheme() async {
    final theme = await _storage.read(key: 'themeMode');
    if (theme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}
