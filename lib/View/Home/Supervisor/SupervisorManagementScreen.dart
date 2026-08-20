import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Controller/HomeController/SupervisorsManagementController/SupervisorsManagementController.dart';
import 'package:school_management/View/Home/Supervisor/SupervisorDataSource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../../Controller/HomeController/UserManagementController/UserManagementController.dart';
import '../../../Custom/MyCustomTextFields.dart';
import '../../../Custom/MyColors.dart';

class SupervisorManagementScreen extends StatefulWidget {
  @override
  State<SupervisorManagementScreen> createState() => _SupervisorManagementScreenState();
}

class _SupervisorManagementScreenState extends State<SupervisorManagementScreen> {
  final  _supervisorsManagementController = Get.put(SupervisorsManagementController());
  final double _rowsPerPage = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (_supervisorsManagementController.isLoading.value && _supervisorsManagementController.supervisors.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_supervisorsManagementController.isLoading.value && _supervisorsManagementController.supervisors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  const Text("No users found"),
                  TextButton(
                    onPressed: () => _supervisorsManagementController.fetchSupervisors(),
                    child: const Text("Refresh"),
                  )
                ],
              ),
            );
          }

          final dataSource = SupervisorDataSource(
            supervisor: _supervisorsManagementController.supervisors,
            onToggleStatus: (supervisor) {
              _supervisorsManagementController.toggleAcceptStatus(supervisor);
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
                              // This property is responsible for filling the space
                              columnWidthMode: ColumnWidthMode.fill,
                              gridLinesVisibility: GridLinesVisibility.none,
                              headerGridLinesVisibility: GridLinesVisibility.none,
                              onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                                return true;
                              },
                              columns: [
                                GridColumn(
                                  columnName: 'identity',
                                  label: _buildLabel('Identity'),
                                ),
                                GridColumn(
                                  columnName: 'phone',
                                  label: _buildLabel('Phone'),
                                ),
                                GridColumn(
                                  columnName: 'id',
                                  label: _buildLabel('Id'),
                                ),
                                GridColumn(
                                  columnName: 'role',
                                  label: _buildLabel('Role'),
                                ),
                                GridColumn(
                                  columnName: 'status',
                                  label: _buildLabel('Status'),
                                ),
                                GridColumn(
                                  columnName: 'actions',
                                  label: _buildLabel('Actions'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildPagination(SupervisorDataSource source) {
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
            "Page ${_supervisorsManagementController.currentSupervisorsPage.value} of ${_supervisorsManagementController.totalSupervisorsPages.value}",
            style: const TextStyle(color: Colors.white, fontSize: 13),
          )),
          SfDataPager(
            delegate: source,
            pageCount: _supervisorsManagementController.totalSupervisorsPages.value.toDouble(),
            direction: Axis.horizontal,
            onPageNavigationStart: (pageIndex){
              _supervisorsManagementController.fetchSupervisors(page: pageIndex+1);
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
              "User Management",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: MyColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Orchestrate your educational community. Manage permissions, monitor\nfinancial standings, and streamline communication for staff and Supervisors",
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
              "Supervisors",
              "${_supervisorsManagementController.numOfSupervisors.value}",
              Icons.person,
              const Color(0xFFC7D2FE),
              const Color(0xFF1C3486),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    ],
  );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 150,
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
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A2533),
            ),
          ),
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
          MyCustomTextField(controller: _supervisorsManagementController.searchEditingController, hintText: "Search by student name...",onChanged: (value){
            _supervisorsManagementController.searchByName(value);
          },),
          SizedBox(height: 10,),
          Row(
            children: [
              const Text("Show Data For: ", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 15),
              _buildFilterButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    final controller = Get.find<SupervisorsManagementController>();
    return Obx(() => Row(
      children: [
        // Button to display all users
        _filterButton(
          label: "All Users",
          isSelected: !controller.isShowingPending.value,
          onTap: () => controller.fetchSupervisors(onlyPending: false),
          icon: Icons.group,
        ),
        const SizedBox(width: 15),
        // Button to display only pending users
        _filterButton(
          label: "Pending Users",
          isSelected: controller.isShowingPending.value,
          onTap: () => controller.fetchSupervisors(onlyPending: true),
          icon: Icons.pending_actions,
          count: controller.isShowingPending.value ? controller.supervisors.length : null,
        ),
      ],
    ));
  }

// Custom button widget
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