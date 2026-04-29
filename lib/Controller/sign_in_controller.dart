import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignInController extends GetxController{
  final formKey=GlobalKey<FormState>();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  var isPasswordObsecured=true.obs;
  var passwordText="".obs;
  var isLoading=false.obs;


    void SignIn(){
      if(formKey.currentState!.validate()){
        isLoading.value=true;
        Future.delayed(Duration(seconds: 5));
        isLoading.value=false;
      }
    }

    //after link
    // void login() async {
  //   if (formKey.currentState!.validate()) {
  //     isLoading.value = true;
  //     var response=await forApi().postRequest(
  //         AppLinks.linkLogIn,
  //         {
  //           'phone':phoneNumberController.text,
  //           'password':passwordController.text,
  //         }
  //     );
  //     var responseBody=jsonDecode(response.body);
  //     if(response.statusCode==200){
  //       var responseBody=jsonDecode(response.body);
  //       String token=responseBody['access_token'];
  //
  //       await settingService.sharedPreferences.setString('token', token);
  //       Get.snackbar(
  //         "Success",
  //         "Your login is being validated",
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.brown.withOpacity(0.7),
  //         colorText: Colors.white,
  //       );
  //       bool isLessee=responseBody['user']['role'] == 'owner' ? false : true;
  //       if(isLessee){
  //         Get.offAll(()=> AppNavigationView());
  //       }
  //       else{
  //         // Get.offAll(()=>HomeLandlordView());
  //       }
  //     }
  //     else if (response.statusCode == 403) {
  //
  //       bool isLessee=responseBody['user']['role'] == 'owner' ? false : true;
  //
  //       Get.offAll(() => WaitingApprovalPage(isLessee: isLessee));
  //       Get.snackbar(
  //         'Waiting',
  //         "Data is correct, but your account is pending approval.",
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.brown.withOpacity(0.7),
  //         colorText: Colors.white,
  //       );
  //
  //     }
  //     else if(response.statusCode==401){
  //       Get.snackbar('Error', "Invalid phone number or password",snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.brown.withOpacity(0.7),
  //         colorText: Colors.white,);
  //     }
  //     else{
  //       Get.snackbar('Error', "Something went wrong",snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.brown.withOpacity(0.7),
  //         colorText: Colors.white,);
  //     }
  //
  //     isLoading.value = false;
  //   }
  // }

@override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
      super.onClose();
  }
}