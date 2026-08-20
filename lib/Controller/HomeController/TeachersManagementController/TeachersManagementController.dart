import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/Model/HomeModel/UserModel.dart';
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Services/SettingsService.dart';
import 'package:school_management/core/Utils/ErrorHandler.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import '../../../Model/HomeModel/InvoiceModel.dart';
import '../../../Model/HomeModel/TacherModel/TeacherModel.dart';

class TeachersManagementController extends GetxController{
  var isLoading=true.obs;
  RxList<TeacherModel> teachers=<TeacherModel>[].obs;
  RxList<TeacherModel> allTeachers = <TeacherModel>[].obs;
  late TextEditingController searchEditingController;
  RxBool isShowingPending = false.obs;

  late var numOfTeachers=teachers.length.obs;

  var currentTeachersPage=1.obs;
  var totalTeachersPages=1.obs;
  final SettingService settingService=Get.find();

  @override
  void onInit() {
    searchEditingController=TextEditingController();
    fetchTeachers();
    super.onInit();
  }



  Future<void> fetchTeachers({int page=1,bool onlyPending=false}) async {
    try{
      isLoading.value=true;
      currentTeachersPage.value=page;
      isShowingPending.value = onlyPending;
      String? token = settingService.sharedPreferences.getString("token");
      String url = onlyPending
          ? AppConstants.linkGetNotApprovedUsers
          : AppConstants.linkGetAllTeachers;
      var getUsersUrl=Uri.parse("$url?page=$page");
      var response = await http.get(
          getUsersUrl,
          headers: AppConstants.headers(token!)).timeout(const Duration(seconds: 10));
      if (response.statusCode==200) {
        var responseData=jsonDecode(response.body);
        List fetchedList=responseData['data']??[];
        List<TeacherModel> mappedTeachers = fetchedList
            .map((item) => TeacherModel.fromJson(item))
            .toList();
        allTeachers.assignAll(mappedTeachers);
        teachers.assignAll(mappedTeachers);
        if(responseData['meta']!=null){
          totalTeachersPages.value=responseData['meta']['last_page']??1;
        }
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch teachers: $e");
      ErrorHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  void searchByName(String query){
    if(query.isEmpty){
      teachers.assignAll(allTeachers);
    }
    else{
      teachers.assignAll(
          allTeachers.where((teacher) =>
              teacher.full_name.toLowerCase().contains(query.toLowerCase())
          ).toList()
      );
    }
  }


  Future<void> toggleAcceptStatus(TeacherModel teacher) async {
    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.put(
    Uri.parse("${AppConstants.linkApproveUser(teacher.id)}"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      if (response.statusCode == 200) {
        teacher.status = teacher.status == 1 ? 0 : 1;
        teachers.refresh();
        SnackbarHelper.showSuccess(title: "Success", message: "Teacher approved successfully");
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Toggle status error: $e");
      ErrorHandler.handleException(e);
    }
  }

  Future<void> getTeacherDetails(TeacherModel teacher) async {
    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
          Uri.parse("${AppConstants.linkGetTeacherDetails(teacher.id)}"),
          headers: AppConstants.headers(token!));
      if (response.statusCode == 200) {
         } else {
        ErrorHandler.handleHttpError(response);
      }

    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Error getting teacher details: $e");
      ErrorHandler.handleException(e);
    }
  }

  @override
  void onClose() {
    searchEditingController.dispose();
    super.onClose();
  }
}