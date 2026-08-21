import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/Model/HomeModel/UserModel.dart';
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Utils/ErrorHandler.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import '../../../Model/HomeModel/InvoiceModel.dart';
import '../../../View/Home/User/UserDataSource.dart';
import '../../../core/Services/SettingsService.dart';

import '../../../core/Utils/MockData.dart';

class UserManagementController extends GetxController{
  var isLoading=true.obs;
  RxList<UserModel> users=<UserModel>[].obs;
  RxList<UserModel> allUsers = <UserModel>[].obs;
  late TextEditingController searchEditingController;
  var numOfStudents = 0.obs;
  var numOfTeachers = 0.obs;
  var numOfSupervisor = 0.obs;
  RxBool isShowingPending = false.obs;

  var currentUsersPage=1.obs;
  var totalUsersPages=1.obs;
  final SettingService settingService=Get.find();

  @override
  void onInit() {
    searchEditingController=TextEditingController();
    fetchInitialData();
    super.onInit();
  }

  void fetchInitialData() async {
    if (settingService.isGuestMode.value) {
      users.assignAll(MockData.mockUsers);
      allUsers.assignAll(MockData.mockUsers);
      numOfStudents.value = 500;
      numOfTeachers.value = 45;
      numOfSupervisor.value = 12;
      totalUsersPages.value = 1;
      isLoading.value = false;
      return;
    }
    
    fetchUsers();
    getCountOfTeachers();
    getCountOfStudents();
  }



  Future<void> fetchUsers({int page=1,bool onlyPending=false}) async {
    if (settingService.isGuestMode.value) return;
    try{
      isLoading.value=true;
      currentUsersPage.value=page;
      isShowingPending.value = onlyPending; // Update current state
      String? token = settingService.sharedPreferences.getString("token");
      String url = onlyPending
          ? AppConstants.linkGetNotApprovedUsers
          : AppConstants.linkGetAllUsers;
      var getUsersUrl=Uri.parse("$url?page=$page");
        var response = await http.get(
          getUsersUrl,
          headers: AppConstants.headers(token!)).timeout(const Duration(seconds: 10));
        if (response.statusCode==200) {
          var responseData=jsonDecode(response.body);
          List fetchedList=responseData['data']??[];
          List<UserModel> mappedUsers = fetchedList
              .map<UserModel>((item) => UserModel.fromJson(item))
              .toList();

          allUsers.assignAll(mappedUsers);
          users.assignAll(mappedUsers);
          if(responseData['meta']!=null){
            totalUsersPages.value=responseData['meta']['last_page']??1;
          }
        } else {
          ErrorHandler.handleHttpError(response);
        }
    }catch(e){
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch users: $e");
      ErrorHandler.handleException(e);
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
          ).toList()
      );
    }
  }


  Future<void> toggleAcceptStatus(UserModel user) async {
    try {

      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.put(
          Uri.parse("${AppConstants.linkApproveUser(user.id)}"),
      headers: AppConstants.headers(token!));

      if (response.statusCode == 200) {
        user.status = user.status == 1 ? 1 : 1;
        users.refresh();
        SnackbarHelper.showSuccess(title: "Success", message: "Approved successfully");
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Toggle status error: $e");
      ErrorHandler.handleException(e);
    }
  }
  Future<void> getCountOfTeachers() async {
    try {
      isLoading.value=true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
          Uri.parse("${AppConstants.linkGetCountOfTeachers}"),
          headers: AppConstants.headers(token!));
      var responseBody=jsonDecode(response.body);
      numOfTeachers.value=responseBody['teachers'];

      if (response.statusCode == 200) {
        var responseBody=jsonDecode(response.body);
        numOfTeachers.value=responseBody['teachers'];
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Toggle status error: $e");
      ErrorHandler.handleException(e);
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
      var responseBody=jsonDecode(response.body);
      numOfStudents.value=responseBody['students'];

      if (response.statusCode == 200) {
        var responseBody=jsonDecode(response.body);
        numOfStudents.value=responseBody['students'];
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Toggle status error: $e");
      ErrorHandler.handleException(e);
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