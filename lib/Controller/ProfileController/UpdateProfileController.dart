import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:school_management/core/AppConstants.dart';

class UpdateProfileController extends GetxController{
  final formKey=GlobalKey<FormState>();
late TextEditingController fullNameController;
late TextEditingController emailController;
late TextEditingController phoneController;
late TextEditingController locationController;

@override
  void onInit() {
    fullNameController=TextEditingController();
    emailController=TextEditingController();
    phoneController=TextEditingController();
    locationController=TextEditingController();
    super.onInit();
  }

  void updateUserInformation() async {
  if(formKey.currentState!.validate()){
  }
  }


  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.onClose();
  }

}