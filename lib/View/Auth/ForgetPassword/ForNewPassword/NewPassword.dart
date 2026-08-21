import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Controller/AuthController/ForgetPasswordController.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/Custom/MyCustomLoadingButton.dart';
import 'package:school_management/core/AppConstants.dart';
import '../../../../Custom/MyCustomButton.dart';
import '../../../../Custom/MyCustomTextFields.dart';


class NewPassword extends StatefulWidget{
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword>{

  final ForgetPasswordController _forgetPasswordController=Get.find<ForgetPasswordController>();
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: MyColors.backgroundColor,
        body:SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(20),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: size.width>900?900:size.width*0.95,
                  constraints: BoxConstraints(
                    minHeight: size.width > 800 ? AppConstants.minHeightForWindowsApplications : 0,
                    maxHeight: size.width > 800 ? size.height * 0.85 : double.infinity,
                  ),
                  child: Form(
                    key: _forgetPasswordController.formKeyForNewPassword,
                    child: LayoutBuilder(builder: (context,constraints){
                      if (constraints.maxWidth>650){
                        return Row(
                          children: [
                            Expanded(
                                child: _buildImageSection()
                            ),
                            Expanded(
                                child: _buildFormSection()
                            ),
                          ],
                        );
                      }else{
                        return  Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 250, child: _buildImageSection()),
                            _buildFormSection(),
                          ],
                        );
                      }

                    },
                    ),
                  ),
                ),
              ),
            )));
  }
  Widget _buildImageSection(){
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(20),
      child: Image.asset("images/Auth/ImageForForgetPassword.png",fit: BoxFit.contain,),
    );
  }

  Widget _buildFormSection(){

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SingleChildScrollView(
        child: Column(

          mainAxisSize: MainAxisSize.min,
          children: [
            //image of school
            const CircleAvatar(
              radius: 40.0,
              backgroundColor: Color(0xFFE0F2F1),
              backgroundImage: AssetImage(AppConstants.logoPath),
            ),
            const SizedBox(height: 10,),
            //Text of login
            SizedBox(
              width: 144,
              height: 24,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text("Set New Password".tr,style: TextStyle(
                  color: MyColors.primaryText,
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ),
            //Text bottom of "Sent a new password"
            SizedBox(
              width: 333,
              height: 28,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "Choose a strong password for your account".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyColors.labelUpOfTextFieldInLoginPageColor),),
              ),
            ),
            const SizedBox(height: 30,),
            //Email TextField
            _buildFieldLabel("New Password".tr),
            //Password TextField
            Obx(
                  ()=> MyCustomTextField(
                controller: _forgetPasswordController.passwordController,
                hintText: "Enter Password".tr,
                isPassword: true,
                prefixIcon: Icon(Icons.lock_outline, color: MyColors.iconInAuthTextFieldColor),
                obscureText: _forgetPasswordController.isPasswordObsecured.value,
                onSuffixIconPressed: ()=>_forgetPasswordController.isPasswordObsecured.toggle(),
                onChanged: (value){
                  _forgetPasswordController.passwordText.value=value;
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
            Obx(()=> Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 25),
                  child: Text(
                    _forgetPasswordController.passwordText.value.isEmpty
                        ? ""
                        : _forgetPasswordController.passwordText.value.length < 8
                        ? "Weak password".tr
                        : "Strong password".tr,
                    style: TextStyle(
                      color: _forgetPasswordController.passwordText.value.length < 8 ? Colors.red : Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            )),
            const SizedBox(height: 20),
            _buildFieldLabel("Confirm the New Password".tr),
            //Confirm Password TextField
            Obx(()=>MyCustomTextField(
              controller: _forgetPasswordController.passwordConfirmController,
              hintText: "Confirm Password".tr,
              isPassword: true,
              textInputAction: TextInputAction.done,
              prefixIcon: Icon(Icons.lock_reset, color: MyColors.iconInAuthTextFieldColor),
              onSuffixIconPressed: ()=>_forgetPasswordController.isPasswordConfirmObsecured.toggle(),
              onChanged: (value){
                _forgetPasswordController.passwordConfirmText.value=value;
              },
              validator: (value){
                if(value==null ||value.isEmpty){
                  return "Please Enter your Password".tr;
                }
                if (value.length < AppConstants.minPasswordLength) {
                  return 'Password must be at least ${AppConstants.minPasswordLength} characters long'.tr;
                }
                if(value!=(_forgetPasswordController.passwordController.text)){
                  return "Passwords do not match!".tr;
                }
                return null;
              },
              obscureText: _forgetPasswordController.isPasswordConfirmObsecured.value,
            ),),
            const SizedBox(height: 30),
            const SizedBox(height: 10,),
            //Login Button
            Obx(
                  ()=> _forgetPasswordController.isLoading.value ? MyCustomLoadingButton(onPressed: (){_forgetPasswordController.resetPassword();},backgroundColorLeft: Color(0xFF1D3587),backgroundColorRight: Color(0xFF006879),foregroundColor: Color(0xFFFFFFFF))
                  :
              MyCustomButton(onPressed: (){
                _forgetPasswordController.resetPassword();
              },title: "Reset Password".tr,backgroundColorLeft: Color(0xFF1D3587),backgroundColorRight: Color(0xFF006879),foregroundColor: Color(0xFFFFFFFF)),
            ),
            const SizedBox(height: 20),
            //To go to Register Page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Do remember the password?".tr, style: TextStyle(color: MyColors.labelUpOfTextFieldInLoginPageColor)),
              TextButton(
                  onPressed: () {
                        Get.offAllNamed('/SignIn');
                  },
                  child: Text("SignIn".tr, style: TextStyle(color: Color(0xFF007F6D), decoration: TextDecoration.underline,decorationColor: Color(0xFF007F6D))),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(label, style: TextStyle(color: MyColors.labelUpOfTextFieldInLoginPageColor, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

}

