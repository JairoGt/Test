import 'package:appseguimiento/theme/app_theme.dart';
import 'package:flutter/material.dart';


class AppThemeProvider extends ChangeNotifier {
  AppTheme _appTheme = AppTheme(selectedColor: 0);

  AppTheme get appTheme => _appTheme;

  set appTheme(AppTheme newAppTheme) {
    _appTheme = newAppTheme;
    notifyListeners();
  }
}