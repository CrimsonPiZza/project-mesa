import 'package:flutter/material.dart';

class Themes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(16, 22, 25, 1),
    colorScheme: const ColorScheme.dark().copyWith(),
  );

  static const Color textColor = Color.fromRGBO(197, 199, 200, 1);
  static const Color textOnCardColor = Color.fromRGBO(22, 30, 33, 1);
  static const Color primaryColor = Color.fromRGBO(66, 153, 172, 1);
  static const Color primaryColorHighlighted = Color.fromRGBO(95, 245, 255, 1);
  static const Color card = Color.fromRGBO(23, 30, 33, 1);
}
