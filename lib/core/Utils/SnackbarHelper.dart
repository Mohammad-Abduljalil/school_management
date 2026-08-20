import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  static void showSuccess({required String title, required String message}) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: const Color(0xFF00A99D), // Brand green
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  static void showError({required String title, required String message}) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.redAccent,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  static void showWarning({required String title, required String message}) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.orangeAccent,
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
    );
  }

  static void _showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    required Widget icon,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      icon: icon,
      margin: const EdgeInsets.all(15),
      duration: const Duration(seconds: 3),
      borderRadius: 10,
      shouldIconPulse: true,
      barBlur: 20,
    );
  }
}
