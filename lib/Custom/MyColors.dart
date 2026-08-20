import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyColors {
  static Color get backgroundColor => Get.isDarkMode
      ? const Color(0xFF0F111A) 
      : const Color(0xFF1C3486);

  static Color get pageContentColor => Get.isDarkMode 
      ? const Color(0xFF0F111A) 
      : const Color(0xFFF3F4F9);

  static Color get borderColor => Get.isDarkMode 
      ? Colors.white24 
      : const Color(0xFF1C3486);

  static Color get iconInAuthTextFieldColor => const Color(0xFF9CA3AF);
  
  static Color get labelUpOfTextFieldInLoginPageColor => Get.isDarkMode 
      ? Colors.white70 
      : const Color(0xFF545455);

  static Color get hintTextFieldInLoginPageColor => const Color(0xFF64748B);
  
  static Color get hintTextInTextFieldInSignUp => const Color(0xFF64748B);

  // Sidebar specific colors
  static Color get sidebarItemSelectedColor => Get.isDarkMode 
      ? const Color(0xFF2C2C2C) 
      : const Color(0xFF0C3A75);

  static Color get sidebarTextColor => Get.isDarkMode 
      ? Colors.white70 
      : const Color(0xFF8DA3E0);

  static Color get primaryText => Get.isDarkMode 
      ? Colors.white 
      : const Color(0xFF0D1E49);
}
