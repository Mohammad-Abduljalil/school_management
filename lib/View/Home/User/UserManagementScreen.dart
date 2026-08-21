import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../../Controller/HomeController/UserManagementController/UserManagementController.dart';
import '../../../Custom/MyCustomTextFields.dart';
import '../../../Custom/MyColors.dart';
import 'UserDataSource.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  State<UserManagementScreen> createState() => _UsermanagementScreenState();
}

class _UsermanagementScreenState extends State<UserManagementScreen> {
  final  _userManagementController = Get.put(UserManagementController());
  final double _rowsPerPage = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (_userManagementController.isLoading.value && _userManagementController.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

            if (!_userManagementController.isLoading.value && _userManagementController.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  Text("No users found".tr),
                  TextButton(
                    onPressed: () => _userManagementController.fetchUsers(),
                    child: Text("Refresh".tr),
                  )
                ],
              ),
            );
          }

          final dataSource = UserDataSource(
            users: _userManagementController.users,
            onToggleStatus: (user) {
              _userManagementController.toggleAcceptStatus(user);
              print(user.status);
            },
            context: context,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 25),
                _buildFilterSection(),
                const SizedBox(height: 40),

                // Table container
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 500, // Appropriate height for 8 rows + header
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          child: SfDataGridTheme(
                            data: SfDataGridThemeData(
                              headerColor: MyColors.backgroundColor,
                            ),
                            child: SfDataGrid(
                              source: dataSource,
                              rowHeight: 55,
                              headerRowHeight: 50,
                              columnWidthMode: ColumnWidthMode.fill,
                              gridLinesVisibility: GridLinesVisibility.none,
                              headerGridLinesVisibility: GridLinesVisibility.none,
                              onColumnResizeUpdate: (ColumnResizeUpdateDetails details){
                                return true;
                              },
                              columns: [
                                GridColumn(columnName: 'identity',
                                    // width: 280,
                                    label: _buildLabel('Identity'.tr)),
                                GridColumn(columnName: 'phone',
                                    // width: 180,
                                    label: _buildLabel('Phone'.tr)),
                                GridColumn(columnName: 'id',
                                    // width: 140,
                                    label: _buildLabel('Id'.tr)),
                                GridColumn(columnName: 'role',
                                    // width: 170,
                                    label: _buildLabel('Role'.tr)),
                                GridColumn(columnName: 'status',
                                    // width: 160,
                                    label: _buildLabel('Status'.tr)),
                                GridColumn(columnName: 'actions',
                                    // width: 300,
                                    label: _buildLabel('Actions'.tr)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Green footer (Pagination)
                      _buildPagination(dataSource),
                    ],
                  ),
                ),
                SizedBox(height: 80,),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPagination(UserDataSource source) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFF00A99D),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Text(
            "${"Page".tr} ${_userManagementController.currentUsersPage.value} ${"of".tr} ${_userManagementController.totalUsersPages.value}",
            style: const TextStyle(color: Colors.white, fontSize: 13),
          )),
          SfDataPager(
            delegate: source,
            pageCount: _userManagementController.totalUsersPages.value.toDouble(),
            direction: Axis.horizontal,
            onPageNavigationStart: (pageIndex){
              _userManagementController.fetchUsers(page: pageIndex+1);
            },
          ),
        ],
      ),
    );
  }


  Widget _buildHeader() {return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Left Section: Title and Description
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User Management".tr,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: MyColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Orchestrate your educational community. Manage permissions, monitor\nfinancial standings, and streamline communication for staff and students".tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF545455),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),

      // Right Section: White Statistics Container
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildStatCard(
              "Students".tr,
              "${_userManagementController.numOfStudents.value}",
              Icons.person,
              const Color(0xFFC7D2FE),
              const Color(0xFF1C3486),
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              "Teachers".tr,
              "${_userManagementController.numOfTeachers.value}",
              Icons.school,
              const Color(0xFFA7F3D0),
              const Color(0xFF00A99D),
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              "Supervisor".tr,
              "${_userManagementController.numOfSupervisor.value}",
              Icons.admin_panel_settings,
              const Color(0xFFFEF3C7), // Light yellow card background
              const Color(0xFFFFD54F), // Icon color
            ),
          ],
        ),
      ),
    ],
  );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF1A2533),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _userManagementController.isLoading.value?const CircularProgressIndicator():Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),

        ],
      ),
    );
  }




  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          MyCustomTextField(controller: _userManagementController.searchEditingController, hintText: "Search by student name...".tr,onChanged: (value){
            _userManagementController.searchByName(value);
          },),
          const SizedBox(height: 10,),
          Row(
            children: [
              Text("Show Data For: ".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 15),
              _buildFilterButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    final controller = Get.find<UserManagementController>();
    return Obx(() => Row(
      children: [
        _filterButton(
          label: "All Users".tr,
          isSelected: !controller.isShowingPending.value,
          onTap: () => controller.fetchUsers(onlyPending: false),
          icon: Icons.group,
        ),
        const SizedBox(width: 15),
        _filterButton(
          label: "Pending Users".tr,
          isSelected: controller.isShowingPending.value,
          onTap: () => controller.fetchUsers(onlyPending: true),
          icon: Icons.pending_actions,
          count: controller.isShowingPending.value ? controller.users.length : null,
        ),
      ],
    ));
  }

    Widget _filterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
    int? count
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? MyColors.backgroundColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: MyColors.backgroundColor),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black12, blurRadius: 5)] : [],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : MyColors.backgroundColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : MyColors.backgroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Text("$count", style: const TextStyle(color: Colors.white, fontSize: 10)),
              )
            ]
          ],
        ),
      ),
    );
  }


}