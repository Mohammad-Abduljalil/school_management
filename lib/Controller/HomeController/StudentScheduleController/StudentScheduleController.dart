import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Services/SettingsService.dart';
import 'package:school_management/core/Utils/ErrorHandler.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import '../../../Model/HomeModel/StudentScheduleModel/ScheduleStageModel.dart';
import '../../../Model/HomeModel/StudentScheduleModel/ScheduleSectionModel.dart';
import '../../../Model/HomeModel/StudentScheduleModel/ScheduleModel.dart';
import '../../../Model/HomeModel/StudentScheduleModel/ScheduleSlotModel.dart';
import '../../../Model/HomeModel/StudentScheduleModel/PeriodTemplateModel.dart';
import '../../../Model/HomeModel/SubjectModel.dart';
import '../../../Model/HomeModel/StudentScheduleModel/TeacherModel.dart';

import '../../../core/Utils/MockData.dart';

class ScheduleController extends GetxController {

  final RxList<ScheduleStageModel> grades = <ScheduleStageModel>[].obs;
  final RxList<ScheduleSectionModel> sections = <ScheduleSectionModel>[].obs;
  final RxList<PeriodTemplateModel> periodTemplates = <PeriodTemplateModel>[].obs;
  final Rx<ScheduleStageModel?> selectedGrade = Rx<ScheduleStageModel?>(null);
  final Rx<ScheduleSectionModel?> selectedSection = Rx<ScheduleSectionModel?>(null);
  final Rx<ScheduleModel?> schedule = Rx<ScheduleModel?>(null);
  ScheduleModel? _originalSchedule; 

  final RxBool isLoadingGrades = false.obs;
  final RxBool isLoadingSchedule = false.obs;
  final RxBool hasError = false.obs;
  final RxString selectedSubjectFilter = 'All Subject'.obs;
  final academicYearController = TextEditingController(text: "2024-2025");
  final semester = "1".obs;
  final RxList<SubjectModel> availableSubjects = <SubjectModel>[].obs;
  final RxList<TeacherModel> availableTeachers = <TeacherModel>[].obs;
  final RxBool isLoadingSubjects = false.obs;
  final RxBool isLoadingTeachers = false.obs;

  final RxBool isSaving = false.obs;

  final List<String> uiDays = ['SUN', 'MON', 'TUE', 'WED', 'THU'];
  final Map<String, String> dayMapping = {
    'SUN': 'sunday',
    'MON': 'monday',
    'TUE': 'tuesday',
    'WED': 'wednesday',
    'THU': 'thursday',
  };

