import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:school_management/Model/AuthModel/SignUpModel.dart';
import 'package:school_management/View/Home/HomeScreen.dart';
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Services/SettingsService.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';


class SignUpController extends GetxController{
  SettingService settingService=Get.find();

  final formKey=GlobalKey<FormState>();
  final formKeySecond=GlobalKey<FormState>();
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController  locationController;
  late TextEditingController  passwordController;
  late TextEditingController  passwordConfirmController;
  var personalImageController = Rxn<XFile>();
  final ImagePicker _imagePicker=ImagePicker();
  var isLoading=false.obs;
  var isPasswordObsecured=true.obs;
  var isPasswordConfirmObsecured=true.obs;
  var passwordText="".obs;
  var passwordConfirmText="".obs;





  @override
  void onInit() {
    fullNameController=TextEditingController();
    emailController=TextEditingController();
    phoneNumberController=TextEditingController();
    locationController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
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
      SnackbarHelper.showError(title: "Error", message: "Form validation failed or form not found");
    }

    }

  void SignUp()async{
    if(formKeySecond.currentState?.validate()??false){
      if (personalImageController.value == null) {
        SnackbarHelper.showError(title: "Error", message: "Please upload your personal photo");
        return ;
      }
      try {
        isLoading.value = true;
        SnackbarHelper.showWarning(title: "Warning", message: "Account creation has been temporarily suspended!");
        // var request= http.MultipartRequest('POST',Uri.parse(AppConstants.linkSignUp));
        // request.fields['full_name'] = fullNameController.text;
        // request.fields['email'] = emailController.text.trim();
        // request.fields['phone'] = phoneNumberController.text;
        // request.fields['location'] = locationController.text;
        // request.fields['password'] = passwordController.text;
        // request.fields['password_confirmation'] = passwordConfirmController.text;
        // request.fields['role'] = 'super_admin';
        //
        //
        // if(kIsWeb){
        //   var bytes=await personalImageController.value!.readAsBytes();
        //   request.files.add(http.MultipartFile.fromBytes('profile_image', bytes,filename: personalImageController.value!.name,));
        //
        // }else{
        //   request.files.add(await http.MultipartFile.fromPath(
        //       'profile_image',
        //       personalImageController.value!.path
        //   ));
        //
        // }
        // request.headers.addAll({
        //   'Accept': 'application/json',
        //   'X-Requested-With': 'XMLHttpRequest',
        // });
        // var streamResponse=await request.send();
        //
        // var response=await http.Response.fromStream(streamResponse);
        //   if(response.statusCode==200||response.statusCode==201){
        //     var responseBody=jsonDecode(response.body);
        //
        //     SignUpModel userResponse=SignUpModel.fromJson(responseBody);
        //
        //     if (userResponse.token != null) {
        //           saveUserLogin(userResponse.token!);
        //           Get.offAllNamed("/AdminHomeScreen");
        //           SnackbarHelper.showSuccess(title: "Success", message: "Account created successfully");
        //         }else {
        //         var errorData = jsonDecode(response.body);
        //         SnackbarHelper.showError(title: "Error", message: errorData['message'] ?? "Registration failed");
        //       }
        //   }

      } catch (e) {
        SnackbarHelper.showError(title: "Error", message: "Check your server connection: $e");
      }finally{
        isLoading.value=false;
      }
    } else {
      SnackbarHelper.showError(title: "Error", message: "Form validation failed or form not found");
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