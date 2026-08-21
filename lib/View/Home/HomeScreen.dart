import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Controller/AuthController/LogoutController.dart';
import 'package:school_management/Controller/HomeController/NavigationbarController.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Services/SettingsService.dart';

import 'package:school_management/Custom/MyImageHelper.dart';

import '../../Controller/ProfileController/ProfileController.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  late final Navigationbarcontroller _navigationbarcontroller;
  late final ProfileController _profileController;
  late final LogoutController _logoutController;

  @override
  void initState() {
    super.initState();
    _navigationbarcontroller = Get.put(Navigationbarcontroller());
    _profileController = Get.put(ProfileController());
    _logoutController = Get.put(LogoutController(),permanent: true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.pageContentColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isSmallScreen = constraints.maxWidth < 800;
            return Row(
              children: [
                _buildSidebar(constraints, isSmallScreen),
                Expanded(child: _buildContentArea(constraints,isSmallScreen)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSidebar(BoxConstraints constraints, bool isSmallScreen) {
    double sidebarWidth = isSmallScreen ? 80 : (constraints.maxWidth > 1100 ? 280 : 240);
    return Container(
      width: sidebarWidth,
      color: MyColors.backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10 : 20, vertical: isSmallScreen ? 16 : 24),
      child: Column(
        children: [
          _buildBrand(isSmallScreen),
          SizedBox(height: isSmallScreen ? 20 : 30),
          Expanded(child: _buildMenuList(isSmallScreen)),
          SizedBox(height: isSmallScreen ? 10 : 20),
          if (!isSmallScreen) _buildContactCard(),
          SizedBox(height: isSmallScreen ? 8 : 16),
          _buildLogoutButton(isSmallScreen),
        ],
      ),
    );
  }
  //bran in top of SideBar
  Widget _buildBrand(bool isSmallScreen) {
    return isSmallScreen
        ? Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1E49),
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(AppConstants.logoPath, fit: BoxFit.cover,cacheWidth: 150,cacheHeight: 150,),
          )
        : ListTile(
            leading: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF0D1E49),
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(AppConstants.logoPath, fit: BoxFit.cover),
            ),
            title: Text(
              'SchoolMange'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'ADMIN PORTAL'.tr,
              style: const TextStyle(
                color: Color(0xFF8DA3E0),
                fontSize: 10,
                letterSpacing: 1.3,
              ),
            ),
          );
  }
  //Menu list of SideBar
  Widget _buildMenuList(bool isSmallScreen) {
    return ListView.separated(
        itemCount: _navigationbarcontroller.itemsOfSideBar.length,
        separatorBuilder: (_, __) => SizedBox(height: isSmallScreen ? 2 : 7),
        itemBuilder: (context, index) {
         return Obx((){
           final item = _navigationbarcontroller.itemsOfSideBar[index];
           final selected = index == _navigationbarcontroller.selectedIndex.value;

           return Material(
             color: selected ? MyColors.sidebarItemSelectedColor : Colors.transparent,
             borderRadius: BorderRadius.circular(12),
             child: InkWell(
               borderRadius: BorderRadius.circular(12),
               onTap: () => _navigationbarcontroller.selectedIndex.value= index,
               child: Padding(
                 padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 12, horizontal: isSmallScreen ? 8 : 14),
                 child: Row(
                   mainAxisAlignment: isSmallScreen ? MainAxisAlignment.center : MainAxisAlignment.start,
                   children: [
                     Icon(item.icon, color: selected ? Colors.white : MyColors.sidebarTextColor, size: isSmallScreen ? 24 : 20),
                     if (!isSmallScreen) ...[
                       const SizedBox(width: 12),
                       Expanded(
                         child: Text(
                           item.label.tr,
                           style: TextStyle(
                             color: selected ? Colors.white : MyColors.sidebarTextColor,
                             fontSize: 13,
                             fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                           ),
                         ),
                       ),
                       if (selected)
                         Container(
                           width: 4,
                           height: 20,
                           decoration: BoxDecoration(
                             color: const Color(0xFF00A991),
                             borderRadius: BorderRadius.circular(6),
                           ),
                         ),
                     ],
                   ],
                 ),
               ),
             ),
           );
         });
        },
    );
  }


  //To Contact card
  Widget _buildContactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.white10 : const Color(0xFF00A991),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact us'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get help with us, send massage about your problem.'.tr,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0D1E49),
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {},
            child: Text('Send Message'.tr),
          ),
        ],
      ),
    );
  }

  //To logOut
  Widget _buildLogoutButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC62828),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: Size.zero,
        ),
        icon: Icon(Icons.logout, size: isSmallScreen ? 18 : 20),
        label: isSmallScreen ? const SizedBox.shrink() : Text('Logout'.tr),
        onPressed: () {
            _logoutController.logout();
        },
      ),
    );
  }


  Widget _buildContentArea(BoxConstraints constraints,bool isSmallScreen) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      // padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx((){
                  if(_profileController.isLoading.value){
                    return const CircularProgressIndicator();
                  }
                  else{
                    var user=_profileController.profileModel.value;
                    print("user : $user");
                    return Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              MyImageHelper.buildCircleAvatar(
                                path: user?.profile_image,
                                radius: 25,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    user?.full_name ?? 'Admin User',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.primaryText,
                                    ),
                                  ),
                                  Text(
                                    user?.email ?? 'Admin Email',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              _buildTopAction(Icons.notifications, 'Notifications'.tr,isSmallScreen,(){
                                _navigationbarcontroller.selectedIndex.value=_navigationbarcontroller.notificationIndex.value;
                              }),
                              SizedBox(width: 12,),
                              _buildTopAction(Icons.date_range_outlined, "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",isSmallScreen,(){})
                            ]
                          ),
                        ],
                      ),
                    );
                  }
                })
              ],
            ),
          ),
          const SizedBox(height: 0),
          Obx(()=>Expanded(child: _navigationbarcontroller.buildPageContent())),
        ],
      ),
    );
  }

  Widget _buildTopAction(IconData icon, String label,bool isSmallScreen,void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: isSmallScreen ? Row(
          children: [
            Icon(icon, color: const Color(0xFF3755C3), size: 20),
          ],
         )
            :
          Row(
            children: [
            Icon(icon, color: const Color(0xFF3755C3), size: 20),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(color: MyColors.primaryText)),
                ],
            ),
      ),
    );
  }

  

  Widget _buildPlaceholderPage(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF0D1E49),
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }



  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
              const SizedBox(height: 10),
              Text(value, style: const TextStyle(color: Color(0xFF0D1E49), fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFE6F7F0),
            child: Icon(icon, color: const Color(0xFF00A991), size: 28),
          ),
        ],
      ),
    );
  }
}


