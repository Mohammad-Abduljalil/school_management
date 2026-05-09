import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_management/Controller/AuthController/LogoutController.dart';
import 'package:school_management/Controller/HomeController/NavigationbarController.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/core/AppConstants.dart';

import '../../Controller/ProfileController/ProfileController.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  final Navigationbarcontroller _navigationbarcontroller=Get.put(Navigationbarcontroller());
  final ProfileController _profileController=Get.put(ProfileController());
  final LogoutController _logoutController=Get.put(LogoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isSmallScreen = constraints.maxWidth < 800;
            return Row(
              children: [
                _buildSidebar(constraints, isSmallScreen),
                Expanded(child: _buildContentArea(constraints)),
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
            child: Image.asset(AppConstants.logoPath, fit: BoxFit.cover),
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
              'SchoolMange',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'ADMIN PORTAL',
              style: TextStyle(
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
             color: selected ? const Color(0xFF0C3A75) : Colors.transparent,
             borderRadius: BorderRadius.circular(12),
             child: InkWell(
               borderRadius: BorderRadius.circular(12),
               onTap: () => _navigationbarcontroller.selectedIndex.value= index,
               child: Padding(
                 padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 12, horizontal: isSmallScreen ? 8 : 14),
                 child: Row(
                   mainAxisAlignment: isSmallScreen ? MainAxisAlignment.center : MainAxisAlignment.start,
                   children: [
                     Icon(item.icon, color: selected ? Colors.white : const Color(0xFF8DA3E0), size: isSmallScreen ? 24 : 20),
                     if (!isSmallScreen) ...[
                       const SizedBox(width: 12),
                       Expanded(
                         child: Text(
                           item.label,
                           style: TextStyle(
                             color: selected ? Colors.white : const Color(0xFFB5C1F5),
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
        color: const Color(0xFF00A991),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact us',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Get help with us, send massage about your problem.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
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
            child: const Text('Send Message'),
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
        label: isSmallScreen ? const SizedBox.shrink() : const Text('Logout'),
        onPressed: () {
            _logoutController.logout();
        },
      ),
    );
  }


  Widget _buildContentArea(BoxConstraints constraints) {
    return Container(
      color: const Color(0xFFF5F7FF),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx((){
                if(_profileController.isLoading.value){
                  return const CircularProgressIndicator();
                }else{
                  var user=_profileController.userModel.value;
                  return Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: (user?.personalImage != null && user!.personalImage!.startsWith('http'))
                                  ? NetworkImage(user.personalImage!)
                                  : null,
                              child: (user?.personalImage == null)
                                  ? const Icon(Icons.person, color: Colors.grey)
                                  : (user!.personalImage!.startsWith('http')
                                  ? null
                                  : Image.asset(
                                user.personalImage!,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                              )),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  user?.fullName ?? 'Admin User',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0D1E49),
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
                            _buildTopAction(Icons.notifications, 'Notifications',(){}),
                            SizedBox(width: 12,),
                            _buildTopAction(Icons.date_range_outlined, "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",(){})
                          ]
                        ),
                      ],
                    ),
                  );
                }
              })
            ],
          ),
          const SizedBox(height: 24),
          Obx(()=>Expanded(child: _navigationbarcontroller.buildPageContent())),
        ],
      ),
    );
  }

  Widget _buildTopAction(IconData icon, String label,void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF3755C3), size: 20),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Color(0xFF0D1E49))),
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

  Widget _buildDashboardPage() {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.6,
      ),
      children: [
        _buildInfoCard('Total Students', '1,240', Icons.groups),
        _buildInfoCard('New Users', '84', Icons.person_add),
        _buildInfoCard('Today Fees', '\$12,800', Icons.attach_money),
        _buildInfoCard('Pending Exams', '24', Icons.event_note),
      ],
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


