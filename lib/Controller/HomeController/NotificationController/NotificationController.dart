import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import '../../../Model/HomeModel/NotificationModel.dart';

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


      //before link
      await Future.delayed(const Duration(seconds: 1));
      // Mock data
      final List<NotificationModel> mockData = [
      NotificationModel(
        id: 1,
        title: 'Welcome to Darra School',
        body: 'We are glad to have you in our educational community.',
        type: 'students',
        grade: 'All Grades',
        isRead: false,
        createdAt: DateTime.now(),
      ),
    NotificationModel(
    id: 2,
    title: 'Exam Schedule Update',
    body: 'The final exams for Grade 12 have been rescheduled to next Sunday.',
    type: 'students',
    grade: 'Grade 12',
    isRead: true,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
    id: 3,
    title: 'New Policy for Teachers',
    body: 'Please review the new attendance policy in the staff room.',
    type: 'teachers',
    grade: 'All Grades',
    isRead: false,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
        NotificationModel(
          id: 4,
          title: 'Maintenance Alert',
          body: 'The school library will be closed for maintenance this weekend.',
          type: 'supervisor',
          grade: 'All Grades',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),NotificationModel(
          id: 5,
          title: 'Exam Schedule Update',
          body: 'The final exams for Grade 12 have been rescheduled to next Sunday.',
          type: 'students',
          grade: 'Grade 12',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        NotificationModel(
          id: 6,
          title: 'New Policy for Teachers',
          body: 'Please review the new attendance policy in the staff room.',
          type: 'teachers',
          grade: 'All Grades',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        NotificationModel(
          id: 7,
          title: 'Maintenance Alert',
          body: 'The school library will be closed for maintenance this weekend.',
          type: 'supervisor',
          grade: 'All Grades',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),NotificationModel(
          id: 8,
          title: 'Exam Schedule Update',
          body: 'The final exams for Grade 12 have been rescheduled to next Sunday.',
          type: 'students',
          grade: 'Grade 12',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        NotificationModel(
          id: 9,
          title: 'New Policy for Teachers',
          body: 'Please review the new attendance policy in the staff room.',
          type: 'teachers',
          grade: 'All Grades',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        NotificationModel(
          id: 10,
          title: 'Maintenance Alert',
          body: 'The school library will be closed for maintenance this weekend.',
          type: 'supervisor',
          grade: 'All Grades',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),NotificationModel(
          id: 11,
          title: 'Exam Schedule Update',
          body: 'The final exams for Grade 12 have been rescheduled to next Sunday.',
          type: 'students',
          grade: 'Grade 12',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        NotificationModel(
          id: 12,
          title: 'New Policy for Teachers',
          body: 'Please review the new attendance policy in the staff room.',
          type: 'teachers',
          grade: 'All Grades',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        NotificationModel(
          id: 13,
          title: 'Maintenance Alert',
          body: 'The school library will be closed for maintenance this weekend.',
          type: 'supervisor',
          grade: 'All Grades',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),NotificationModel(
          id: 14,
          title: 'Exam Schedule Update',
          body: 'The final exams for Grade 12 have been rescheduled to next Sunday.',
          type: 'students',
          grade: 'Grade 12',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        NotificationModel(
          id: 15,
          title: 'New Policy for Teachers',
          body: 'Please review the new attendance policy in the staff room.',
          type: 'teachers',
          grade: 'All Grades',
          isRead: false,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        NotificationModel(
          id: 16,
          title: 'Maintenance Alert',
          body: 'The school library will be closed for maintenance this weekend.',
          type: 'supervisor',
          grade: 'All Grades',
          isRead: true,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];

      // Update the list with mock data
      notificationsList.assignAll(mockData);




      //After link
      // final response = await http.get(
      //   Uri.parse(AppConstants.linkNotifications),
      //   headers: _headers,
      // );
      //
      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> json = jsonDecode(response.body);
      //   final List<dynamic> data = json['data'];
      //   notifications.value = data.map((e) => NotificationModel.fromJson(e)).toList();
      // } else {
      //   errorMessage.value = 'Error ${response.statusCode}';
      // }
    } catch (e) {
      errorMessage.value = 'Connection failed: $e';
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
      final response = await http.post(
        Uri.parse(AppConstants.linkPushNotifications),
        headers: _headers,
        body: jsonEncode({
          'title': subjectController.text.trim(),
          'body': bodyController.text.trim(),
          'type': selectedRecipient.value.toLowerCase(),
          'grade': selectedGrade.value,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _clearForm();
        await fetchNotifications();
        SnackbarHelper.showSuccess(title: "Success", message: "Notification sent successfully");
      } else {
        SnackbarHelper.showError(title: "Error", message: "Failed to send: ${response.statusCode}");
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Connection failed: $e");
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

