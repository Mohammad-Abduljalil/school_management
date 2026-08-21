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

import '../../../core/Utils/MockData.dart';

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
    if (settingService.isGuestMode.value) {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));
      teachers.assignAll(MockData.mockTeachers);
      allTeachers.assignAll(MockData.mockTeachers);
      totalTeachersPages.value = 1;
      isLoading.value = false;
      return;
    }
    
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
    if (settingService.isGuestMode.value) {
      teacher.status = teacher.status == 1 ? 0 : 1;
      teachers.refresh();
      SnackbarHelper.showSuccess(title: "Success", message: "Status toggled (Guest Mode)");
      return;
    }

    try {
      // If we are approving a pending teacher
      if (teacher.status == 0) {
        final salary = await _showSalaryDialog(teacher.full_name);
        if (salary == null) return; // User cancelled

        String? token = settingService.sharedPreferences.getString("token");
        
        // 1. Approve User
        var approveResponse = await http.put(
          Uri.parse("${AppConstants.linkApproveUser(teacher.id)}"),
          headers: AppConstants.headers(token!)
        );

        if (approveResponse.statusCode == 200) {
          // 2. Assign Salary
          var salaryResponse = await http.put(
            Uri.parse(AppConstants.linkAssignSalary(teacher.teacher_id)),
            headers: AppConstants.headers(token),
            body: jsonEncode({
              'salary': salary,
              'type': 'teacher',
            }),
          );

          if (salaryResponse.statusCode == 200) {
            teacher.status = 1;
            teachers.refresh();
            SnackbarHelper.showSuccess(title: "Success", message: "Teacher approved and salary assigned successfully");
          } else {
            SnackbarHelper.showWarning(title: "Partial Success", message: "Teacher approved, but failed to assign salary");
            teacher.status = 1;
            teachers.refresh();
          }
        } else {
          ErrorHandler.handleHttpError(approveResponse);
        }
      } else {
        // Just toggle back to pending if already active (standard behavior)
        String? token = settingService.sharedPreferences.getString("token");
        var response = await http.put(
            Uri.parse("${AppConstants.linkApproveUser(teacher.id)}"),
            headers: AppConstants.headers(token!));
        if (response.statusCode == 200) {
          teacher.status = 0;
          teachers.refresh();
          SnackbarHelper.showSuccess(title: "Success", message: "Teacher set to pending successfully");
        } else {
          ErrorHandler.handleHttpError(response);
        }
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Toggle status error: $e");
      ErrorHandler.handleException(e);
    }
  }

  Future<int?> _showSalaryDialog(String name) async {
    final TextEditingController salaryController = TextEditingController();
    int? result;
    
    await Get.defaultDialog(
      title: "Assign Salary",
      middleText: "Enter the monthly salary for $name",
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: salaryController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Salary",
            hintText: "e.g. 1500",
            border: OutlineInputBorder(),
          ),
        ),
      ),
      textConfirm: "Confirm",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF1C3486),
      onConfirm: () {
        result = int.tryParse(salaryController.text);
        if (result != null && result! >= 0) {
          Get.back();
        } else {
          SnackbarHelper.showWarning(title: "Warning", message: "Please enter a valid salary");
        }
      },
    );
    return result;
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