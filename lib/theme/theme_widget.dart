import 'package:flutter/material.dart';

ThemeData get getThemeData {
  return ThemeData(


    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      primary: Colors.deepPurple,
      secondary: Colors.amber,
      tertiary: Colors.green,
      brightness: Brightness.light,
      error: Colors.red,
      dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
    ),

    useMaterial3: true,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
    ),


    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 8,
      surfaceTintColor: Colors.deepPurple,
      shadowColor: Colors.amber,
    ),



    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black54),
      bodySmall: TextStyle(color: Colors.black38),
      headlineLarge: TextStyle(color: Colors.black, fontSize: 57),
      headlineMedium: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black54),
      titleSmall: TextStyle(color: Colors.black38),
    ),
  );
}
final ColorScheme colorScheme = ColorScheme(
  brightness: Brightness.light,

  primary: Color(0xFF6C4CFF),       // Deep Purple (used in buttons, cards)
  onPrimary: Colors.white,          // Text on purple backgrounds

  secondary: Color(0xFFFF6B00),     // Bright Orange (used in expense cards)
  onSecondary: Colors.white,        // Text on orange background

  tertiary: Color(0xFF1C1C1E),      // Dark navy / black (used in dark cards)
  onTertiary: Colors.white,  // Default text color

  surface: Color(0xFFFFFFFF),       // Cards & panels
  onSurface: Color(0xFF1A1A1A),     // Text on cards

  error: Color(0xFFFF3B30),         // Red tone for error/spending alerts
  onError: Colors.white,            // Text on error

  primaryContainer: Color(0xFFEEE5FF),  // Lighter variant of primary
  secondaryContainer: Color(0xFFFFE5D6), // Lighter variant of secondary
);



ThemeMode getThemeMode(int mode) {
  switch (mode) {
    case 0:
      return ThemeMode.dark;
    case 1:
      return ThemeMode.light;
    case 2:
      return ThemeMode.system;
    default:
      return ThemeMode.system;
  }
}