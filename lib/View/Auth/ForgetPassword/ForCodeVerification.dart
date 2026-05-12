import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:school_management/Controller/AuthController/ForgetPasswordController.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/Custom/MyCustomLoadingButton.dart';
import 'package:school_management/Controller/AuthController/sign_in_controller.dart';
import 'package:school_management/View/Auth/sign_up_first_page.dart';
import 'package:school_management/core/AppConstants.dart';

import '../../../Custom/MyCustomButton.dart';
import '../../../Custom/MyCustomTextFields.dart';

class ForCodeVerification extends StatefulWidget{
  const ForCodeVerification({super.key});

  @override
  State<ForCodeVerification> createState() => _ForCodeVerificationState();
}

class _ForCodeVerificationState extends State<ForCodeVerification>{
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
                    color: const Color(0xFFF0F1F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: size.width>900?900:size.width*0.95,
                  constraints: BoxConstraints(
                    minHeight: size.width > 800 ? 700 : 0,
                    maxHeight: size.width > 800 ? size.height * 0.85 : double.infinity,
                  ),
                  child: Form(
                    key: _forgetPasswordController.formKeyForCodeVerification,
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
      color: const Color(0xFFF0F1F2),
      padding: const EdgeInsets.all(20),
      child: Image.asset("images/Auth/ImageForForgetPassword.png",fit: BoxFit.contain,),
    );
  }

  Widget _buildFormSection(){

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color(0xFF1C3486),
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

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
            child: const FittedBox(
              fit: BoxFit.contain,
              child: Text("Email Verification",style: TextStyle(
                color: Color(0xFF1C3486),
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
          //Text bottom of "Email Verification"
          SizedBox(
            width: 321,
            height: 40,
            child: const FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Enter the 6-digit code sent to your email address",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF64748B)),),
            ),
          ),
          const SizedBox(height: 30,),
          // --- حقل الـ OTP الجديد ---
          Pinput(
            length: 6, // عدد الخانات
            controller: _forgetPasswordController.codeVerificationController, // تأكد من تعريفه في الـ Controller
            defaultPinTheme: defaultPinTheme,
            // التفاعل عند التركيز على الخانة
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: const Color(0xFF1C3486), width: 2),
              ),
            ),
            // التفاعل عند إتمام الإدخال
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                color: const Color(0xFFF3F4F6),
              ),
            ),
            onCompleted: (pin) {
              print("Completed Pin: $pin");
              // يمكنك استدعاء دالة التحقق هنا تلقائياً
            },
          ),

          const SizedBox(height: 20,),
          //Login Button
          Obx(
                ()=> _forgetPasswordController.isLoading.value ? MyCustomLoadingButton(onPressed: (){},backgroundColorLeft: Color(0xFF1D3587),backgroundColorRight: Color(0xFF006879),foregroundColor: Color(0xFFFFFFFF))
                :
            MyCustomButton(onPressed: (){
              _forgetPasswordController.VerifyCode();
            },title: "Verify Code",backgroundColorLeft: Color(0xFF1D3587),backgroundColorRight: Color(0xFF006879),foregroundColor: Color(0xFFFFFFFF)),
          ),
          const SizedBox(height: 20),
          //To go to Register Page
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Didn't receive code? ", style: TextStyle(color: Color(0xFF64748B))),
              TextButton(
                onPressed: () {
                  _forgetPasswordController.resendCode();
                  },
                child: Text("Resend", style: TextStyle(color: Color(0xFF007F6D), decoration: TextDecoration.underline,decorationColor: Color(0xFF007F6D))),
              ),
            ],
          ),

        ],
      ),
    );
  }

}

