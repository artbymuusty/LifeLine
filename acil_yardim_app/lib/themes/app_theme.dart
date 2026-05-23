import 'package:flutter/material.dart';

class AppTheme {
  /// Açık tema (Light)
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.redAccent.shade700,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'DancingScript',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'DancingScript',
        fontSize: 48,
        shadows: [
          Shadow(blurRadius: 4, offset: Offset(2, 2), color: Colors.black26),
        ],
      ),
      bodySmall: TextStyle(color: Colors.black87, fontSize: 14),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.redAccent.shade700,
      titleTextStyle: const TextStyle(
        fontFamily: 'DancingScript',
        fontSize: 20,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent.shade700,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.redAccent.shade700),
      trackColor: MaterialStateProperty.all(Colors.redAccent.shade200),
    ),
  );

  /// Koyu tema (Dark)
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.redAccent.shade200,
    scaffoldBackgroundColor: Colors.grey[900],
    fontFamily: 'DancingScript',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'DancingScript',
        fontSize: 48,
        shadows: [
          Shadow(blurRadius: 4, offset: Offset(2, 2), color: Colors.black87),
        ],
      ),
      bodySmall: TextStyle(color: Colors.white70, fontSize: 14),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      titleTextStyle: const TextStyle(
        fontFamily: 'DancingScript',
        fontSize: 20,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent.shade200,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.redAccent.shade200),
      trackColor: MaterialStateProperty.all(Colors.redAccent.shade100),
    ),
  );
}
