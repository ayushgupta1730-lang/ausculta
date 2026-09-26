import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';

class ThemeController extends ChangeNotifier {
  ThemeController._internal();

  static final ThemeController instance = ThemeController._internal();

  static const String _themeKey = 'ausculta_theme';

  AuscultaTheme _theme = AuscultaTheme.clarity;

  bool _initialized = false;

  AuscultaTheme get theme => _theme;

  ThemeData get themeData => AppTheme.forTheme(_theme);

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;

    final preferences = await SharedPreferences.getInstance();

    final savedTheme = preferences.getString(_themeKey);

    if (savedTheme != null) {
      _theme = _themeFromString(savedTheme);
    }

    _initialized = true;
  }

  Future<void> setTheme(AuscultaTheme theme) async {
    if (_theme == theme) return;

    _theme = theme;

    notifyListeners();

    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _themeKey,
      _themeToString(theme),
    );
  }

  AuscultaTheme _themeFromString(String value) {
    switch (value) {
      case 'noir':
        return AuscultaTheme.noir;

      case 'ananya':
        return AuscultaTheme.ananya;

      case 'clarity':
      default:
        return AuscultaTheme.clarity;
    }
  }

  String _themeToString(AuscultaTheme theme) {
    switch (theme) {
      case AuscultaTheme.clarity:
        return 'clarity';

      case AuscultaTheme.noir:
        return 'noir';

      case AuscultaTheme.ananya:
        return 'ananya';
    }
  }
}