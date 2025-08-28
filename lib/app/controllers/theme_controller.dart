import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../themes/app_themes.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  ThemeData get theme => isDarkMode.value ? AppThemes.darkTheme : AppThemes.lightTheme;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
