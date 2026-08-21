import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Custom/MyThemes.dart';
import 'package:school_management/View/Auth/ForgetPassword/ForEmail/ForEmail.dart';
import 'package:school_management/View/Auth/SignUp/sign_up_first_page.dart';
import 'package:school_management/View/Home/HomeScreen.dart';
import 'package:school_management/core/Services/SettingsService.dart';
import 'View/Auth/ForgetPassword/ForCodeVerification/ForCodeVerification.dart';
import 'View/Auth/ForgetPassword/ForNewPassword/NewPassword.dart';
import 'View/Auth/SignIn/sign_in.dart';
import 'View/Auth/SignUp/sign_up_second_page.dart';

import 'package:school_management/core/Utils/MyTranslations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingService.initServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    SettingService settingService = Get.find();
    bool isLoggedIn = settingService.sharedPreferences.getBool("isLoggedIn") ?? false;

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'School Managing',
        translations: MyTranslations(),
        locale: settingService.currentLocale.value,
        fallbackLocale: const Locale('en'),
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        themeMode: settingService.isDark.value ? ThemeMode.dark : ThemeMode.light,
        home: isLoggedIn ? const AdminHomeScreen() : const sign_in(),
        getPages: [
          GetPage(name: '/signIn', page: () => sign_in()),
          GetPage(name: '/SignUpFirstPage', page: () => sign_up_first_page()),
          GetPage(name: '/SignUpSecondPage', page: () => sign_up_second_page()),
          GetPage(name: '/AdminHomeScreen', page: () => const AdminHomeScreen()),
          GetPage(name: '/ForEmail', page: () => const ForEmail()),
          GetPage(name: '/ForCodeVerification', page: () => const ForCodeVerification()),
          GetPage(name: '/NewPasswordPage', page: () => const NewPassword()),
        ],
      );
    });
  }
}

