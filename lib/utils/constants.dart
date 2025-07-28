import 'package:flutter/material.dart';

/// A central place to define colours, fonts and other constants used
/// throughout the application.  Keeping these values together makes it
/// easy to change the look and feel of the app from one file.
class AppColors {
  // A soft blue used as the primary brand colour.
  static const Color primary = Color(0xFFA7C7E7);
  // A mint green accent colour used for highlights and buttons.
  static const Color accent = Color(0xFFA0D995);
  // A coral colour used sparingly for warnings or important actions.
  static const Color coral = Color(0xFFF88379);
  // Neutral greys for backgrounds and text.
  static const Color backgroundLight = Color(0xFFF7F9FA);
  static const Color backgroundDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFF222222);
  static const Color textDark = Color(0xFFF5F5F5);
}

class AppTheme {
  /// Light theme configuration.
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: Colors.white,
      background: AppColors.backgroundLight,
      onPrimary: AppColors.textLight,
      onSecondary: AppColors.textLight,
      onSurface: AppColors.textLight,
      onBackground: AppColors.textLight,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textLight,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16.0),
      bodyMedium: TextStyle(fontSize: 14.0),
      bodySmall: TextStyle(fontSize: 12.0),
    ),
  );

  /// Dark theme configuration.
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: Color(0xFF2C2C2C),
      background: AppColors.backgroundDark,
      onPrimary: AppColors.textDark,
      onSecondary: AppColors.textDark,
      onSurface: AppColors.textDark,
      onBackground: AppColors.textDark,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textDark,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16.0),
      bodyMedium: TextStyle(fontSize: 14.0),
      bodySmall: TextStyle(fontSize: 12.0),
    ),
  );
}
