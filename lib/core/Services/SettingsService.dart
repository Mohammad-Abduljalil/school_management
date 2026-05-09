import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingService extends GetxService{
  late SharedPreferences sharedPreferences;

  Future<SettingService> init()async {
    sharedPreferences=await SharedPreferences.getInstance();
    return this;
  }
  static Future<void> initServices() async {
    await Get.putAsync(() => SettingService().init());
  }

}