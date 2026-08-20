import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Controller/HomeController/TeachersManagementController/TeachersManagementController.dart';
import 'package:school_management/View/Home/Teacher/TeacherDataSource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../../Custom/MyCustomTextFields.dart';
import '../../../Custom/MyColors.dart';

class TeacherManagementScreen extends StatefulWidget {
  @override
  State<TeacherManagementScreen> createState() => _TeacherManagementScreenState();
}

class _TeacherManagementScreenState extends State<TeacherManagementScreen> {
  final  _teachersManagementController = Get.put(TeachersManagementController());
  final double _rowsPerPage = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (_teachersManagementController.isLoading.value && _teachersManagementController.teachers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_teachersManagementController.isLoading.value && _teachersManagementController.teachers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  const Text("No users found"),
                  TextButton(
                    onPressed: () => _teachersManagementController.fetchTeachers(),
                    child: const Text("Refresh"),
                  )
                ],
              ),
            );
          }

          final dataSource = TeacherDataSource(
            teachers: _teachersManagementController.teachers,
            onToggleStatus: (teacher) {
              _teachersManagementController.toggleAcceptStatus(teacher);
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
                                GridColumn(columnName: 'identity',label: _buildLabel('Identity')),
                                GridColumn(columnName: 'phone' , label: _buildLabel('Phone')),
                                GridColumn(columnName: 'id' , label: _buildLabel('Id')),
                                GridColumn(columnName: 'salary' , label: _buildLabel('Salary')),
                                GridColumn(columnName: 'status' , label: _buildLabel('Status')),
                                GridColumn(columnName: 'actions' , label: _buildLabel('Actions')),
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

  Widget _buildPagination(TeacherDataSource source) {
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
            "Page ${_teachersManagementController.currentTeachersPage.value} of ${_teachersManagementController.totalTeachersPages.value}",
            style: const TextStyle(color: Colors.white, fontSize: 13),
          )),
          SfDataPager(
            delegate: source,
            pageCount: _teachersManagementController.totalTeachersPages.value.toDouble(),
            direction: Axis.horizontal,
            onPageNavigationStart: (pageIndex){
              _teachersManagementController.fetchTeachers(page: pageIndex+1);
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
              "Orchestrate your educational community. Manage permissions, monitor\nfinancial standings, and streamline communication for staff and teachers",
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
              "Teachers",
              "${_teachersManagementController.numOfTeachers.value}",
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
          MyCustomTextField(controller: _teachersManagementController.searchEditingController, hintText: "Search by student name...",onChanged: (value){
            _teachersManagementController.searchByName(value);
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
    final controller = Get.find<TeachersManagementController>();
    return Obx(() => Row(
      children: [
        _filterButton(
          label: "All Students",
          isSelected: !controller.isShowingPending.value,
          onTap: () => controller.fetchTeachers(onlyPending: false),
          icon: Icons.group,
        ),
        const SizedBox(width: 15),
        _filterButton(
          label: "Pending Students",
          isSelected: controller.isShowingPending.value,
          onTap: () => controller.fetchTeachers(onlyPending: true),
          icon: Icons.pending_actions,
          count: controller.isShowingPending.value ? controller.teachers.length : null,
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