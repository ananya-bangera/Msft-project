import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
      ));

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
      ));
}

class obj {
  String? name;
  String img;

  obj({required this.name, required this.img});
}

//Colors
class myColors {
  static const calculatorScreen = const Color(0xff222433);
  static const calculatorButton = const Color(0xff2C3144);
  static const calculatorFunctionButton = const Color(0xff35364A);
  static const calculatorYellow = const Color(0xffFEBc06);
}
