import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/Custom/MyCustomLoadingButton.dart';
import 'package:school_management/Controller/AuthController/sign_in_controller.dart';
import 'package:school_management/View/Auth/SignUp/sign_up_first_page.dart';
import 'package:school_management/core/AppConstants.dart';

import '../../../Custom/MyCustomButton.dart';
import '../../../Custom/MyCustomTextFields.dart';

class sign_in extends StatefulWidget{
  const sign_in({super.key});

  @override
  State<sign_in> createState() => _sign_inState();
}

class _sign_inState extends State<sign_in>{
  final SignInController _signInController=Get.put(SignInController(),permanent: false);

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
              minHeight: size.width > 800 ? (size.height*0.7).clamp(0, 700) : 0,
              maxHeight: size.width > 800 ? size.height * 0.85 : double.infinity,
            ),
            child: Form(
              key: _signInController.formKey,
              child: LayoutBuilder(builder: (context,constraints){
                if (constraints.maxWidth>650){
                  return Row(
                    children: [
                      Expanded(
                          child: _buildImageSection(context)
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
                      SizedBox(height: 250, child: _buildImageSection(context)),
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

  Widget _buildImageSection(BuildContext context){
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(20),
      child: Image.asset("images/Auth/imageInSignIn.png",fit: BoxFit.contain,),
    );
  }

  Widget _buildFormSection(){

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //image of school
          CircleAvatar(
            radius: 40.0,
            backgroundColor: Theme.of(context).dividerColor,
            backgroundImage: const AssetImage(AppConstants.logoPath),
          ),
          const SizedBox(height: 10,),
          //Text of login
          SizedBox(
            width: 65,
            height: 29,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text("Login".tr,style: TextStyle(
                color: MyColors.primaryText,
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
          //Text bottom of login
          SizedBox(
            width: 333,
            height: 28,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Start managing your School perfect today".tr,
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
              Text("Email".tr,style: TextStyle(color: MyColors.labelUpOfTextFieldInLoginPageColor),),
              const SizedBox(height: 8,),
              MyCustomTextField(
              controller: _signInController.emailController,
                hintText: "Enter your Email ".tr,
                prefixIcon: Icon(Icons.email_outlined, color: MyColors.iconInAuthTextFieldColor),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Please Enter your Email".tr;
                  if(GetUtils.isEmail(value)){
                    return null;
                  }
                  return "your Email should be as 'example@gmail.com'".tr;
                },
              ),
            ],
          ),
          const SizedBox(height: 20,),
          //Password TextField
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Password".tr,style: TextStyle(color: MyColors.labelUpOfTextFieldInLoginPageColor),),
              const SizedBox(height: 8,),
              Obx(
                    ()=> MyCustomTextField(
                  controller: _signInController.passwordController,
                  hintText: "Enter Password".tr,
                  isPassword: true,
                  prefixIcon: Icon(Icons.lock_outline, color: MyColors.iconInAuthTextFieldColor),
                  obscureText: _signInController.isPasswordObsecured.value,
                  onSuffixIconPressed: ()=>_signInController.isPasswordObsecured.toggle(),
                  onChanged: (value){
                    _signInController.passwordText.value=value;
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
                  _signInController.passwordText.value.isEmpty
                      ? ""
                      : _signInController.passwordText.value.length < 8
                      ? "Weak password".tr
                      : "Strong password".tr,
                  style: TextStyle(
                    color: _signInController.passwordText.value.length < 8 ? Colors.red : Colors.green,
                    fontSize: 12,
                  ),
                ),
              )),
            ],
          ),
          const SizedBox(height: 10,),
          //Forget Password
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Get.toNamed("/ForEmail");
                },
                child: Text("Forgot Password?".tr, style: TextStyle(color: Color(0xFF00A991), decoration: TextDecoration.underline,decorationColor: MyColors.hintTextInTextFieldInSignUp)),
              ),
            ],
          ),
          SizedBox(height: 30,),
          //Login Button
          Obx(
              ()=> _signInController.isLoading.value ? MyCustomLoadingButton(onPressed: (){},backgroundColorLeft: Color(0xFF1D3587),backgroundColorRight: Color(0xFF006879),foregroundColor: Color(0xFFFFFFFF))
            :
        MyCustomButton(onPressed: (){
          _signInController.SignIn();
        },title: "Login".tr,backgroundColorLeft: Color(0xFF1D3587),backgroundColorRight: Color(0xFF006879),foregroundColor: Color(0xFFFFFFFF)),
          ),
          const SizedBox(height: 20),
          //To go to Register Page
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already haven't account?".tr, style: TextStyle(color: MyColors.labelUpOfTextFieldInLoginPageColor)),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>sign_up_first_page()));
                },
                child: Text("Register".tr, style: TextStyle(color: Color(0xFF007F6D), decoration: TextDecoration.underline,decorationColor: Color(0xFF007F6D))),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Guest Login Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _signInController.guestSignIn(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF00A991)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              child: Text(
                "Try as Guest".tr,
                style: const TextStyle(color: Color(0xFF00A991), fontWeight: FontWeight.bold),
              ),
            ),
          ),

        ],
      ),
    );
  }

}

