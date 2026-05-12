import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController{
  final formKey=GlobalKey<FormState>();
  final formKeyForCodeVerification=GlobalKey<FormState>();
  final formKeyForNewPassword=GlobalKey<FormState>();
  late TextEditingController emailVerificationController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;
  late TextEditingController codeVerificationController;
  var isLoading=false.obs;
  var isPasswordObsecured=true.obs;
  var isPasswordConfirmObsecured=true.obs;
  var passwordText=''.obs;
  var passwordConfirmText=''.obs;

  @override
  void onInit() {
    emailVerificationController=TextEditingController();
    passwordController=TextEditingController();
    passwordConfirmController=TextEditingController();
    codeVerificationController=TextEditingController();
    super.onInit();
  }

  void SendCode()async{
    if(formKey.currentState!.validate()){
      isLoading.value=true;
      await Future.delayed(Duration(seconds: 2));
      print("validated");
      Get.toNamed('/ForCodeVerification');
      isLoading.value=false;
    }
    else
      print("non-validated");
  }

  void VerifyCode()async{
    String code=codeVerificationController.text;
    if(code.length==6){
      isLoading.value=true;
      await Future.delayed(Duration(seconds: 2));
      print("verifying code: $code");
      Get.offAllNamed('/NewPasswordPage');
      isLoading.value=false;
    }else {
      Get.snackbar("Error", "Please enter the full 6-digit code");
    }
  }

  void resetPassword()async{
    if(formKeyForNewPassword.currentState!.validate()){
      isLoading.value=true;
      await Future.delayed(Duration(seconds: 2));
      Get.delete<ForgetPasswordController>(force: true);
      Get.offAllNamed('/signIn');
      isLoading.value=false;
    }else {
      Get.snackbar("Error", "Please enter the full 6-digit code");
    }

  }

  void resendCode()async {
    print("Resend Code");
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