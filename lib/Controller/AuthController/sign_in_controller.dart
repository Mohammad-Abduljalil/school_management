import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/Model/AuthModel/SignInModel.dart';
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Services/SettingsService.dart';
import 'package:school_management/core/Utils/ErrorHandler.dart';

class SignInController extends GetxController {
  SettingService settingService = Get.find();
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  var isPasswordObsecured = true.obs;
  var passwordText = "".obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  Future<void> SignIn() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        SignInModel loginData = SignInModel(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
        Map<String, dynamic> body = loginData.toJson();

        var response = await http.post(
          Uri.parse(AppConstants.linkLogIn),
          headers: {"Accept": "application/json", "Content-Type": "application/json"},
          body: jsonEncode(body),
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          SignInModel userResponse = SignInModel.fromJson(responseBody);
          saveUserLogin(userResponse.token!);
          Get.offAllNamed('/AdminHomeScreen');
        } else {
          ErrorHandler.handleHttpError(response);
        }
      } catch (e) {
        ErrorHandler.handleException(e);
      } finally {
        isLoading.value = false;
      }
    }
  }

  void saveUserLogin(String token) {
    settingService.sharedPreferences.setString("token", token);
    settingService.sharedPreferences.setBool("isLoggedIn", true);
  }

  String? getToken() {
    return settingService.sharedPreferences.getString("token");
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
