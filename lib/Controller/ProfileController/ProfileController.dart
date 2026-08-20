import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/Model/Profile/ProfileModel.dart';
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Services/SettingsService.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';

class ProfileController extends GetxController{
var isLoading=false.obs;

var profileModel=Rxn<Profilemodel>();

SettingService settingService=Get.find();

  @override
  void onInit() {
  super.onInit();
  getUserData();
  }

  Future<void> getUserData() async {
    try{
      isLoading.value=true;

      String? token=settingService.sharedPreferences.getString("token");

      var response=await http.get(
        Uri.parse(AppConstants.linkProfile),
        headers: AppConstants.headers(token!),
      );

      if(response.statusCode==200){

        var responseBody=jsonDecode(response.body);
        profileModel.value=Profilemodel.fromJson(responseBody);
      }
        else{
        var errorData=jsonDecode(response.body);
        SnackbarHelper.showError(title: "Error", message: errorData.toString());
      }

    }catch(e){
      SnackbarHelper.showError(title: "Error", message: "Could not fetch user data: $e");
    }finally{
      isLoading.value=false;
    }
  }
}