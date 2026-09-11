import 'package:flutter/material.dart';
import 'package:tasks_app/app/theme/typography/app_typography.dart';

class AppTheme {
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.light,
  );

  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.dark,
  );

  static final ThemeData lightTheme = _createTheme(lightColorScheme);

  static final ThemeData darkTheme = _createTheme(darkColorScheme);

  static ThemeData _createTheme(ColorScheme colorScheme) {
    final baseTheme = ThemeData(useMaterial3: true, colorScheme: colorScheme);

    return baseTheme.copyWith(
      textTheme: AppTypography.textTheme(baseTheme.textTheme),
    );
  }
}
