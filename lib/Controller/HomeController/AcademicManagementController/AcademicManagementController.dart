import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/core/AppConstants.dart';
import 'dart:convert';
import 'package:school_management/core/Utils/ErrorHandler.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';

import '../../../Model/HomeModel/AcademicManagementModel/StageModel.dart';
import '../../../Model/HomeModel/SectionModel.dart';
import '../../../Model/HomeModel/SubjectModel.dart';
import '../../../core/Services/SettingsService.dart';

import '../../../core/Utils/MockData.dart';

class AcademicManagementController extends GetxController {

  SettingService get settingService => Get.find<SettingService>();

  var stages = <StageModel>[].obs;
  var subjects = <SubjectModel>[].obs;
  var isLoading = false.obs;

  var selectedStageForSection = Rxn<StageModel>();
  var selectedStageForDisplay = Rxn<StageModel>();
  var selectedStageForSubject = Rxn<StageModel>();

  @override
  void onInit() {
    super.onInit();
    getStudyStages();
  }

  void createStudyStage(int studyStage)async{
    if (settingService.isGuestMode.value) {
      SnackbarHelper.showSuccess(title: "Success", message: "Stage created (Guest Mode)");
      return;
    }
    try{
      isLoading.value=true;
      String? token=settingService.sharedPreferences.getString('token');
      var response=await http.post(
          Uri.parse(AppConstants.linkCreateStudyStage),
          headers: AppConstants.headers(token!),
          body: jsonEncode(
            {'stage_number':studyStage,}
          ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        SnackbarHelper.showSuccess(title: "Success", message: "Study stage created successfully");
        getStudyStages();
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      ErrorHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  void getStudyStages()async{
    if (settingService.isGuestMode.value) {
      stages.assignAll(MockData.mockStages);
      return;
    }
    try{
      isLoading.value=true;
      String? token=settingService.sharedPreferences.getString('token');
      var response=await http.get(
          Uri.parse(AppConstants.linkGetStudyStage),
          headers: AppConstants.headers(token!)
      );
      
      if(response.statusCode==200){
        var responseBody=jsonDecode(response.body);
        dynamic rawData = responseBody['data'];
        List fetchedList = [];
        if (rawData is List) {
          fetchedList = rawData;
        } else if (rawData is Map && rawData.containsKey('data')) {
          var innerData = rawData['data'];
          if (innerData is List) {
            fetchedList = innerData;
          } else if (innerData != null) {
            fetchedList = [innerData];
          }
        } else if (responseBody is List) {
          fetchedList = responseBody;
        } else if (rawData != null) {
          fetchedList = [rawData];
        }
        stages.assignAll(fetchedList.map<StageModel>((stage)=>StageModel.fromJson(stage)).toList());
      }
      else {
        ErrorHandler.handleHttpError(response);
         }
    } catch (e) {
      ErrorHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  void updateStudyStage(int id,int studyStageNumber)async{
    try{
      isLoading.value=true;
      String? token=settingService.sharedPreferences.getString('token');
      var response=await http.put(
          Uri.parse(AppConstants.linkUpdateStudyStage(id)),
          headers: AppConstants.headers(token!),
          body: {
            'id':id,
            'stage_number': studyStageNumber,
          }
      );
      if (response.statusCode == 200) {
        SnackbarHelper.showSuccess(title: "Success", message: "Study stage updated successfully");
      }
      else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      ErrorHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }

  }

  void deleteStudyStage(int id) async {
    try {
      isLoading.value = true;
      String? token = settingService.sharedPreferences.getString('token');
      var response = await http.delete(
        Uri.parse(AppConstants.linkDeleteStudyStage(id)),
        headers: AppConstants.headers(token!),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        stages.removeWhere((element) => element.id == id);
        SnackbarHelper.showSuccess(title: "Success", message: "Stage deleted successfully");
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      ErrorHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  void createSection(int sectionNumber) async {
    if (selectedStageForSection.value == null) {
      SnackbarHelper.showWarning(title: "Warning", message: "Please select a stage first");
      return;
    }

    try {
      isLoading.value = true;
      String? token = settingService.sharedPreferences.getString('token');
      var response = await http.post(
        Uri.parse(AppConstants.linkCreateSection),
        headers: AppConstants.headers(token!),
        body: jsonEncode({
          'study_stage_id': selectedStageForSection.value!.id,
          'section_number': sectionNumber,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        SnackbarHelper.showSuccess(title: "Success", message: "Section created successfully");
        getStudyStages();
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      ErrorHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }
  List<int> getSectionsForSelectedStage(StageModel? stage) {
    if (stage == null) return [];
    return stage.section_number;
  }

  Future<void> fetchSubjectsByGrade(int gradeId) async {
    if (settingService.isGuestMode.value) {
      subjects.assignAll(MockData.mockSubjects.where((s) => s.gradeId == gradeId).toList());
      return;
    }
    try {
      isLoading.value = true;
      var response = await http.get(Uri.parse(AppConstants.linkGetSubjectsByGrade(gradeId)));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        
        dynamic rawMaterials = responseData['materials'] ?? responseData['data'];
        List fetchedList = [];

        if (rawMaterials is Map && rawMaterials.containsKey('data')) {
          fetchedList = rawMaterials['data'];
        } else if (rawMaterials is List) {
          fetchedList = rawMaterials;
        } else if (responseData is List) {
          fetchedList = responseData;
        }

        subjects.assignAll(fetchedList.map<SubjectModel>((e) => SubjectModel.fromJson(e)).toList());
        subjects.refresh();
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      ErrorHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  void addNewSubject(String subjectName) {
    if (selectedStageForSubject.value == null) {
      SnackbarHelper.showWarning(title: "Warning", message: "Please select a grade first");
      return;
    }
    if (subjectName.isEmpty) {
      SnackbarHelper.showWarning(title: "Warning", message: "Please enter the subject name");
      return;
    }

    bool exists = subjects.any((s) => s.name.toLowerCase() == subjectName.toLowerCase());
    if (exists) {
      SnackbarHelper.showError(title: "Error", message: "This subject already exists for this grade");
    } else {
      addItem(AppConstants.linkAddSubjectOnGrade, {
        "name": subjectName,
        "study_stage_id": selectedStageForSubject.value!.id
      }, () => fetchSubjectsByGrade(selectedStageForSubject.value!.id));
    }
  }

  Future<void> addItem(String url, Map<String, dynamic> body, Function onSuccess) async {
    try {
      String? token=settingService.sharedPreferences.getString("token");
      var response = await http.post(
        Uri.parse(url),
        headers: AppConstants.headers(token!),
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        SnackbarHelper.showSuccess(title: "Success", message: "The addition process was successful");
        onSuccess();
      } else {
        print("The response is :${response.body}");
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}