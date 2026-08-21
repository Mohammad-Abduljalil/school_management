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
import '../../../Model/HomeModel/InvoiceItemModel.dart';
import '../../../Model/HomeModel/StudentModel/StudentModel.dart';
import '../../../core/Services/SettingsService.dart';

import '../../../core/Utils/MockData.dart';

class StudentsManagementController extends GetxController{
  var isLoading=true.obs;
  RxList<StudentModel> students=<StudentModel>[].obs;
  RxList<StudentModel> allStudents = <StudentModel>[].obs;
  late TextEditingController searchEditingController;
  late var numOfStudents=students.length.obs;
  RxBool isShowingPending = false.obs;
  final SettingService settingService=Get.find();

  var currentStudentsPage=1.obs;
  var totalStudentsPages=1.obs;


  @override
  void onInit() {
    searchEditingController=TextEditingController();
    fetchStudents();
    super.onInit();
  }



  Future<void> fetchStudents({int page=1,bool onlyPending=false}) async {
    if (settingService.isGuestMode.value) {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));
      students.assignAll(MockData.mockStudents);
      allStudents.assignAll(MockData.mockStudents);
      totalStudentsPages.value = 1;
      isLoading.value = false;
      return;
    }
    
    try{
      isLoading.value=true;
      currentStudentsPage.value=page;
      isShowingPending.value = onlyPending;
      String? token = settingService.sharedPreferences.getString("token");
      String url = onlyPending
          ? AppConstants.linkGetNotApprovedStudents
          : AppConstants.linkGetAllStudents;
      var getUsersUrl=Uri.parse("$url?page=$page");

      var response = await http.get(
          getUsersUrl,
          headers: AppConstants.headers(token!)).timeout(const Duration(seconds: 10));
      if (response.statusCode==200) {
        var responseData=jsonDecode(response.body);
        List fetchedList=responseData['data']??[];
        List<StudentModel> mappedStudents = fetchedList
            .map((item) => StudentModel.fromJson(item))
            .toList();

        allStudents.assignAll(mappedStudents);
        students.assignAll(mappedStudents);
        if(responseData['meta']!=null){
          totalStudentsPages.value=responseData['meta']['last_page']??1;
        }
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch students: $e");
      ErrorHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  void searchByName(String query){
    if(query.isEmpty){
      students.assignAll(allStudents);
    }
    else{
      students.assignAll(
          allStudents.where((student) =>
              student.full_name.toLowerCase().contains(query.toLowerCase())
          ).toList()
      );
    }
  }




  Future<void> toggleAcceptStatus(StudentModel student) async {
    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.put(
          Uri.parse("${AppConstants.linkApproveUser(student.id)}"),
          headers: AppConstants.headers(token!));
      if (response.statusCode == 200) {
        student.status = student.status == 1 ? 1 : 1;
        students.refresh();
        SnackbarHelper.showSuccess(title: "Success", message: "Student approved successfully");
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Toggle status error: $e");
      ErrorHandler.handleException(e);
    }
  }

  Rxn<StudentModel> selectedStudentDetails = Rxn<StudentModel>();
  RxList<InvoiceItemModel> studentInvoiceItems = <InvoiceItemModel>[].obs;
  RxBool isLoadingDetails = false.obs;

  Future<void> getStudentDetails(StudentModel student) async {
    try {
      isLoadingDetails.value = true;
      studentInvoiceItems.clear();
      String? token = settingService.sharedPreferences.getString("token");
      // Use the student's invoices link to get financial details
      var response = await http.get(
          Uri.parse(AppConstants.linkGetInvoicesById(student.student_id)),
      headers: AppConstants.headers(token!));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        // Handle data structure (could be a list of invoices or a single invoice)
        dynamic data = responseData['data'] ?? responseData;
        if (data != null) {
           List invoiceList = [];
           if (data is List) {
             invoiceList = data;
           } else if (data is Map) {
             // Response might be a single invoice or an object containing an array
             if (data.containsKey('invoices')) {
                invoiceList = data['invoices'];
             } else {
                invoiceList = [data];
             }
           }

           if (invoiceList.isNotEmpty) {
             // Take the first invoice for the student
             var firstInvoice = invoiceList[0];
             
             // Try to read items directly from the invoice
             var items = firstInvoice['invoice_items'] ?? firstInvoice['items'];
             if (items != null && items is List) {
                studentInvoiceItems.assignAll(items.map((e) => InvoiceItemModel.fromJson(e)).toList());
             } else if (firstInvoice['id'] != null) {
                // If items not found but invoice ID exists, fetch them explicitly
                await _fetchInvoiceItemsExplicitly(firstInvoice['id']);
             }
           }
        }
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Error getting student financial details: $e");
      ErrorHandler.handleException(e);
    } finally {
      isLoadingDetails.value = false;
    }
  }

  Future<void> _fetchInvoiceItemsExplicitly(int invoiceId) async {
     try {
      String? token = settingService.sharedPreferences.getString("token");
      var url = Uri.parse(AppConstants.linkGetInvoiceItems(invoiceId));
      var response = await http.get(url, headers: AppConstants.headers(token!));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        dynamic rawItems = responseData['data'] ?? responseData['invoice_items'];
        List fetchedList = (rawItems is List) ? rawItems : [];
        studentInvoiceItems.assignAll(fetchedList.map((e) => InvoiceItemModel.fromJson(e)).toList());
      }
    } catch (e) {
       SnackbarHelper.showError(title: "Error", message: "Error fetching invoice items explicitly: $e");
    }
  }

  @override
  void onClose() {
    searchEditingController.dispose();
    super.onClose();
  }

}