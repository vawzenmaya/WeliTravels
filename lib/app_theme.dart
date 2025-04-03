import 'package:flutter/material.dart';

class AppTheme {
  static final Color _lightPrimaryColor = Colors.purple.shade800;
  static final Color _lightSecondaryColor = Colors.deepPurple.shade700;
  static const Color _lightBackgroundColor = Color(0xFFF5F5F5);
  static const Color _lightCardColor = Colors.white;

  static final Color _darkPrimaryColor = Colors.purple.shade200;
  static final Color _darkSecondaryColor = Colors.deepPurple.shade200;
  static const Color _darkBackgroundColor = Color(0xFF121212);
  static const Color _darkCardColor = Color(0xFF1E1E1E);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: _lightPrimaryColor,
    scaffoldBackgroundColor: _lightBackgroundColor,
    cardColor: _lightCardColor,
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      secondary: _lightSecondaryColor,
      surface: _lightCardColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _lightPrimaryColor,
      foregroundColor: Colors.white,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return _lightPrimaryColor;
        }
        return Colors.grey.shade400;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return _lightPrimaryColor.withOpacity(0.5);
        }
        return Colors.grey.shade300;
      }),
    ),
    dividerColor: Colors.grey.shade200,
    textTheme: const TextTheme(
      titleMedium: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: _darkPrimaryColor,
    scaffoldBackgroundColor: _darkBackgroundColor,
    cardColor: _darkCardColor,
    colorScheme: ColorScheme.dark(
      primary: _darkPrimaryColor,
      secondary: _darkSecondaryColor,
      surface: _darkCardColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _darkBackgroundColor,
      foregroundColor: _darkPrimaryColor,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return _darkPrimaryColor;
        }
        return Colors.grey.shade700;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return _darkPrimaryColor.withOpacity(0.5);
        }
        return Colors.grey.shade800;
      }),
    ),
    dividerColor: Colors.grey.shade800,
    textTheme: const TextTheme(
      titleMedium: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}
