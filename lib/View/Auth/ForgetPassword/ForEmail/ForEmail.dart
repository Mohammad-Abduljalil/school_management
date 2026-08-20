import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Controller/AuthController/ForgetPasswordController.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/Custom/MyCustomLoadingButton.dart';
import 'package:school_management/core/AppConstants.dart';
import '../../../../Custom/MyCustomButton.dart';
import '../../../../Custom/MyCustomTextFields.dart';

class ForEmail extends StatefulWidget{
  const ForEmail({super.key});
  @override
  State<ForEmail> createState() => _ForEmailState();
}

class _ForEmailState extends State<ForEmail>{
  final ForgetPasswordController _forgetPasswordController=Get.put(ForgetPasswordController(),permanent:true);
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
                    key: _forgetPasswordController.formKey,
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
          //Text of "Forget Your Password?"
          SizedBox(
            width: 448,
            height: 40,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text("Forget Your Password?",style: TextStyle(
                color: MyColors.primaryText,
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
          //Text bottom of "Forget Your Password?"
          SizedBox(
            width: 321,
            height: 40,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Enter your email address to receive the verification code",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: MyColors.labelUpOfTextFieldInLoginPageColor),),
            ),
          ),
          const SizedBox(height: 30,),
          //Email TextField
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email",style: TextStyle(color: MyColors.labelUpOfTextFieldInLoginPageColor),),
              const SizedBox(height: 8,),
              MyCustomTextField(
                controller: _forgetPasswordController.emailVerificationController,
                hintText: "Enter your Email ",
                prefixIcon: Icon(Icons.email_outlined, color: MyColors.iconInAuthTextFieldColor),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Please Enter your Email";
                  if(GetUtils.isEmail(value)){
                    return null;
                  }
                  return "your Email should be as 'example@gmail.com'";
                },
              ),
            ],
          ),
          const SizedBox(height: 20,),
          //Login Button
          Obx(
                ()=> _forgetPasswordController.isLoading.value ? MyCustomLoadingButton(onPressed: (){},backgroundColorLeft: Color(0xFF1D3587),backgroundColorRight: Color(0xFF006879),foregroundColor: Color(0xFFFFFFFF))
                :
            MyCustomButton(onPressed: (){
              _forgetPasswordController.SendCode();
            },title: "Send Code",backgroundColorLeft: Color(0xFF1D3587),backgroundColorRight: Color(0xFF006879),foregroundColor: Color(0xFFFFFFFF)),
          ),
          const SizedBox(height: 20),
          //To go to Register Page
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Remember password?", style: TextStyle(color: MyColors.labelUpOfTextFieldInLoginPageColor)),
              TextButton(
                onPressed: () {
                Get.offAllNamed('/SignUpFirstPage');
                },
                child: Text("Sign In", style: TextStyle(color: Color(0xFF007F6D), decoration: TextDecoration.underline,decorationColor: Color(0xFF007F6D))),
              ),
            ],
          ),

        ],
      ),
    );
  }

}

