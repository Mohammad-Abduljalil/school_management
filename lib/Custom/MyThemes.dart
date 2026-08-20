import 'package:flutter/material.dart';

class MyThemes {

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF1C3486),
    scaffoldBackgroundColor: const Color(0xFFF3F4F9),
    cardColor: Colors.white,
    dividerColor: Colors.grey[300],
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1C3486),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1C3486),
      secondary: Color(0xFF00A991),
      surface: Colors.white,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1C3486),
    scaffoldBackgroundColor: const Color(0xFF0F111A),
    cardColor: const Color(0xFF161922),
    dividerColor: Colors.white10,
    canvasColor: const Color(0xFF0F111A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF161922),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1C3486),
      secondary: Color(0xFF00A991),
      surface: Color(0xFF161922),
      onSurface: Colors.white,
    ),
  );
}
