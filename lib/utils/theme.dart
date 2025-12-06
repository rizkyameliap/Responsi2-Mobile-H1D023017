import 'package:flutter/material.dart';

class AppThemeM3 {
  static ThemeData get lightTheme {
    final Color seed = Colors.grey;

    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      primary: Colors.grey[800]!,
      secondary: Colors.blueGrey[400]!,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: Colors.grey[100],

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      textTheme: ThemeData.light().textTheme.apply(
            bodyColor: Colors.grey[800],
            displayColor: Colors.grey[900],
          ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),

      // ----------------------------
      // FIX BAGIAN ERROR DI SINI
      // ----------------------------

      cardTheme: CardThemeData(
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        margin: const EdgeInsets.all(8),
      ),

      dialogTheme: DialogThemeData(
        surfaceTintColor: Colors.transparent,
      ),

      dividerTheme: DividerThemeData(
        color: Colors.grey[300],
        thickness: 1,
      ),
    );
  }
}
