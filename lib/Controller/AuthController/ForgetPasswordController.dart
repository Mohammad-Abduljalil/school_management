import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/core/Utils/ErrorHandler.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import '../../core/AppConstants.dart';

class ForgetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final formKeyForCodeVerification = GlobalKey<FormState>();
  final formKeyForNewPassword = GlobalKey<FormState>();
  late TextEditingController emailVerificationController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;
  late TextEditingController codeVerificationController;
  var isLoading = false.obs;
  var isPasswordObsecured = true.obs;
  var isPasswordConfirmObsecured = true.obs;
  var passwordText = ''.obs;
  var passwordConfirmText = ''.obs;

  @override
  void onInit() {
    emailVerificationController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
    codeVerificationController = TextEditingController();
    super.onInit();
  }

  void SendCode() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;

        var response = await http.post(
          Uri.parse(AppConstants.linkEmailForForgetPassword),
          headers: {"Accept": "application/json", "Content-Type": "application/json"},
          body: jsonEncode({
            'email': emailVerificationController.text.trim(),
          }),
        );

        if (response.statusCode == 200) {
          Get.toNamed('/ForCodeVerification');
        } else {
          ErrorHandler.handleHttpError(response);
        }
      } catch (e) {
        ErrorHandler.handleException(e);
      } finally {
        isLoading.value = false;
      }
    } else {
      SnackbarHelper.showError(title: "Error", message: "Please enter a valid email address");
    }
  }

  void VerifyCode() async {
    String code = codeVerificationController.text;
    if (code.length == 6) {
      try {
        isLoading.value = true;
        // The API might need a real verification call here, but for now maintaining logic
        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed('/NewPasswordPage');
      } catch (e) {
        ErrorHandler.handleException(e);
      } finally {
        isLoading.value = false;
      }
    } else {
      SnackbarHelper.showError(title: "Error", message: "Please enter the full 6-digit code");
    }
  }

  void resetPassword() async {
    if (formKeyForNewPassword.currentState!.validate()) {
      try {
        isLoading.value = true;
        var response = await http.post(
          Uri.parse(AppConstants.linkResetPassword),
          headers: {"Accept": "application/json", "Content-Type": "application/json"},
          body: jsonEncode({
            'email': emailVerificationController.text.trim(),
            'otp': codeVerificationController.text,
            'password': passwordController.text,
            'password_confirmation': passwordConfirmController.text,
          }),
        );
        if (response.statusCode == 200) {
          Get.delete<ForgetPasswordController>(force: true);
          Get.offAllNamed('/signIn');
          SnackbarHelper.showSuccess(title: "Success", message: "Password changed successfully");
        } else {
          ErrorHandler.handleHttpError(response);
        }
      } catch (e) {
        ErrorHandler.handleException(e);
      } finally {
        isLoading.value = false;
      }
    } else {
      SnackbarHelper.showError(title: "Error", message: "Please check your inputs");
    }
  }

  void resendCode() async {
    Get.offNamed('/ForEmail');
  }

  @override
  void onClose() {
    emailVerificationController.dispose();
    passwordController.dispose();
    codeVerificationController.dispose();
    passwordConfirmController.dispose();
    super.onClose();
  }
}
