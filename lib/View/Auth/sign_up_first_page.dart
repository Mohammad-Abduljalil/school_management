import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_management/Constants/MyColors.dart';
import 'package:school_management/Controller/sign_up_controller.dart';
import 'package:school_management/View/Auth/sign_in.dart';
import 'package:school_management/View/Auth/sign_up_second_page.dart';

import '../../Constants/MyCustomButton.dart';
import '../../Constants/MyCustomTextFields.dart';

class sign_up_first_page extends StatefulWidget{

  @override
  State<sign_up_first_page> createState() => _sign_up_first_pageState();
}

class _sign_up_first_pageState extends State<sign_up_first_page>{
  final SignUpController _signUpController=Get.put(SignUpController());
  @override
  Widget build(BuildContext context) {

    final size=MediaQuery.of(context).size;

    return Scaffold(
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
                  height: size.width > 800 ? (size.height > 750 ? size.height * 0.85 : 700) : null,
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
            )));
  }
  //should edit
  Widget _buildImageSection(){
    return Container(
      color: const Color(0xFFF0F1F2),
      padding: const EdgeInsets.all(20),
      child: Image.asset("images/Auth/imageInSignUp.png",fit: BoxFit.contain,),
    );
  }

  Widget _buildFormSection(){

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: _signUpController.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //image of school
            const CircleAvatar(
              radius: 40.0,
              backgroundColor: Color(0xFFE0F2F1),
              backgroundImage: AssetImage("images/SchoolManagementIcon.png"),
            ),
            const SizedBox(height: 10,),
            //Text of Create Account
            SizedBox(
              width: 185,
              height: 29,
              child: const FittedBox(
                fit: BoxFit.contain,
                child: Text("Create Account",style: TextStyle(
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
            //Full Name TextField
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Full Name",style: TextStyle(color: MyColors.labelUpOfTextFieldInLoginPageColor),),
                const SizedBox(height: 8,),
                MyCustomTextField(
                  controller: _signUpController.fullNameController,
                  hintText: "Enter your Full Name ",
                  prefixIcon: Icon(Icons.person_outline, color: MyColors.iconInTextFieldColor),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please Enter your Full Name";
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 20,),
            //Email Address TextField
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email Address",style: TextStyle(color: MyColors.labelUpOfTextFieldInLoginPageColor),),
                const SizedBox(height: 8,),
                MyCustomTextField(
                  controller: _signUpController.emailController,
                  hintText: "example@gmail.com",
                  prefixIcon: Icon(Icons.email_outlined, color: MyColors.iconInTextFieldColor),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please Enter your Email";
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 20,),
            //Phone Number TextField
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Phone Number",style: TextStyle(color: MyColors.labelUpOfTextFieldInLoginPageColor),),
                const SizedBox(height: 8,),
                MyCustomTextField(
                  textInputAction: TextInputAction.done,
                  controller: _signUpController.phoneNumberController,
                  hintText: "09 **** ****",
                  prefixIcon: Icon(Icons.phone_outlined, color: MyColors.iconInTextFieldColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please Enter your Phone Number";
                    return null;
                  },
                ),
              ],
            ),
            SizedBox(height: 30,),
            //Next to second Signup page Button
            MyCustomButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> sign_up_second_page()));
            },title: "Next",backgroundColorLeft: Color(0xFF1D3587),backgroundColorRight: Color(0xFF006879),foregroundColor: Color(0xFFFFFFFF)),
            const SizedBox(height: 20),
            //To go to Login Page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have account?", style: TextStyle(color: Color(0xFF64748B))),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>sign_in()));
                  },
                  child: Text("Log In", style: TextStyle(color: Color(0xFF007F6D), decoration: TextDecoration.underline,decorationColor: Color(0xFF007F6D))),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

}

