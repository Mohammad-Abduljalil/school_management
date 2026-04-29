import 'dart:convert';
import 'dart:math';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';


class SignUpController extends GetxController{
  final formKey=GlobalKey<FormState>();
  var fullNameController=TextEditingController();
  var emailController=TextEditingController();
  var phoneNumberController=TextEditingController();
  final  schoolNameController = TextEditingController();
  final  locationController = TextEditingController();
  final  passwordController = TextEditingController();
  final  passwordConfirmController = TextEditingController();
  var personalImageController = Rxn<XFile>();
  var idImageController = Rxn<XFile>();
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




  Future<void> pickImage(ImageSource imageSource,bool isPersonalImage)async {
    final XFile? pickedFile=await _imagePicker.pickImage(
      source: imageSource,
      imageQuality: 25,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if(pickedFile!=null){
      if(isPersonalImage)
        personalImageController.value = pickedFile;
      else
        idImageController.value=pickedFile;
    }
    else
      return null;
  }

  void SignUp()async{
    if(formKey.currentState?.validate()??false){
      if (personalImageController.value == null || idImageController.value == null) {
        Get.snackbar(
          "Missing Photos",
          "Please upload both your personal photo and ID photo.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,

          snackPosition: SnackPosition.TOP,
        );
        return ;
      }
      try {
        isLoading.value = true;
        await Future.delayed(const Duration(seconds: 2));
        print("SignUp Success with: ${emailController.text}");
        isLoading.value = false;

      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Error", "Check your server connection: $e");
        print("Catch Error: $e");
      }
    } else {
      print("Form validation failed or Form not found");
    }}

  // void SignUp()async{
  //   if(formKey.currentState!.validate()){
  //     if (personalImageController.value == null || idImageController.value == null) {
  //       Get.snackbar(
  //         "Missing Photos",
  //         "Please upload both your personal photo and ID photo.",
  //         backgroundColor: Colors.redAccent,
  //         colorText: Colors.white,
  //
  //         snackPosition: SnackPosition.TOP,
  //       );
  //       return ;
  //     }
  //     try{
  //       isLoading.value=true;
  //       print("يتم الارسال");
  //       var request=http.MultipartRequest('POST',Uri.parse(AppLinks.linkSignUp));
  //       request.fields.addAll({
  //         'first_name' :firstNameController.text,
  //         'last_name' :lastNameController.text,
  //         'email' :emailController.text,
  //         'password' :passwordController.text,
  //         'phone' :phoneNumberController.text,
  //         'role': isLessor.value?"owner":"customer",
  //         'password_confirmation':passwordConfirmController.text,
  //         'city':selectedCity.string,
  //         'raegion':selectedRegion.string
  //       });
  //       request.files.add(await http.MultipartFile.fromPath('personle_image', personalImageController.value!.path));
  //       request.files.add(await http.MultipartFile.fromPath('identity_image', idImageController.value!.path));
  //       request.headers.addAll({
  //         'Accept':'application/json',
  //       });
  //
  //       var streamResponse=await request.send();
  //       var response=await http.Response.fromStream(streamResponse);
  //       if(response.statusCode==200||response.statusCode == 201){
  //         isLoading.value=false;
  //         var responseData=jsonDecode(response.body);
  //         // if(responseData['token']!=null){
  //         //   await settingService.sharedPreferences.setString('token',responseData['token']);
  //         // }
  //         print("User Created :${responseData['user']['first_name']}");
  //         Get.offAll(()=> LogIn());
  //         Get.snackbar(
  //             "Success",
  //             "Account created successfully. Please wait for admin approval and Log in to your account.",
  //             backgroundColor: Colors.green.withOpacity(0.7),
  //             colorText: Colors.white
  //         );
  //       }
  //       else{
  //         isLoading.value=false;
  //
  //         var errorData=jsonDecode(response.body);
  //
  //         Get.snackbar("Registeration Failed", errorData['message']??"Please check your information and try again. ",backgroundColor: Colors.redAccent,colorText: Colors.white,duration: const Duration(seconds: 5));
  //
  //         print("Error Details: ${response.body}");
  //       }
  //
  //     }catch(e){
  //       isLoading.value=false;
  //       Get.snackbar("Error", "Check your server connection: $e");
  //       print("Catch Error: $e");
  //     }
  //   }}

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    schoolNameController.dispose();
    locationController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.onClose();
  }
}