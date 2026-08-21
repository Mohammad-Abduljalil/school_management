import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingService extends GetxService{
  late SharedPreferences sharedPreferences;
  static const String themeKey = "isDarkMode";
  static const String guestModeKey = "isGuestMode";
  static const String languageKey = "langCode";

  late RxBool isDark;
  var isGuestMode = false.obs;
  var currentLocale = const Locale('en').obs;

  Future<SettingService> init()async {
    sharedPreferences=await SharedPreferences.getInstance();
    isDark = isDarkMode().obs;
    isGuestMode.value = sharedPreferences.getBool(guestModeKey) ?? false;
    
    String? langCode = sharedPreferences.getString(languageKey);
    if (langCode != null) {
      currentLocale.value = Locale(langCode);
    } else {
      // Default to Arabic if system locale is Arabic, else English
      currentLocale.value = Get.deviceLocale?.languageCode == 'ar' ? const Locale('ar') : const Locale('en');
    }
    
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

  void changeLanguage(String langCode) {
    Locale locale = Locale(langCode);
    Get.updateLocale(locale);
    sharedPreferences.setString(languageKey, langCode);
    currentLocale.value = locale;
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