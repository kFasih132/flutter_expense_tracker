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
