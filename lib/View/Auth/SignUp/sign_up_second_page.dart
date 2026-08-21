import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/Controller/AuthController/sign_up_controller.dart';
import 'package:school_management/core/AppConstants.dart';
import '../../../Custom/MyCustomButton.dart';
import '../../../Custom/MyCustomLoadingButton.dart';
import '../../../Custom/MyCustomTextFields.dart';

class sign_up_second_page extends StatelessWidget {
  final SignUpController _signUpController = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 800;
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              width: size.width > 900 ? 900 : size.width * 0.95,
              height: isMobile ? null : (size.height > 750 ? size.height * 0.9 : 750),
              child: Form(
                key: _signUpController.formKeySecond,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (!isMobile) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _buildImageSection(context)),
                          Expanded(child: _buildFormSection(context)),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 250, child: _buildImageSection(context)),
                          _buildFormSection(context),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(20),
      child: Image.asset("images/Auth/imageInSignUp.png", fit: BoxFit.contain),
    );
  }

  Widget _buildFormSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add This Photo".tr,
            style: TextStyle(
                color: MyColors.primaryText,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          const SizedBox(height: 20),
          //personal and id photo
          Center(
            child: _buildImagePickerBox("Personal Photo".tr, context),
          ),
          const SizedBox(height: 30),
          _buildFieldLabel("Location".tr),
          //location TextField
          MyCustomTextField(
            controller: _signUpController.locationController,
            hintText: "Enter your Location".tr,
            prefixIcon: Icon(Icons.location_on_outlined, color: MyColors.iconInAuthTextFieldColor),
            validator: (value){
              if(value==null ||value.isEmpty){
                return "Please Enter your Location".tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildFieldLabel("Password".tr),
          //Password TextField
          Obx(
            ()=> MyCustomTextField(
              controller: _signUpController.passwordController,
              textInputAction: TextInputAction.next,
              hintText: "Enter Password".tr,
              isPassword: true,
              prefixIcon: Icon(Icons.lock_outline, color: MyColors.iconInAuthTextFieldColor),
              obscureText: _signUpController.isPasswordObsecured.value,
              onSuffixIconPressed: ()=>_signUpController.isPasswordObsecured.toggle(),
              onChanged: (value){
                _signUpController.passwordText.value=value;
              },
              validator: (value){
                if(value==null ||value.isEmpty){
                  return "Please Enter your Password".tr;
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long'.tr;
                }
                return null;
              },
            ),
          ),
          //to check password
          Obx(()=> Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 25),
            child: Text(
              _signUpController.passwordText.value.isEmpty
                  ? ""
                  : _signUpController.passwordText.value.length < 8
                  ? "Weak password".tr
                  : "Strong password".tr,
              style: TextStyle(
                color: _signUpController.passwordText.value.length < 8 ? Colors.red : Colors.green,
                fontSize: 12,
              ),
            ),
          )),
          const SizedBox(height: 20),
          _buildFieldLabel("Confirm Password".tr),
          //Confirm Password TextField
          Obx(()=>MyCustomTextField(
            controller: _signUpController.passwordConfirmController,
            hintText: "Confirm Password".tr,
            isPassword: true,
            textInputAction: TextInputAction.done,
            prefixIcon: Icon(Icons.lock_reset, color: MyColors.iconInAuthTextFieldColor),
            onSuffixIconPressed: ()=>_signUpController.isPasswordConfirmObsecured.toggle(),
            onChanged: (value){
              _signUpController.passwordConfirmText.value=value;
            },
            validator: (value){
              if(value==null ||value.isEmpty){
                return "Please Enter your Password".tr;
              }
              if (value.length < AppConstants.minPasswordLength) {
                return 'Password must be at least ${AppConstants.minPasswordLength} characters long'.tr;
              }
              if(value!=(_signUpController.passwordController.text)){
                return "Passwords do not match!".tr;
              }
              return null;
            },
            obscureText: _signUpController.isPasswordConfirmObsecured.value,
          ),),
          const SizedBox(height: 30),
          //finish Button
          Obx( ()=> _signUpController.isLoading.value ? MyCustomLoadingButton(onPressed: (){},backgroundColorLeft: Color(0xFF1D3587),backgroundColorRight: Color(0xFF006879),foregroundColor: Color(0xFFFFFFFF))
              :
          MyCustomButton(
            onPressed: () {
              _signUpController.SignUp();
            },
            title: "Finish".tr,
            backgroundColorLeft: const Color(0xFF1D3587),
            backgroundColorRight: const Color(0xFF006879),
            foregroundColor: Colors.white,
          ),
          ),
          const SizedBox(height: 30),
          //To back to first SignUp Page
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Back to First Page?".tr, style: TextStyle(color: MyColors.labelUpOfTextFieldInLoginPageColor)),
              TextButton(
                onPressed: () {
                      Get.offAllNamed('SignUpFirstPage');
                },
                child: Text("Sign Up".tr, style: TextStyle(color: Color(0xFF007F6D), decoration: TextDecoration.underline,decorationColor: Color(0xFF007F6D))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerBox(String label, BuildContext context) {
    return Obx(() {
      dynamic imagePath =_signUpController.personalImageController.value;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: () => _showImageSourceDialog(context),
            child: DottedBorder(
              options: RectDottedBorderOptions(
                dashPattern: [4, 3],
                strokeWidth: 1,
                color: Colors.grey,
                // padding: EdgeInsets.all(16),
              ),
              child: Container(
                width: 110,
                height: 110,
                color: Theme.of(context).cardColor,
                child: imagePath == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt_outlined, color: Colors.grey),
                    Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    Text("Upload".tr, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb
                      ? Image.network(imagePath.path, fit: BoxFit.cover, width: 110, height: 110)
                      : Image.file(File(imagePath.path), fit: BoxFit.cover, width: 110, height: 110),
                ),
              ),
            ),
          ),
          if (imagePath != null)
            Positioned(
              top: -5,
              right: -5,
              child: GestureDetector(
                onTap: (){
                    _signUpController.personalImageController.value = null;
                    },
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
        ],
      );
    });
  }

  void _showImageSourceDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: MyColors.backgroundColor),
              title: Text('Gallery'.tr, style: TextStyle(color: MyColors.primaryText)),
              onTap: () {
                _signUpController.pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_camera, color: MyColors.backgroundColor),
              title: Text('Camera'.tr, style: TextStyle(color: MyColors.primaryText)),
              onTap: () {
                _signUpController.pickImage(ImageSource.camera);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: TextStyle(color: MyColors.labelUpOfTextFieldInLoginPageColor, fontWeight: FontWeight.w500)),
    );
  }
}