import 'dart:convert';
import 'dart:math';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:school_management/Model/AuthModel/SignUpModel.dart';
import 'package:school_management/View/Home/admin_home_screen.dart';
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Services/SettingsService.dart';
import 'package:school_management/core/forApi.dart';


class SignUpController extends GetxController{
  SettingService settingService=Get.find();

  final formKey=GlobalKey<FormState>();
  var fullNameController=TextEditingController();
  var emailController=TextEditingController();
  var phoneNumberController=TextEditingController();
  final  locationController = TextEditingController();
  final  passwordController = TextEditingController();
  final  passwordConfirmController = TextEditingController();
  var personalImageController = Rxn<XFile>();
  final ImagePicker _imagePicker=ImagePicker();
  var isLoading=false.obs;
  var isPasswordObsecured=false.obs;
  var isPasswordConfirmObsecured=false.obs;
  var passwordText="".obs;
  var passwordConfirmText="".obs;





  @override
  void onInit() {
    super.onInit();
  }




  Future<void> pickImage(ImageSource imageSource)async {
    final XFile? pickedFile=await _imagePicker.pickImage(
      source: imageSource,
      imageQuality: 25,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if(pickedFile!=null){
        personalImageController.value = pickedFile;
    }
    else
      return null;
  }

  void NextToSecondPage(){

    if(formKey.currentState?.validate()??false){
      Get.toNamed("/SignUpSecondPage");
    } else {
      Get.snackbar("Error", "Form validation failed or Form not found");
    }

    }

  void SignUp()async{
    if(formKey.currentState?.validate()??false){
      if (personalImageController.value == null) {
        Get.snackbar(
          "Missing Photos",
          "Please upload your personal photo.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,

          snackPosition: SnackPosition.TOP,
        );
        return ;
      }
      try {
        isLoading.value = true;
        //After Link
        // var request= http.MultipartRequest('POST',Uri.parse(AppConstants.linkSignUp));
        //
        // SignUpModel newUser=SignUpModel(
        //     fullName: fullNameController.text,
        //     email: emailController.text.trim(),
        //     phoneNumber: phoneNumberController.text,
        //     location: locationController.text,
        //     password: passwordController.text,
        //     passwordConfirm: passwordConfirmController.text
        //     );
        //
        // newUser.toJson().forEach((key,value){
        //   request.fields[key]=value.toString();
        // });
        //
        // request.files.add(await http.MultipartFile.fromPath('personal_image', personalImageController.value!.path));//
        // var streamResponse=await request.send();
        // var response=await http.Response.fromStream(streamResponse);
        //   if(response.statusCode==200||response.statusCode==201){
        //     var responseBody=jsonDecode(response.body);
        //     SignUpModel userResponse=SignUpModel.fromJson(responseBody);
        //         if (userResponse.token != null) {
        //           saveUserLogin(userResponse.token!);
        //           Get.offAllNamed("/AdminHomeScreen");
        //           Get.snackbar("Success", "Account created successfully");
        //         }else {
        //         var errorData = jsonDecode(response.body);
        //         Get.snackbar("Error", errorData['message'] ?? "Registration failed",
        //             backgroundColor: Colors.redAccent, colorText: Colors.white);
        //       }
        //   }
        
        await Future.delayed(const Duration(seconds: 2));

        Get.offAllNamed("/AdminHomeScreen");
      } catch (e) {
        Get.snackbar("Error", "Check your server connection: $e");
        print("Catch Error: $e");
      }finally{
        isLoading.value=false;
      }
    } else {
      print("Form validation failed or Form not found");
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
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    locationController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.onClose();
  }
}