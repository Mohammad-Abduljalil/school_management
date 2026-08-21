import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Model/HomeModel/SideBarItem.dart';
import 'package:school_management/View/Home/StudentScheduleView/StudentScheduleView.dart';
import 'package:school_management/View/Home/Teacher/TeacherManagementScreen.dart';
import 'package:school_management/View/Home/User/UserManagementScreen.dart';

import '../../View/Home/AcademicManagement/AcademicManagementScreen.dart';
import '../../View/Home/AssignmentSubjectToTeacher/AssignmentSubjectToTeacherScreen.dart';
import '../../View/Home/Dashboard/DashboardScreen.dart';
import '../../View/Home/Marks/MarksScreen.dart';
import '../../View/Home/Notification/NotificationScreen/NotificationsScreen.dart';
import '../../View/Home/Salary/SalaryScreen/SalaryScreen.dart';
import '../../View/Home/Invoice/InvoiceScreen/InvoiceScreen.dart';
import '../../View/Home/Reports/ReportsScreen.dart';
import '../../View/Home/Setting/SettingScreen/SettingScreen.dart';
import '../../View/Home/Student/StudentManagementScreen.dart';
import '../../View/Home/Supervisor/SupervisorManagementScreen.dart';

class Navigationbarcontroller extends GetxController{

      RxInt selectedIndex = 0.obs;
      RxInt notificationIndex = 0.obs;


  
  final List<SidebarItem> itemsOfSideBar = [
     SidebarItem(label: 'Dashboard', icon: Icons.grid_view),
     SidebarItem(label: 'Users', icon: Icons.person),
     SidebarItem(label: 'Students', icon: Icons.person),
     SidebarItem(label: 'Teachers', icon: Icons.person),
     SidebarItem(label: 'Supervisor', icon: Icons.person),
     SidebarItem(label: 'Notifications', icon: Icons.notifications),
     SidebarItem(label: 'Invoice', icon: Icons.attach_money),
     SidebarItem(label: 'Salary', icon: Icons.payments),
     SidebarItem(label: 'Academic Management', icon: Icons.school),
     SidebarItem(label: 'Students Schedule', icon: Icons.schedule),
     SidebarItem(label: 'Teachers Schedule', icon: Icons.calendar_today),
     SidebarItem(label: 'Reports', icon: Icons.description),
     SidebarItem(label: 'Settings', icon: Icons.settings),
     SidebarItem(label: 'Marks', icon: Icons.edit_note),
  ];

  Widget buildPageContent() {
    switch (selectedIndex.value) {
      case 0:
        return DashboardScreen();
      case 1:
        return UserManagementScreen();
      case 2:
        return StudentManagementScreen();
      case 3:
        return TeacherManagementScreen();
      case 4:
        return SupervisorManagementScreen();
      case 5:
        notificationIndex=selectedIndex;
        return NotificationsScreen();
      case 6:
        return InvoiceScreen();
      case 7:
        return SalaryScreen();
      case 8:
        return AcademicManagementScreen();
      case 9:
        return ScheduleView();
      case 10:
        return AssignmentSubjectToTeacherScreen();
      case 11:
        return ReportsScreen();
      case 12:
        return SettingScreen();
      case 13:
        return MarksScreen();
      default:
        return Center(child: Text("nothing".tr));
    }
  }

}