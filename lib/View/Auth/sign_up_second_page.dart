import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/Controller/AuthController/sign_up_controller.dart';
import 'package:school_management/core/AppConstants.dart';

import '../../Custom/MyCustomButton.dart';
import '../../Custom/MyCustomLoadingButton.dart';
import '../../Custom/MyCustomTextFields.dart';

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
                color: const Color(0xFFF0F1F2),
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
                          Expanded(child: _buildImageSection()),
                          Expanded(child: _buildFormSection(context)),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 250, child: _buildImageSection()),
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

  Widget _buildImageSection() {
    return Container(
      color: const Color(0xFFF0F1F2),
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
          const Text(
            "Add These Photos",
            style: TextStyle(
                color: Color(0xFF1C3486),
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          const SizedBox(height: 20),
          //personal and id photo
          Center(
            child: _buildImagePickerBox("Personal Photo", context),
          ),
          const SizedBox(height: 30),
          _buildFieldLabel("Location"),
          //location TextField
          MyCustomTextField(
            controller: _signUpController.locationController,
            hintText: "Enter your Location",
            prefixIcon: Icon(Icons.location_on_outlined, color: MyColors.iconInAuthTextFieldColor),
            validator: (value){
              if(value==null ||value.isEmpty){
                return "Please Enter your Location";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildFieldLabel("Password"),
          //Password TextField
          Obx(
            ()=> MyCustomTextField(
              controller: _signUpController.passwordController,
              hintText: "Enter Password",
              isPassword: true,
              prefixIcon: Icon(Icons.lock_outline, color: MyColors.iconInAuthTextFieldColor),
              obscureText: _signUpController.isPasswordObsecured.value,
              onSuffixIconPressed: ()=>_signUpController.isPasswordObsecured.toggle(),
              onChanged: (value){
                _signUpController.passwordText.value=value;
              },
              validator: (value){
                if(value==null ||value.isEmpty){
                  return "Please Enter your Password";
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
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
                  ? "Weak password"
                  : "Strong password",
              style: TextStyle(
                color: _signUpController.passwordText.value.length < 8 ? Colors.red : Colors.green,
                fontSize: 12,
              ),
            ),
          )),          const SizedBox(height: 20),
          _buildFieldLabel("Confirm Password"),
          //Confirm Password TextField
          Obx(()=>MyCustomTextField(
            controller: _signUpController.passwordConfirmController,
            hintText: "Confirm Password",
            isPassword: true,
            textInputAction: TextInputAction.done,
            prefixIcon: Icon(Icons.lock_reset, color: MyColors.iconInAuthTextFieldColor),
            onSuffixIconPressed: ()=>_signUpController.isPasswordConfirmObsecured.toggle(),
            onChanged: (value){
              _signUpController.passwordConfirmText.value=value;
            },
            validator: (value){
              if(value==null ||value.isEmpty){
                return "Please Enter your Password";
              }
              if (value.length < AppConstants.minPasswordLength) {
                return 'Password must be at least ${AppConstants.minPasswordLength} characters long';
              }
              if(value!=(_signUpController.passwordController.text)){
                return "Passwords do not match!";
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
            title: "Finish",
            backgroundColorLeft: const Color(0xFF1D3587),
            backgroundColorRight: const Color(0xFF006879),
            foregroundColor: Colors.white,
          ),
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
                color: Colors.white,
                child: imagePath == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt_outlined, color: Colors.grey),
                    Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    const Text("Upload", style: TextStyle(fontSize: 10, color: Colors.grey)),
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
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                _signUpController.pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
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