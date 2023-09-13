

import 'package:flutter/material.dart';

const Color _customColor= Color(0xFF5c11d4);
const List <Color> _colorThemes = [
  _customColor,
  Colors.black,
  Colors.white,
  Colors.yellowAccent,
  Colors.blueAccent,
  Colors.blueGrey,
  Colors.lightBlueAccent,
  Colors.amber,
  Colors.orange,
  Colors.pink

];

class AppTheme{
  late final int selectedColor;

  AppTheme({this.selectedColor =0}):assert (selectedColor >=0,'Colors must be betwen 0 and ${_colorThemes.length}');

  ThemeData theme(){
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: _colorThemes[selectedColor],
      //brightness: Brightness.dark

    );
  }
}