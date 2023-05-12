
import 'package:flutter/material.dart';
import 'package:shopping_app_flutter/models/dark_theme_pre.dart';

class DarkThemeProvider with ChangeNotifier{
  DarkThemePre darkThemePre = DarkThemePre();
  bool _darkTheme = false ;
  bool get darkTheme=>_darkTheme;

  set darkTheme (bool value){
    _darkTheme = value;
    darkThemePre.setDarkTheme(value);
    notifyListeners();
  }
}