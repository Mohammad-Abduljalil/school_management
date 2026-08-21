import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingService extends GetxService{
  late SharedPreferences sharedPreferences;
  static const String themeKey = "isDarkMode";
  static const String guestModeKey = "isGuestMode";
  late RxBool isDark;
  var isGuestMode = false.obs;

  Future<SettingService> init()async {
    sharedPreferences=await SharedPreferences.getInstance();
    isDark = isDarkMode().obs;
    isGuestMode.value = sharedPreferences.getBool(guestModeKey) ?? false;
    return this;
  }
  static Future<void> initServices() async {
    await Get.putAsync(() => SettingService().init());
  }

  bool isDarkMode() {
    return sharedPreferences.getBool(themeKey) ?? false;
  }

  void saveTheme(bool isDarkMode) {
    sharedPreferences.setBool(themeKey, isDarkMode);
    isDark.value = isDarkMode;
  }

  void setGuestMode(bool isGuest) {
    sharedPreferences.setBool(guestModeKey, isGuest);
    isGuestMode.value = isGuest;
  }

  ThemeMode getThemeMode() {
    return isDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    bool nextMode = !isDark.value;
    Get.changeThemeMode(nextMode ? ThemeMode.dark : ThemeMode.light);
    saveTheme(nextMode);
  }
}