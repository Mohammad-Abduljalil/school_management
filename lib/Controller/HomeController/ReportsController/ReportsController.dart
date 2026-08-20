import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Services/SettingsService.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import 'dart:html' as html; // Only works on Web

import '../../../Model/HomeModel/ReportModel.dart';

class ReportsController extends GetxController {
  var isLoading = true.obs;
  RxList<ReportModel> reports = <ReportModel>[].obs;
  RxList<ReportModel> allReports = <ReportModel>[].obs;

  var currentReportsPage = 1.obs;
  var totalReportsPages = 1.obs;
  final SettingService settingService = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports({int page = 1}) async {
    try {
      isLoading.value = true;
      currentReportsPage.value = page;
      String? token = settingService.sharedPreferences.getString("token");
      var url = Uri.parse("${AppConstants.linkGetReports}?page=$page");
      var response = await http.get(
        url,
        headers: AppConstants.headers(token!),
      );
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        
        // Check data location in JSON (support Pagination or direct List)
        var rawData = responseData['data'];
        List fetchedList = [];
        
        if (rawData is List) {
          fetchedList = rawData;
        } else if (rawData is Map) {
          // If the server returns only one object instead of an array
          fetchedList = [rawData];
        } else if (responseData is List) {
          fetchedList = responseData;
        }

        List<ReportModel> mappedReports = fetchedList
            .map<ReportModel>((item) => ReportModel.fromJson(item))
            .toList();

        allReports.assignAll(mappedReports);
        reports.assignAll(mappedReports);

        // Update page information
        if (responseData['meta'] != null) {
          totalReportsPages.value = responseData['meta']['last_page'] ?? 1;
        } else if (responseData['last_page'] != null) {
          totalReportsPages.value = responseData['last_page'] ?? 1;
        }
      } else {
        SnackbarHelper.showError(title: "Error", message: "Server returned: ${response.statusCode}");
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void downloadReport(int id) {
    String? token = settingService.sharedPreferences.getString("token");
    String downloadUrl = AppConstants.linkDownloadReport(id);

    try {
       html.window.open(downloadUrl, '_blank');
    } catch (e) {
       SnackbarHelper.showError(title: "Error", message: "Could not open download link on this platform");
    }
  }

  void searchByType(String query) {
    if (query.isEmpty) {
      reports.assignAll(allReports);
    } else {
      reports.assignAll(
          allReports.where((report) =>
              report.type.toLowerCase().contains(query.toLowerCase())
          ).toList()
      );
    }
  }
}
