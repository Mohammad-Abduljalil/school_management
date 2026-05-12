import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/View/Auth/ForgetPassword/ForEmail.dart';
import 'package:school_management/View/Auth/sign_up_first_page.dart';
import 'package:school_management/View/Home/admin_home_screen.dart';
import 'package:school_management/core/Services/SettingsService.dart';
import 'View/Auth/ForgetPassword/ForCodeVerification.dart';
import 'View/Auth/ForgetPassword/NewPassword.dart';
import 'View/Auth/sign_in.dart';
import 'View/Auth/sign_up_second_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingService.initServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SettingService settingService=Get.find();
    bool isLoggedIn=settingService.sharedPreferences.getBool("isLoggedIn") ?? false;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Managing',
      home: isLoggedIn ? const AdminHomeScreen():const sign_in(),
      getPages: [
        GetPage(name: '/signIn', page: ()=>  sign_in()),
        GetPage(name: '/SignUpFirstPage', page: ()=>  sign_up_first_page()),
        GetPage(name: '/SignUpSecondPage', page: ()=> sign_up_second_page()),
        GetPage(name: '/AdminHomeScreen', page:()=> const AdminHomeScreen()),
        GetPage(name: '/ForEmail', page:()=> const ForEmail()),
        GetPage(name: '/ForCodeVerification', page:()=> const ForCodeVerification()),
        GetPage(name: '/NewPasswordPage', page:()=> const NewPassword()),
      ],
    );
  }
}

