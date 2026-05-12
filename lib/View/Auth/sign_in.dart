import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/Custom/MyCustomLoadingButton.dart';
import 'package:school_management/Controller/AuthController/sign_in_controller.dart';
import 'package:school_management/View/Auth/sign_up_first_page.dart';
import 'package:school_management/core/AppConstants.dart';

import '../../Custom/MyCustomButton.dart';
import '../../Custom/MyCustomTextFields.dart';

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
              color: const Color(0xFFF0F1F2),
              borderRadius: BorderRadius.circular(20),
            ),
            width: size.width>900?900:size.width*0.95,
            constraints: BoxConstraints(
              minHeight: size.width > 800 ? 700 : 0,
              maxHeight: size.width > 800 ? size.height * 0.85 : double.infinity,
            ),
            child: Form(
              key: _signInController.formKey,
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
          const CircleAvatar(
            radius: 40.0,
            backgroundColor: Color(0xFFE0F2F1),
            backgroundImage: AssetImage(AppConstants.logoPath),
          ),
          const SizedBox(height: 10,),
          //Text of login
          SizedBox(
            width: 65,
            height: 29,
            child: const FittedBox(
              fit: BoxFit.contain,
              child: Text("Login",style: TextStyle(
                color: Color(0xFF1C3486),
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
          //Text bottom of login
          SizedBox(
            width: 333,
            height: 28,
            child: const FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Start managing your School perfect today",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF64748B)),),
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
              controller: _signInController.emailController,
                hintText: "Enter your Email ",
                prefixIcon: Icon(Icons.email_outlined, color: MyColors.iconInAuthTextFieldColor),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Please Enter your Email";
                  if(GetUtils.isEmail(value!)){
                    return null;
                  }
                  return "your Email should be as 'example@gmail.com'";
                },
              ),
            ],
          ),
          const SizedBox(height: 20,),
          //Password TextField
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Password",style: TextStyle(color: MyColors.labelUpOfTextFieldInLoginPageColor),),
              const SizedBox(height: 8,),
              MyCustomTextField(
                textInputAction: TextInputAction.done,
                controller: _signInController.passwordController,
                hintText: "Enter your Password ",
                isPassword: false,
                prefixIcon: Icon(Icons.lock_outline, color: MyColors.iconInAuthTextFieldColor),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Please Enter your Password";
                  if (value.length < AppConstants.minPasswordLength) {
                    return 'Password must be at least $AppConstants.minPasswordLength characters long';
                  }
                  return null;
                },
              ),
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
                child: Text("Forgot Password?", style: TextStyle(color: Color(0xFF00A991), decoration: TextDecoration.underline,decorationColor: MyColors.hintTextInTextFieldInSignUp)),
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
        },title: "Login",backgroundColorLeft: Color(0xFF1D3587),backgroundColorRight: Color(0xFF006879),foregroundColor: Color(0xFFFFFFFF)),
          ),
          const SizedBox(height: 20),
          //To go to Register Page
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already haven't account?", style: TextStyle(color: Color(0xFF64748B))),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>sign_up_first_page()));
                },
                child: Text("Register", style: TextStyle(color: Color(0xFF007F6D), decoration: TextDecoration.underline,decorationColor: Color(0xFF007F6D))),
              ),
            ],
          ),

        ],
      ),
    );
  }

}

