import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadThemeMode();
    return ThemeMode.system;
  }

  static const _themeModeKey = 'theme_mode';
  final _preferences = SharedPreferencesAsync();

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    await _preferences.setString(_themeModeKey, themeMode.name);
  }

  

  Future<void> _loadThemeMode() async {
    final savedThemeMode = await _preferences.getString(_themeModeKey);

    if (!ref.mounted) return;

    state = switch (savedThemeMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  
}
