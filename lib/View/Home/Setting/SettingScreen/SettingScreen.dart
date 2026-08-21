import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controller/ProfileController/ProfileController.dart';
import '../../../../Controller/ProfileController/UpdateProfileController.dart';
import '../../../../Custom/MyColors.dart';
import '../../../../Custom/MyCustomTextFields.dart';
import '../../../../Custom/MyImageHelper.dart';
import '../../../../core/AppConstants.dart';
import '../../../../core/Services/SettingsService.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final ProfileController _profileController = Get.find<ProfileController>();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MyColors.pageContentColor,
      body: SafeArea(
        child: Obx(() {
          var MyInfo = _profileController.profileModel.value;

          if (_profileController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Header
                _headerSection(),
                const SizedBox(height: 30),
                //Info Section
                LayoutBuilder(builder: (context, constraints) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Left Section
                      Expanded(flex: 4, child: _leftDetailsSection(MyInfo)),
                      const SizedBox(width: 20),
                      //Right Section
                      Expanded(flex: 4, child: _rightDetailsSection(MyInfo)),
                    ],
                  );
                }),
                const SizedBox(height: 30),
                //Setting Section
                _accountSettingsSection(),
              ],
            ),
          );
        }),
      ),
    );
  }

  //Header Of Screen
  Widget _headerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My Profile".tr,
          style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.primaryText, fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          "manage your profile and your appearance here".tr,
          style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  Widget _leftDetailsSection(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Header
        Text("Personal Details".tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        // Info
        Container(
          height: 320,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF003366), Color(0xFF006677)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //The Image
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  MyImageHelper.buildCircleAvatar(
                    path: user?.profile_image,
                    radius: 55,
                  ),
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFF00D1FF),
                    child: Icon(Icons.check, size: 15, color: Colors.black),
                  )
                ],
              ),
              const SizedBox(height: 15),
              // Name
              Text(
                user?.full_name ?? "User Name",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 5),
              //Principle
              Text("Principle".tr, style: const TextStyle(fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 15),
              //The Role
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("Admin".tr, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _rightDetailsSection(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Header
        Text("Personal Details".tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        //Info
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              //Email
              _infoTile(Icons.email_outlined, "Email Address".tr, user?.email ?? "example@gmail.com"),
              //Phone Number
              _infoTile(Icons.phone_outlined, "Phone Number".tr,user?.phone ?? "09** *** ***"),
              //Location
              _infoTile(Icons.location_on_outlined, "Location".tr, user?.location ?? "Not Set".tr),
              const SizedBox(height: 20),
              //Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D3587),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: () {_showUpdateProfileDialog(user);},
                  child: Text("Update".tr, style: const TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              SizedBox(height: 43,)
            ],
          ),
        ),
      ],
    );
  }


  //For InfoTile
  Widget _infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Get.isDarkMode ? Colors.white10 : const Color(0xFFF0F7F8), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFF006879)),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: MyColors.primaryText)),
            ],
          )
        ],
      ),
    );
  }

  Widget _accountSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Account Settings".tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Obx(() {
                final settingService = Get.find<SettingService>();
                bool isArabic = settingService.currentLocale.value.languageCode == 'ar';
                return _settingsTile(
                  Icons.language,
                  "Language".tr,
                  isArabic ? "اللغة العربية" : "English Language",
                  trailing: IconButton(
                    onPressed: () {
                      settingService.changeLanguage(isArabic ? 'en' : 'ar');
                    },
                    icon: const Icon(Icons.swap_horiz),
                  ),
                );
              }),
              const Divider(height: 1),
              Obx(() {
                final settingService = Get.find<SettingService>();
                return _settingsTile(
                  Icons.dark_mode_outlined,
                  "Theme".tr,
                  "Light or Dark environment".tr,
                  trailing: Switch(
                    value: settingService.isDark.value,
                    onChanged: (v) => settingService.switchTheme(),
                    activeColor: const Color(0xFF00A991),
                  ),
                );
              }),
              const Divider(height: 1),
              _settingsTile(Icons.notifications_none, "Notification Settings".tr, "Manage alerts and messages".tr, trailing: Switch(value: true, onChanged: (v) {})),
            ],
          ),
        ),
      ],
    );
  }

  //For SettingTile
  Widget _settingsTile(IconData icon, String title, String subtitle, {required Widget trailing}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Get.isDarkMode ? Colors.white10 : const Color(0xFFF0F1F2), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: const Color(0xFF1D3587)),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: MyColors.primaryText)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      trailing: trailing,
    );
  }

  //Update Profile Dialog
  void _showUpdateProfileDialog(user) {
    final UpdateProfileController _updateProfileController = Get.put(UpdateProfileController());

    _updateProfileController.fullNameController.text = user?.full_name ?? "";
    _updateProfileController.emailController.text = user?.email ?? "";
    _updateProfileController.phoneController.text = user?.phone ?? "";
    _updateProfileController.locationController.text = user?.location ?? "";

     AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C3486),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.person_outline, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Update personal information".tr,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: MyColors.primaryText),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(backgroundColor: Get.isDarkMode ? Colors.white10 : const Color(0xFFF0F1F2)),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _updateProfileController.formKey,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF1C3486), width: 2),
                        ),
                        child: MyImageHelper.buildCircleAvatar(
                          path: user?.profile_image,
                          radius: 60,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                            padding: const EdgeInsets.all(0),
                          decoration: const BoxDecoration(color: Color(0xFF08314F), shape: BoxShape.circle),
                          child: IconButton(onPressed: (){}, icon: const Icon(Icons.edit, size: 14, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "UPDATE YOUR PHOTO".tr,
                    style: const TextStyle(fontSize: 12, color: Colors.grey, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: _labelWithTextField(
                          "Full name".tr,
                          _updateProfileController.fullNameController.text,
                          Icons.person_outline,
                          TextInputType.text,
                          _updateProfileController.fullNameController,
                            (value){
                            if( value=="" || value.isEmpty){
                              return "Please Enter Your Full Name".tr;
                            }
                            },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _labelWithTextField(
                          "Email".tr,
                          _updateProfileController.emailController.text,
                          Icons.email_outlined,
                          TextInputType.emailAddress,
                          _updateProfileController.emailController,
                          (value) {
                            if (value == null || value.isEmpty) return "Please Enter your Email".tr;
                            if(GetUtils.isEmail(value!)){
                              return null;
                            }
                            return "your Email should be as 'example@gmail.com'".tr;
                            },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _labelWithTextField(
                          "Phone".tr,
                          _updateProfileController.phoneController.text,
                          Icons.phone_outlined,
                          TextInputType.phone,
                          _updateProfileController.phoneController,
                             (value) {
                            if (value == null || value.isEmpty) return "Please Enter your Phone Number".tr;
                            else if (value.length != AppConstants.phoneLength) return "Phone number must be ${AppConstants.phoneLength} digits".tr;
                            return null;
                            },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _labelWithTextField(
                          "Location".tr,
                          _updateProfileController.locationController.text,
                          Icons.location_on_outlined,
                          TextInputType.text,
                          _updateProfileController.locationController,
                            (value){
                              if(value==null ||value.isEmpty){
                                return "Please Enter your Location".tr;
                              }
                              return null;
                            },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C3486),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                      },
                      child: Text("Update".tr, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )..show();
  }

  //For Label With TextField
  Widget _labelWithTextField(label,hintText,icon,textInputType,controller,validator){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,style: TextStyle(color: const Color(0xFF545455)),),
        const SizedBox(height: 8,),
        MyCustomTextField(
          controller: controller,
          hintText: hintText,
          prefixIcon: Icon(icon, color:const Color(0xFF9CA3AF)),
          keyboardType: textInputType,
          validator: validator,
        ),
      ],
    );
  }
}

