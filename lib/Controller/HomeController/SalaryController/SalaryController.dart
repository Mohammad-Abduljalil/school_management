import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/Model/HomeModel/SalaryModel.dart';
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Services/SettingsService.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';

class SalaryController extends GetxController {
  var isLoading = true.obs;
  var searchQuery = "".obs;
  RxList<SalaryModel> displayedUsers = <SalaryModel>[].obs;
  RxList<SalaryModel> allUsers = <SalaryModel>[].obs;

  var selectedRole = "teacher".obs;

  late TextEditingController searchEditingController;

  var currentSalaryPage = 1.obs;
  var totalSalaryPages = 1.obs;
  var totalSalaryItems = 0.obs;
  final int rowsPerPage = 10;

  SettingService settingService = Get.find();

  @override
  void onInit() {
    searchEditingController = TextEditingController();
    fetchSalaries(page: 1);
    super.onInit();
  }

  Future<void> fetchSalaries({int page = 1}) async {
    try {
      isLoading.value = true;
      currentSalaryPage.value = page;
      String? token = settingService.sharedPreferences.getString("token");
      var url = Uri.parse("${AppConstants.linkGetSalaryByRole(selectedRole.value)}?page=$page");
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var data = responseData['data'];

        List<SalaryModel> mappedSalaries = [];

        if (data is List) {
          mappedSalaries = data.map<SalaryModel>((item) => SalaryModel.fromJson(item)).toList();
        } else if (data is Map) {
          mappedSalaries = [SalaryModel.fromJson(data as Map<String, dynamic>)];
        }

        displayedUsers.assignAll(mappedSalaries);
        allUsers.assignAll(mappedSalaries);

        if (responseData['meta'] != null) {
          totalSalaryPages.value = responseData['meta']['last_page'] ?? 1;
          totalSalaryItems.value = responseData['meta']['total'] ?? 0;
        }
      }
      else {
        SnackbarHelper.showError(title: "Error", message: "Server error: ${response.statusCode}");
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch salaries: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void changeRoleAndFetch(String role) {

    String formattedRole = role.toLowerCase();
    if (selectedRole.value != formattedRole) {
      selectedRole.value = formattedRole;
      //to back to first page
      fetchSalaries(page: 1);
    }
  }



  Future<void> updateSalary(int salaryId, String newSalary) async {
  try {
  Get.back();
  isLoading.value = true;
  String? token = settingService.sharedPreferences.getString("token");
  var url = Uri.parse("${AppConstants.linkChangeSalaryById(salaryId)}");
  var response = await http.put(
  url,
  headers: AppConstants.headers(token!),
    body: jsonEncode({
      'salary': double.tryParse(newSalary) ?? 0,
      'date': "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
    }),
  );

  if (response.statusCode == 200) {
  SnackbarHelper.showSuccess(title: "Success", message: "Salary changed successfully");
  fetchSalaries(page: currentSalaryPage.value);
  } else {
  SnackbarHelper.showError(title: "Error", message: "Refresh failed");
  }
  } catch (e) {
    SnackbarHelper.showError(title: "Error", message: "Error updating salary: $e");
  } finally {
  isLoading.value = false;
  }
}

  Future<void> togglePaymentStatus(SalaryModel teacher) async {
    try {

     String? token = settingService.sharedPreferences.getString("token");
       var changePaymentStatusUrl = Uri.parse("${AppConstants.linkPaidSalaryById(teacher.id)}");
      var response = await http.put(changePaymentStatusUrl, headers: AppConstants.headers(token!));
      if (response.statusCode == 200) {
        var responseBody=jsonDecode(response.body);
        teacher.status = teacher.status == 1 ? 0 : 1;
        displayedUsers.refresh();
        SnackbarHelper.showSuccess(title: "Success", message: responseBody["message"]);
      }
    } catch (e) {
        SnackbarHelper.showError(title: "Error", message: "Toggle status error: $e");
    }
  }

  void searchByName(String query) {
    if (query.isEmpty) {
      displayedUsers.assignAll(allUsers);
    } else {
      displayedUsers.assignAll(
          allUsers.where((user) =>
              user.name.toLowerCase().contains(query.toLowerCase())
          ).toList()
      );
    }
  }

  @override
  void onClose() {
    searchEditingController.dispose();
    super.onClose();
  }
}