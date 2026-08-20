import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/Model/HomeModel/UserModel.dart';
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import '../../../Model/HomeModel/InvoiceModel.dart';
import '../../../core/Services/SettingsService.dart';

class Dashboardcontroller extends GetxController{
  var isLoading=false.obs;
  RxList<UserModel> users=<UserModel>[].obs;
  RxList<UserModel> allUsers = <UserModel>[].obs;
  late TextEditingController searchEditingController;
  var numOfStudents = 0.obs;
  var numOfTeachers = 0.obs;
  var numOfSupervisor = 0.obs;
  var numOfClasses = 0.obs;

  var currentUsersPage=1.obs;
  var totalUsersPages=1.obs;
  final SettingService settingService=Get.find();


  @override
  void onInit() {
    searchEditingController=TextEditingController();
    Future.wait([
    fetchUsers(),
    getCountOfTeachers(),
    getCountOfStudents(),
    getCountOfSupervisors(),
    getCountOfClasses(),
    ]);
    super.onInit();
  }



  Future<void> fetchUsers({int page=1}) async {
    try{
      isLoading.value=true;
      currentUsersPage.value=page;
      String? token=settingService.sharedPreferences.getString("token");
      var url=Uri.parse("${AppConstants.linkGetAllUsers}?page=$page");
        var response = await http.get(
          url,
          headers: AppConstants.headers(token!),
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode==200) {
          var responseData=jsonDecode(response.body);
          List fetchedList=responseData['data']??[];
          List<UserModel> mappedUsers = fetchedList
              .map((item) => UserModel.fromJson(item))
              .toList();
          allUsers.assignAll(mappedUsers);
          users.assignAll(mappedUsers);
          if(responseData['meta']!=null){
            totalUsersPages.value=responseData['meta']['last_page']??1;
          }
        }else{
          SnackbarHelper.showError(title: "Error", message: "Server returned: ${response.statusCode}");
        }
    }catch(e){
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch data: $e");
    }finally{
      isLoading.value=false;
    }
  }

  void searchByName(String query){
    if(query.isEmpty){
      users.assignAll(allUsers);
    }
    else{
      users.assignAll(
          allUsers.where((invoice) =>
              invoice.full_name.toLowerCase().contains(query.toLowerCase())
          ).toList());
    }
  }


  Future<void> toggleAcceptStatus(UserModel user) async {
    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.put(
          Uri.parse("${AppConstants.linkApproveUser(user.id)}"),
          headers: AppConstants.headers(token!));
      if (response.statusCode != 200) {
        user.status = user.status == 1 ? 1 : 1;
        users.refresh();
        SnackbarHelper.showSuccess(title: "Success", message: "User approved successfully");
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to toggle status: $e");
    }
  }

  Future<void> getCountOfTeachers() async {
    try {
      isLoading.value=true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
          Uri.parse("${AppConstants.linkGetCountOfTeachers}"),
          headers: AppConstants.headers(token!));
      if (response.statusCode == 200) {
        var responseBody=jsonDecode(response.body);
        numOfTeachers.value=responseBody['teachers'] ?? 0;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch Count of Teachers: $e");
    }finally{
      isLoading.value=false;
    }
  }
  Future<void> getCountOfStudents() async {
    try {
      isLoading.value=true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
          Uri.parse("${AppConstants.linkGetCountOfStudents}"),
          headers: AppConstants.headers(token!));
      if (response.statusCode == 200) {
        var responseBody=jsonDecode(response.body);
        numOfStudents.value=responseBody['students'] ?? 0;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch Count of Students: $e");
    }finally{
      isLoading.value=false;
    }
  }
  Future<void> getCountOfSupervisors() async {
    try {
      isLoading.value=true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
          Uri.parse("${AppConstants.linkGetCountOfSupervisors}"),
          headers: AppConstants.headers(token!));
      if (response.statusCode == 200) {
        var responseBody=jsonDecode(response.body);
        numOfSupervisor.value=responseBody['supervisors'] ?? 0;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch Count of Supervisors: $e");
    }finally{
      isLoading.value=false;
    }
  }

  Future<void> getCountOfClasses() async {
    try {
      isLoading.value=true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
          Uri.parse("${AppConstants.linkGetCountOfClasses}"),
          headers: AppConstants.headers(token!));
      if (response.statusCode == 200) {
        var responseBody=jsonDecode(response.body);
        numOfClasses.value=responseBody['study_stages'] ?? 0;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch Count of Classes: $e");
    }finally{
      isLoading.value=false;
    }
  }

  @override
  void onClose() {
    searchEditingController.dispose();
    super.onClose();
  }
}