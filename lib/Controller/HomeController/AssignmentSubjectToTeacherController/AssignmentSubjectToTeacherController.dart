import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Services/SettingsService.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import 'dart:convert';
import '../../../Model/HomeModel/SubjectModel.dart';
import '../../../Model/HomeModel/AcademicManagementModel/StageModel.dart';
import '../../../Model/HomeModel/TacherModel/TeacherModel.dart';
import '../../../Model/HomeModel/SectionModel.dart';

class AssignmentSubjectToTeacherController extends GetxController {

  var subjects = <SubjectModel>[].obs;
  var teachers = <TeacherModel>[].obs;
  var classes = <StageModel>[].obs;
  var isLoading = false.obs;
  var isSubjectMode = true.obs;
  var selectedSubject = Rxn<SubjectModel>();
  var selectedTeacher = Rxn<TeacherModel>();
  var selectedClass = Rxn<StageModel>();
  var selectedSection = Rxn<SectionModel>();

  final SettingService settingService = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  void fetchInitialData() async {
    isLoading.value = true;
    await Future.wait([
      fetchSubjects(),
      fetchTeachers(),
      fetchClasses(),
    ]);
    isLoading.value = false;
  }

  Future<void> fetchSubjects() async {
    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
          Uri.parse(AppConstants.linkGetSubjects),
          headers: AppConstants.headers(token!)
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        List dataList;
        if (responseBody is Map && responseBody.containsKey('data')) {
          dataList = responseBody['data']["materials"];
        }
       else if (responseBody is Map && responseBody.containsKey('materials')) {
          dataList = responseBody["materials"];
        }
        else if (responseBody is List) {
          dataList = responseBody;
        } else {
          dataList = [responseBody];
        }
        subjects.assignAll(dataList.map<SubjectModel>((e) => SubjectModel.fromJson(e)).toList());
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch subjects : $e");
    }
  }

  Future<void> fetchTeachers() async {
    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
          Uri.parse(AppConstants.linkGetAllTeachers),
          headers: AppConstants.headers(token!)
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        List dataList;
        if (responseBody is Map && responseBody.containsKey('data')) {
          dataList = responseBody['data'];
        } else if (responseBody is List) {
          dataList = responseBody;
        } else {
          dataList = [responseBody];
        }
        teachers.assignAll(dataList.map<TeacherModel>((e) => TeacherModel.fromJson(e)).toList());
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch teachers : $e");
    }
  }

  Future<void> fetchClasses() async {
    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
          Uri.parse(AppConstants.linkGetStudyStage),
          headers: AppConstants.headers(token!)
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        List dataList;
        if (responseBody is Map && responseBody.containsKey('data')) {
          dataList = responseBody['data'];
        } else if (responseBody is List) {
          dataList = responseBody;
        } else {
          dataList = [responseBody];
        }
        classes.assignAll(dataList.map<StageModel>((e) => StageModel.fromJson(e)).toList());
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch classes : $e");
    }
  }

  Future<void> assignTeacherToSubject() async {
    if (selectedSubject.value == null || selectedTeacher.value == null) {
      SnackbarHelper.showWarning(title: "Warning", message: "Please select both subject and teacher");
      return;
    }

    try {
      isLoading.value = true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.post(
        Uri.parse(AppConstants.linkAssignMaterialToTeacher),
        headers: AppConstants.headers(token!),
        body: jsonEncode({
          "material_id": selectedSubject.value!.id,
          "teacher_id": selectedTeacher.value!.teacher_id,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        SnackbarHelper.showSuccess(title: "Success", message: "Teacher assigned to subject successfully");
        selectedSubject.value = null;
        selectedTeacher.value = null;
      } else {
        SnackbarHelper.showError(title: "Error", message: "Failed to assign subject");
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> assignTeacherToClass() async {
    if (selectedClass.value == null || selectedSection.value == null || selectedTeacher.value == null) {
      SnackbarHelper.showWarning(title: "Warning", message: "Please select class, section and teacher");
      return;
    }

    try {
      isLoading.value = true;
      String? token = settingService.sharedPreferences.getString("token");

      var response = await http.post(
        Uri.parse(AppConstants.linkAssignTeacherToGrade),
        headers: AppConstants.headers(token!),
        body: jsonEncode({
          "section_id": selectedSection.value!.id,
          "teacher_id": selectedTeacher.value!.teacher_id,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        SnackbarHelper.showSuccess(title: "Success", message: "Teacher assigned to section successfully");
        selectedClass.value = null;
        selectedSection.value = null;
        selectedTeacher.value = null;
      } else {
        SnackbarHelper.showError(title: "Error", message: "Failed to assign teacher to section");
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onClassSelected(StageModel? val) {
    selectedClass.value = val;
    selectedSection.value = null;
  }

}