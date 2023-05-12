import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePre{
  static const Theme_Status = "THEMESTATUC";

  setDarkTheme (bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setBool(Theme_Status, value);
  }
  Future <bool>getTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getBool(Theme_Status, ) ?? false;
  }
}