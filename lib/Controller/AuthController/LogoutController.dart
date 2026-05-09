import 'package:get/get.dart';
import 'package:school_management/core/Services/SettingsService.dart';

class LogoutController extends GetxController{
  void logout() {
    SettingService settingService=Get.find();
    settingService.sharedPreferences.remove("token");
    settingService.sharedPreferences.setBool("isLoggedIn", false);

    Get.offAllNamed("/signIn");
  }
}