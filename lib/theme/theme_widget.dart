import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/theme/theme_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(useMaterial3: true).copyWith(
    colorScheme: lightColorScheme,
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Color(0xFFFfFfFf),
      elevation: 0,
    ),
    extensions: [AppColorTheme()],
    canvasColor: Color(0xFFFfFfFf),
    textTheme: GoogleFonts.openSansTextTheme(),
  );

  static ColorScheme lightColorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFD673A),
    onPrimary: Color(0xfffdf9f4),
    secondary: Color(0xFFDEDEDF),
    onSecondary: Colors.black,
    error: Color(0xFFB00020),
    onError: Colors.white,
    surface: Color(0xFFFFFFFF),
    onSurface: Colors.black,
    inverseSurface: Color(0xFFFFFFFF),
  );
}
