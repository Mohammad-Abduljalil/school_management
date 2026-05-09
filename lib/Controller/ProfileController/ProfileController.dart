import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/Model/Profile/UserModel.dart';
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Services/SettingsService.dart';

class ProfileController extends GetxController{
var isLoading=true.obs;

var userModel=Rxn<UserModel>();

SettingService settingService=Get.find();

@override
  void onInit() {
  super.onInit();
  getUserData();
  }

  Future<void> getUserData() async {
    try{
      isLoading.value=true;
      // String? token=settingService.sharedPreferences.getString("token");
      //
      // var response=await http.get(
      //   Uri.parse(AppConstants.linkProfile),
      //   headers: {
      //           'Authorization': 'Bearer $token',
      //               'Accept': 'application/json',
      //         },
      // );
      //
      // if(response.statusCode==200){
      //   var respnseBody=jsonDecode(response.body);
      //   userModel.value=UserModel.fromJson(respnseBody);
      // }else{
      //   var errorData=jsonDecode(response.body);
      //   Get.snackbar("Server Error", errorData);
      // }
      await Future.delayed(const Duration(seconds: 1));
      var responseBody = {
        "id": 1,
        "full_name": "Mohammad Abduljalil",
        "email": "mohammad@example.com",
        "phone_number": "0123456789",
        "location": "Damascus, Syria",
        "personal_image": "images/personalImage/personal.png"
      };
      // ------------------------------------------
      userModel.value = UserModel.fromJson(responseBody);

    }catch(e){
      Get.snackbar("Error", "Could not fetch user data: $e");
    }finally{
      isLoading.value=false;
    }
  }
}