import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Services/SettingsService.dart';
import 'package:school_management/core/Utils/ErrorHandler.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import '../../../Model/HomeModel/SupervisorModel/SupervisorModel.dart';

import '../../../core/Utils/MockData.dart';

class SupervisorsManagementController extends GetxController{
  var isLoading=true.obs;
  RxList<SupervisorModel> supervisors=<SupervisorModel>[].obs;
  RxList<SupervisorModel> allSupervisors = <SupervisorModel>[].obs;
  late TextEditingController searchEditingController;
  RxBool isShowingPending = false.obs;
  final SettingService settingService=Get.find();
  late var numOfSupervisors=supervisors.length.obs;

  var currentSupervisorsPage=1.obs;
  var totalSupervisorsPages=1.obs;


  @override
  void onInit() {
    searchEditingController=TextEditingController();
    fetchSupervisors();
    super.onInit();
  }



  Future<void> fetchSupervisors({int page=1,bool onlyPending=false}) async {
    if (settingService.isGuestMode.value) {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));
      supervisors.assignAll(MockData.mockSupervisors);
      allSupervisors.assignAll(MockData.mockSupervisors);
      totalSupervisorsPages.value = 1;
      isLoading.value = false;
      return;
    }
    
    try{
      isLoading.value=true;
      currentSupervisorsPage.value=page;
      isShowingPending.value = onlyPending;
      String? token = settingService.sharedPreferences.getString("token");
      String url = onlyPending
          ? AppConstants.linkGetNotApprovedSupervisors
          : AppConstants.linkGetAllSupervisors;
      var getUsersUrl=Uri.parse("$url?page=$page");

      var response = await http.get(
          getUsersUrl,
          headers: AppConstants.headers(token!)).timeout(const Duration(seconds: 10));

      if (response.statusCode==200) {
        var responseData=jsonDecode(response.body);
        List fetchedList=responseData['data']??[];

        List<SupervisorModel> mappedUsers = fetchedList
            .map((item) => SupervisorModel.fromJson(item))
            .toList();

        allSupervisors.assignAll(mappedUsers);
        supervisors.assignAll(mappedUsers);
        if(responseData['meta']!=null){
          totalSupervisorsPages.value=responseData['meta']['last_page']??1;
        }
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch supervisors: $e");
      ErrorHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  void searchByName(String query){
    if(query.isEmpty){
      supervisors.assignAll(allSupervisors);
    }
    else{
      supervisors.assignAll(
          allSupervisors.where((supervisor) =>
              supervisor.full_name.toLowerCase().contains(query.toLowerCase())
          ).toList()
      );
    }
  }


  Future<void> toggleAcceptStatus(SupervisorModel supervisor) async {
    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.put(
          Uri.parse("${AppConstants.linkApproveUser(supervisor.id)}"),
      headers: AppConstants.headers(token!));
      if (response.statusCode == 200) {
        supervisor.status = supervisor.status == 1 ? 1 : 1;
        supervisors.refresh();
        SnackbarHelper.showSuccess(title: "Success", message: "Supervisor approved successfully");
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  @override
  void onClose() {
    searchEditingController.dispose();
    super.onClose();
  }

}