  final SettingService settingService = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchGradesAndPeriods();
  }

  Future<void> fetchGradesAndPeriods() async {
    isLoadingGrades.value = true;
    hasError.value = false; // Reset error state

    if (settingService.isGuestMode.value) {
      grades.assignAll(MockData.mockStages.map((s) => ScheduleStageModel(id: s.id, stageNumber: s.stage_number, sections: s.sections.map((sec) => ScheduleSectionModel(sectionId: sec.id, sectionName: sec.name)).toList())).toList());
      periodTemplates.assignAll(MockData.mockPeriods);
      availableSubjects.assignAll(MockData.mockSubjects);
      availableTeachers.assignAll(MockData.mockTeachers.map((t) => TeacherModel(id: t.id, full_name: t.full_name, teacher_id: t.teacher_id, imageUrl: t.profile_image)).toList());
      isLoadingGrades.value = false;
      return;
    }

    await Future.wait([
      fetchGrades(),
      fetchPeriodTemplates(),
      fetchSubjects(),
      fetchAllTeachers(),
    ]);
    isLoadingGrades.value = false;
  }

  Future<void> fetchAllTeachers() async {
    isLoadingTeachers.value = true;
    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
          Uri.parse(AppConstants.linkGetAllTeachers),
          headers: AppConstants.headers(token!)
      );
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        List dataList = body['data'] ?? [];
        availableTeachers.assignAll(dataList.map((e) => TeacherModel.fromJson(e)).toList());
      }
    } catch (e) {
      print("Fetch All Teachers Error: $e");
    } finally {
      isLoadingTeachers.value = false;
    }
  }

  Future<void> fetchGrades() async {
    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
          Uri.parse(AppConstants.linkGetStudyStage),
          headers: AppConstants.headers(token!)
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        List dataList = responseBody['data'] ?? [];

        final parsedGrades = <ScheduleStageModel>[];
        for (var e in dataList) {
          try {
            parsedGrades.add(ScheduleStageModel.fromJson(e));
          } catch (itemError) {
            SnackbarHelper.showError(title: "Error", message: "Failed to parse grade: $itemError");
          }
        }
        grades.assignAll(parsedGrades);
      } else {
        ErrorHandler.handleHttpError(response);
        hasError.value = true;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch grades: $e");
      ErrorHandler.handleException(e);
      hasError.value = true;
    }
  }

  Future<void> fetchPeriodTemplates() async {
    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
          Uri.parse(AppConstants.linkGetPeriods),
          headers: AppConstants.headers(token!)
      );
      if (response.statusCode == 200) {
        List dataList = jsonDecode(response.body);
        final parsedPeriods = <PeriodTemplateModel>[];
        for (var e in dataList) {
          try {
            parsedPeriods.add(PeriodTemplateModel.fromJson(e));
          } catch (itemError) {
            SnackbarHelper.showError(title: "Error", message: "Failed to parse period: $itemError");
          }
        }
        periodTemplates.assignAll(parsedPeriods);
      } else {
        ErrorHandler.handleHttpError(response);
        hasError.value = true;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch periods: $e");
      ErrorHandler.handleException(e);
      hasError.value = true;
      }
  }

  void onGradeSelected(ScheduleStageModel grade) {
    selectedGrade.value = grade;
    selectedSection.value = null;
    schedule.value = null;
    sections.assignAll(grade.sections);
  }

  Future<void> onSectionSelected(ScheduleSectionModel section) async {
    selectedSection.value = section;
    schedule.value = null;
    selectedSubjectFilter.value = 'All Subject';
    await fetchSchedule();
  }

  Future<void> fetchSchedule() async {
    final grade = selectedGrade.value;
    final section = selectedSection.value;
    if (grade == null || section == null) return;

    isLoadingSchedule.value = true;
    hasError.value = false;

    if (settingService.isGuestMode.value) {
      schedule.value = MockData.mockSchedule;
      _originalSchedule = MockData.mockSchedule;
      isLoadingSchedule.value = false;
      return;
    }

    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
        Uri.parse(AppConstants.linkGetScheduleOfSection(section.sectionId, grade.id)),
        headers: AppConstants.headers(token!),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        // If schedule ID exists (even if slots are empty), display it
        if (responseData['schedule_id'] != null || responseData['schedule'] != null || (responseData['data'] != null && responseData['data'] is Map)) {
          final fetchedSchedule = ScheduleModel.fromJson(responseData);
          schedule.value = fetchedSchedule;
          _originalSchedule = ScheduleModel.fromJson(jsonDecode(jsonEncode(responseData)));
          _recoverAllIds(schedule.value);
          _recoverAllIds(_originalSchedule);
        } 
        // If no ID exists and data is completely empty
        else if (responseData['data'] == null || (responseData['data'] as List).isEmpty) {
           schedule.value = null;
           SnackbarHelper.showError(title: "Error", message: "No schedule entry exists. Showing creation view.");
        } else {
          // Fallback case if the list contains data
          final fetchedSchedule = ScheduleModel.fromJson(responseData);
          schedule.value = fetchedSchedule;
          _recoverAllIds(schedule.value);
        }
      } else if (response.statusCode == 404) {
        schedule.value = null; 
      } else {
        ErrorHandler.handleHttpError(response);
        hasError.value = true;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch schedule: $e");
      ErrorHandler.handleException(e);
      hasError.value = true;
    } finally {
      isLoadingSchedule.value = false;
    }
  }

  Future<void> createSchedule() async {
    final grade = selectedGrade.value;
    final section = selectedSection.value;
    if (grade == null || section == null) return;
    isLoadingSchedule.value = true;
    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.post(
        Uri.parse(AppConstants.linkCreateSchedule),
        headers: AppConstants.headers(token!),
        body: jsonEncode({
          'study_stage_id': grade.id,
          'section_id': section.sectionId,
          'academic_year': academicYearController.text,
          'semester': semester.value,
        }),
      );

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        // Update state immediately with the new schedule from the server
        schedule.value = ScheduleModel.fromJson(responseData);
        _originalSchedule = ScheduleModel.fromJson(jsonDecode(jsonEncode(responseData)));
        
        SnackbarHelper.showSuccess(title: "Success", message: "Schedule created successfully. You can now add slots.");
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to create schedule: $e");
      ErrorHandler.handleException(e);
    } finally {
      isLoadingSchedule.value = false;
    }
  }

  // Helper function to link all IDs (Period, Material, Teacher) programmatically
  void _recoverAllIds(ScheduleModel? s) {
    if (s == null) return;
    s.days.forEach((day, slots) {
      slots.forEach((periodName, slot) {
        // 1. Recover Period ID
        if (slot.periodId == 0) {
          final template = periodTemplates.firstWhereOrNull((p) {
            final normalizedTemplate = p.name.toLowerCase().replaceAll(RegExp(r'\s+'), '');
            final normalizedSlot = periodName.toLowerCase().replaceAll(RegExp(r'\s+'), '');
            return normalizedTemplate == normalizedSlot || 
                   normalizedTemplate.contains(normalizedSlot) || 
                   normalizedSlot.contains(normalizedTemplate);
          });
          if (template != null) slot.periodId = template.id;
        }

        // 2. Recover Material ID
        if (slot.materialId == 0 && slot.materialName.isNotEmpty) {
          final subject = availableSubjects.firstWhereOrNull((sub) => 
            sub.name.toLowerCase().trim() == slot.materialName.toLowerCase().trim()
          );
          if (subject != null) slot.materialId = subject.id;
        }

        // 3. Recover Teacher ID
        if (slot.teacherId == 0 && slot.teacherName.isNotEmpty) {
          final teacher = availableTeachers.firstWhereOrNull((t) => 
            t.full_name.toLowerCase().trim() == slot.teacherName.toLowerCase().trim()
          );
          if (teacher != null) slot.teacherId = teacher.teacher_id;
        }
      });
    });
  }

  ScheduleSlotModel? getSlot(String uiDay, String periodName) {
    final backendDay = dayMapping[uiDay];
    if (backendDay == null) return null;
    return schedule.value?.days[backendDay]?[periodName];
  }

  Future<void> updatePeriod({
    required String day, 
    required String periodName, 
    required int materialId, 
    required String materialName,
    required int teacherId,
    required String teacherName,
    required int periodId,
    String startTime = '',
    String endTime = '',
  }) async {
    if (schedule.value == null) return;

    final backendDay = dayMapping[day]!;
    
    final newSlot = ScheduleSlotModel(
      id: schedule.value!.days[backendDay]?[periodName]?.id ?? 0,
      periodName: periodName,
      startTime: startTime, 
      endTime: endTime, 
      materialName: materialName,
      teacherName: teacherName,
      materialId: materialId,
      teacherId: teacherId,
      periodId: periodId,
    );

    if (schedule.value!.days[backendDay] == null) {
      schedule.value!.days[backendDay] = {};
    }
    schedule.value!.days[backendDay]![periodName] = newSlot;
    schedule.refresh();
  }

  Future<void> saveSchedule() async {
    if (schedule.value == null) return;

    isSaving.value = true;
    try {
      final List<Map<String, dynamic>> createdSlots = [];
      final List<Map<String, dynamic>> updatedSlots = [];
      final List<int> deletedSlotIds = [];

      schedule.value!.days.forEach((day, periods) {
        periods.forEach((periodName, slot) {
          final Map<String, dynamic> slotData = {
            'day': day,
            'period_id': slot.periodId,
            'teacher_id': slot.teacherId,
            'material_id': slot.materialId,
          };

          if (slot.id == 0) {
            createdSlots.add(slotData);
          } else {
            final originalSlot = _originalSchedule?.days[day]?[periodName];
            if (originalSlot == null || 
                originalSlot.materialId != slot.materialId || 
                originalSlot.teacherId != slot.teacherId) {
               slotData['id'] = slot.id;
               updatedSlots.add(slotData);
            }
          }
        });
      });

      _originalSchedule?.days.forEach((day, periods) {
        periods.forEach((periodName, originalSlot) {
          if (schedule.value?.days[day]?[periodName] == null) {
            deletedSlotIds.add(originalSlot.id);
          }
        });
      });

      String? token = settingService.sharedPreferences.getString("token");
      final requestBody = jsonEncode({
        'schedule_id': schedule.value!.scheduleId,
        'created_slots': createdSlots,
        'updated_slots': updatedSlots,
        'deleted_slot_ids': deletedSlotIds,
      });

      print("--- SYNC SCHEDULE REQUEST ---");
      print(requestBody);
      print("-----------------------------");

      var response = await http.post(
        Uri.parse(AppConstants.linkSyncScheduleSlots),
        headers: AppConstants.headers(token!),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        await fetchSchedule();
        SnackbarHelper.showSuccess(title: "Success", message: "Schedule synchronized successfully");
      } else {
        print(response.body);
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to save schedule: $e");
      ErrorHandler.handleException(e);
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> fetchSubjects() async {
    isLoadingSubjects.value = true;
    availableSubjects.clear();
    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
          Uri.parse(AppConstants.linkGetSubjects),
          headers: AppConstants.headers(token!)
      );
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        List dataList = [];
        if (body is Map && body.containsKey('materials')) {
           dataList = body['materials'];
        } else if (body is List) {
           dataList = body;
        }
        availableSubjects.assignAll(dataList.map((e) => SubjectModel.fromJson(e)).toList());
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Fetch Subjects Error: $e");
    } finally {
      isLoadingSubjects.value = false;
    }
  }

  Future<void> fetchTeachersBySubject(SubjectModel subject) async {
    isLoadingTeachers.value = true;
    availableTeachers.clear();
    try {
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(
          Uri.parse(AppConstants.linkGetAllTeachers),
          headers: AppConstants.headers(token!)
      );
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        List dataList = body['data'] ?? [];
        availableTeachers.assignAll(dataList.map((e) => TeacherModel.fromJson(e)).toList());
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Fetch Teachers Error: $e");
    } finally {
      isLoadingTeachers.value = false;
    }
  }

  void setFilter(String subject) => selectedSubjectFilter.value = subject;

  List<String> getSubjectsList() {
    final subjects = <String>{'All Subject'};
    final currentSchedule = schedule.value;
    if (currentSchedule == null) return subjects.toList();

    for (var dayMap in currentSchedule.days.values) {
      for (var slot in dayMap.values) {
        if (slot.materialName.isNotEmpty) {
          subjects.add(slot.materialName);
        }
      }
    }
    return subjects.toList();
  }

  void discardChanges() {
     fetchSchedule();
  }
}
