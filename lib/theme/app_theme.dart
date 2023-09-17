

import 'package:flutter/material.dart';

const Color _customColor= Color(0xFF1193D4);
const List <Color> _colorThemes = [
  _customColor,
  Colors.black,
  Colors.white,
  Colors.yellowAccent,
  Colors.blueAccent,
  Color(0xFF1597D7),
  Colors.lightBlueAccent,
  Colors.amber,
  Colors.orange,
  Colors.pink

];
class AppTheme {
  late final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0,
            'Colors must be between 0 and ${_colorThemes.length}');

  ThemeData theme(BuildContext context) {
    
    // Define los temas claro y oscuro
    ThemeData lightTheme = ThemeData(
      
      useMaterial3: true,
      brightness: Brightness.light,
       colorScheme: const ColorScheme.light().copyWith(primary: _colorThemes[selectedColor]),
    );

    ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark().copyWith(primary: _colorThemes[selectedColor]),
    );

    // Usa ThemeMode.system para elegir automáticamente el tema claro u oscuro
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark
        ? darkTheme
        : lightTheme;
  }
}
