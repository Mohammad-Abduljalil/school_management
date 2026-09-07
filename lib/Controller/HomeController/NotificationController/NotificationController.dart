import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Utils/ErrorHandler.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import '../../../Model/HomeModel/NotificationModel.dart';

import '../../../core/Utils/MockData.dart';
import '../../../core/Services/SettingsService.dart';

class NotificationController extends GetxController {
  final notificationsList = <NotificationModel>[].obs;
  final isLoadingList = false.obs;
  final isSending = false.obs;
  final errorMessage = ''.obs;
  final formKey=GlobalKey<FormState>();

  final selectedRecipient = 'Students'.obs;
  final selectedGrade = 'All Grades'.obs;
  final subjectController = TextEditingController();
  final bodyController = TextEditingController();
  
  SettingService get settingService => Get.find<SettingService>();

  //  Static Data
  final recipients = ['Students', 'Teachers', 'Supervisor'];
  final grades = [
    'All Grades',
    'Grade 1',
    'Grade 2',
    'Grade 3',
    'Grade 4',
    'Grade 5',
    'Grade 6',
  ];



  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $token',
      };


  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }



  Map<String, List<NotificationModel>> get groupedNotifications {
    final Map<String, List<NotificationModel>> grouped = {};
    final now = DateTime.now();

    for (final n in notificationsList) {
      final diff = now.difference(n.createdAt).inDays;
      final String label;

      if (diff == 0) {
        label = 'Today';
      } else if (diff == 1) {
        label = 'Yesterday';
      } else {
        label = '${n.createdAt.day}/${n.createdAt.month}/${n.createdAt.year}';
      }

      grouped.putIfAbsent(label, () => []).add(n);
    }
    return grouped;
  }

  Future<void> fetchNotifications() async {
    errorMessage.value = '';

    try {
      isLoadingList.value = true;

      if (settingService.isGuestMode.value) {
        await Future.delayed(const Duration(milliseconds: 500));
        notificationsList.assignAll(MockData.mockNotifications);
        isLoadingList.value = false;
        return;
      }

      String? token = settingService.sharedPreferences.getString("token");
      if (token == null) {
        SnackbarHelper.showError(title: "Auth Error", message: "Please login to view notifications");
        return;
      }

      final response = await http.get(
        Uri.parse(AppConstants.linkGetNotifications),
        headers: AppConstants.headers(token),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['data'] != null && responseData['data'] is List) {
          final List data = responseData['data'];
          notificationsList.assignAll(data.map((e) => NotificationModel.fromJson(e)).toList());
        }
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      ErrorHandler.handleException(e);
      errorMessage.value = 'Failed to load notifications';
    } finally {
      isLoadingList.value = false;
    }
  }

  Future<void> sendNotification() async {
    if (subjectController.text.trim().isEmpty ||
        bodyController.text.trim().isEmpty) {
      SnackbarHelper.showWarning(title: "Warning", message: "Please fill in the subject and message body");
      return;
    }

    isSending.value = true;

    try {
      String? token = settingService.sharedPreferences.getString("token");
      if (token == null) {
        SnackbarHelper.showError(title: "Auth Error", message: "Session expired. Please login again.");
        return;
      }
      
      final Map<String, dynamic> payload = {
        'title': subjectController.text.trim(),
        'content': bodyController.text.trim(),
      };

      if (selectedGrade.value != 'All Grades') {
        payload['grade'] = selectedGrade.value;
      }

      final response = await http.post(
        Uri.parse(AppConstants.linkAddNotification),
        headers: AppConstants.headers(token),
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        _clearForm();
        await fetchNotifications();
        SnackbarHelper.showSuccess(title: "Success", message: "Notification sent successfully");
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      ErrorHandler.handleException(e);
    } finally {
      isSending.value = false;
    }
  }

  Future<void> markNotificationsAsRead(int id) async {
    try {
      await http.patch(
        Uri.parse(AppConstants.linkMakeNotificationsIsRead(id)),
        headers: _headers,
      );

      final index = notificationsList.indexWhere((n) => n.id == id);
      if (index != -1) {
        final oldNotifications = notificationsList[index];
        notificationsList[index] = NotificationModel(
          id: oldNotifications.id,
          title: oldNotifications.title,
          body: oldNotifications.body,
          type: oldNotifications.type,
          grade: oldNotifications.grade,
          isRead: true,
          createdAt: oldNotifications.createdAt,
        );
        notificationsList.refresh();
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: e.toString());
    }
  }

  void setRecipient(String value) => selectedRecipient.value = value;
  void setGrade(String value) => selectedGrade.value = value;

  void _clearForm() {
    subjectController.clear();
    bodyController.clear();
    selectedRecipient.value = 'Students';
    selectedGrade.value = 'All Grades';
  }

  @override
  void onClose() {
    subjectController.dispose();
    bodyController.dispose();
    super.onClose();
  }

}

