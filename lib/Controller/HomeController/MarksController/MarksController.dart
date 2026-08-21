import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Services/SettingsService.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';

import '../../../Model/HomeModel/Marks/MarkModel.dart';
import '../../../Model/HomeModel/AcademicManagementModel/StageModel.dart';
import '../../../Model/HomeModel/SubjectModel.dart';

import '../../../core/Utils/MockData.dart';

class MarksController extends GetxController {
  final SettingService settingService = Get.find();

  var marksRecords = <MarkModel>[].obs;
  var displayedMarks = <MarkModel>[].obs;
  var isLoading = false.obs;

  // Data for Filters
  var grades = <StageModel>[].obs;
  var subjectsList = <SubjectModel>[].obs;
  var isLoadingFilters = false.obs;

  var selectedGrade = Rxn<StageModel>();
  var selectedSubject = Rxn<SubjectModel>();

  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    if (settingService.isGuestMode.value) {
      grades.assignAll(MockData.mockStages);
      marksRecords.assignAll(MockData.mockMarks);
      displayedMarks.assignAll(MockData.mockMarks);
      return;
    }
    await fetchGrades();
    await fetchMarks();
  }

  Future<void> fetchGrades() async {
    try {
      isLoadingFilters.value = true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
        Uri.parse(AppConstants.linkGetStudyStage),
        headers: AppConstants.headers(token!),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        dynamic rawData = responseBody['data'];
        List dataList = [];

        if (rawData is List) {
          dataList = rawData;
        } else if (rawData is Map && rawData.containsKey('data')) {
          dataList = rawData['data'];
        }

        grades.assignAll(dataList.map<StageModel>((e) => StageModel.fromJson(e)).toList());
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch grades: $e");
    } finally {
      isLoadingFilters.value = false;
    }
  }

  Future<void> onGradeSelected(StageModel? grade) async {
    selectedGrade.value = grade;
    selectedSubject.value = null;
    subjectsList.clear();

    if (grade != null) {
      await fetchSubjectsByGrade(grade.id);
    }
  }

  Future<void> fetchSubjectsByGrade(int gradeId) async {
    try {
      isLoadingFilters.value = true;
      var response = await http.get(Uri.parse(AppConstants.linkGetSubjectsByGrade(gradeId)));
      
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        dynamic rawMaterials = responseData['materials'] ?? responseData['data'];
        List fetchedList = [];

        if (rawMaterials is Map && rawMaterials.containsKey('data')) {
          fetchedList = rawMaterials['data'];
        } else if (rawMaterials is List) {
          fetchedList = rawMaterials;
        }

        subjectsList.assignAll(fetchedList.map<SubjectModel>((e) => SubjectModel.fromJson(e)).toList());
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch subjects: $e");
    } finally {
      isLoadingFilters.value = false;
    }
  }

  Future<void> fetchMarks() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(AppConstants.linkGetMarks));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var list = data['marks'] as List? ?? [];

        marksRecords.value = list.map((m) => MarkModel.fromJson(m)).toList();
        displayedMarks.value = marksRecords.value;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to load marks: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void searchSubjectMarks(String query) {
    if (query.isEmpty) {
      displayedMarks.value = marksRecords;
    } else {
      displayedMarks.value = marksRecords.where((mark) =>
      mark.studentName.toLowerCase().contains(query.toLowerCase()) ||
          mark.subjectName.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  void onSubjectSelected(SubjectModel? subject) {
    selectedSubject.value = subject;
    // Here you could add logic to filter marksRecords locally or fetch from server
    if (subject != null) {
       displayedMarks.value = marksRecords.where((m) => m.subjectName == subject.name).toList();
    } else {
       displayedMarks.value = marksRecords.value;
    }
  }
}
