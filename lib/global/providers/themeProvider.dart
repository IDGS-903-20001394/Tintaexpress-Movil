import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme = ThemeData.dark();


  final Color _primaryColor = Colors.yellow[700]!;

  ThemeProvider({
    required bool isDarkMode,
  }) {
    isDarkMode ? setDarkMode() : setLightMode();
  }

  setLightMode() {
    currentTheme = ThemeData.light().copyWith(
      primaryColor: _primaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blue,
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _primaryColor, width: 2.0),
        ),
        labelStyle: const TextStyle(color: Colors.black),
        focusColor: _primaryColor,
      ),
    );
    notifyListeners();
  }

  setDarkMode() {
    currentTheme = ThemeData.dark().copyWith(
      primaryColor: _primaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
    );
    notifyListeners();
  } 
}