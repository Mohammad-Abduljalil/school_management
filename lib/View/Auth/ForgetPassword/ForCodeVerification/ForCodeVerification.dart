import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:school_management/Controller/AuthController/ForgetPasswordController.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/Custom/MyCustomLoadingButton.dart';
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import '../../../../Custom/MyCustomButton.dart';

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
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: size.width>900?900:size.width*0.95,
                  constraints: BoxConstraints(
                    minHeight: size.width > 800 ? AppConstants.minHeightForWindowsApplications : 0,
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
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(20),
      child: Image.asset("images/Auth/ImageForForgetPassword.png",fit: BoxFit.contain,),
    );
  }

  Widget _buildFormSection(){

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        color: MyColors.primaryText,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MyColors.borderColor),
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
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text("Email Verification",style: TextStyle(
                color: MyColors.primaryText,
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
          //Text bottom of "Email Verification"
          SizedBox(
            width: 321,
            height: 40,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Enter the 6-digit code sent to your email address",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: MyColors.labelUpOfTextFieldInLoginPageColor),),
            ),
          ),
          const SizedBox(height: 30,),
          // --- New OTP field ---
          Pinput(
            length: 6, // Number of digits
            controller: _forgetPasswordController.codeVerificationController, // Ensure it's defined in the Controller
            defaultPinTheme: defaultPinTheme,
            // Interaction when the field is focused
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: MyColors.borderColor, width: 2),
              ),
            ),
            // Interaction when entry is complete
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                color: MyColors.pageContentColor,
              ),
            ),
            onCompleted: (pin) {
           SnackbarHelper.showSuccess(title: "Success", message: "Completed Pin: $pin");
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
              Text("Didn't receive code? ", style: TextStyle(color: MyColors.labelUpOfTextFieldInLoginPageColor)),
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

