import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Model/HomeModel/SideBarItem.dart';

class Navigationbarcontroller extends GetxController{

      RxInt selectedIndex = 0.obs;


  
  final List<SidebarItem> itemsOfSideBar = [
     SidebarItem(label: 'Dashboard', icon: Icons.grid_view),
     SidebarItem(label: 'Users', icon: Icons.person),
     SidebarItem(label: 'Notifications', icon: Icons.notifications),
     SidebarItem(label: 'Fess', icon: Icons.attach_money),
     SidebarItem(label: 'Salary', icon: Icons.payments),
     SidebarItem(label: 'Academic Management', icon: Icons.school),
     SidebarItem(label: 'Students Schedule', icon: Icons.schedule),
     SidebarItem(label: 'Teachers Schedule', icon: Icons.calendar_today),
     SidebarItem(label: 'Settings', icon: Icons.settings),
     SidebarItem(label: 'Marks', icon: Icons.edit_note),
  ];

  Widget buildPageContent() {
    switch (selectedIndex.value) {
      case 0:
        return Center(child: Text('Dashboard'));
      case 1:
        return Center(child: Text('Users Management'));
      case 2:
        return Center(child: Text('Notifications'));
      case 3:
        return Center(child: Text('Fess'));
      case 4:
        return Center(child: Text('Salary'));
      case 5:
        return Center(child: Text('Academic Management'));
      case 6:
        return Center(child: Text('Students Schedule'));
      case 7:
        return Center(child: Text('Teachers Schedule'));
      case 8:
        return Center(child: Text('Settings'));
      case 9:
        return Center(child: Text('Marks'));
      default:
        return Center(child: Text("nothing"));
    }
  }

}