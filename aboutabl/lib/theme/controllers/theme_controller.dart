import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController with ChangeNotifier {
  final SharedPreferences? sharedPreferences;
  ThemeController({required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    sharedPreferences!.setBool(AppConstants.theme, _darkTheme);
    notifyListeners();
  }

  void _loadCurrentTheme() async {
    _darkTheme = sharedPreferences!.getBool(AppConstants.theme) ?? false;
    notifyListeners();
  }

  Color? _selectedPrimaryColor;
  Color? _selectedSecondaryColor;
  Color? get selectedPrimaryColor => _selectedPrimaryColor;
  Color? get selectedSecondaryColor => _selectedSecondaryColor;

  void setThemeColor({Color? primaryColor, Color? secondaryColor}) {
    _selectedPrimaryColor = primaryColor;
    _selectedSecondaryColor = secondaryColor;
    notifyListeners();
  }
}
