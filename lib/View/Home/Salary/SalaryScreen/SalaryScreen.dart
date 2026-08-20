import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../../../Custom/MyCustomTextFields.dart';
import '../../../../Custom/MyColors.dart';
import '../SalaryDataSource/SalaryDataSource.dart';
import '../../../../Controller/HomeController/SalaryController/SalaryController.dart';

class SalaryScreen extends StatefulWidget {
  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {

  final SalaryController _salaryController = Get.put(SalaryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (_salaryController.isLoading.value && _salaryController.displayedUsers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!_salaryController.isLoading.value && _salaryController.displayedUsers.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Icon(Icons.person_off, size: 80, color: Colors.grey),
                  const Text("No members found for this role."),
                  TextButton(onPressed: () => _salaryController.fetchSalaries(), child: Text("Retry"))
                ],
              ),
            );
          }
          //declare the schedule
          final dataSource = SalaryDataSource(
            teachers: _salaryController.displayedUsers,
            onToggleStatus: (teacher) {
              _salaryController.togglePaymentStatus(teacher);
            },
            context: context,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 25),
                //Filter Section
                _buildFilterSection(),
                const SizedBox(height: 40),

                // Container of The Schedule
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      // Circular to reference that data is loading
                      if (_salaryController.isLoading.value)
                        const LinearProgressIndicator(minHeight: 2, color: Color(0xFF00A99D)),
                      // The Schedule
                      SizedBox(
                        height: 580,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          child: SfDataGridTheme(
                            data: SfDataGridThemeData(
                              headerColor: MyColors.backgroundColor,
                            ),
                            child: SfDataGrid(
                              source: dataSource,
                              rowHeight: 52,
                              headerRowHeight: 50,
                              columnWidthMode: ColumnWidthMode.fill,
                              gridLinesVisibility: GridLinesVisibility.none,
                              headerGridLinesVisibility: GridLinesVisibility.none,
                              columns: [
                                GridColumn(columnName: 'identity', label: _buildLabel('Identity')),
                                GridColumn(columnName: 'phone', label: _buildLabel('Phone')),
                                GridColumn(columnName: 'salary', label: _buildLabel('Salary')),
                                GridColumn(columnName: 'status', label: _buildLabel('Status')),
                                GridColumn(columnName: 'actions', label: _buildLabel('Actions')),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Pagination of The Schedule
                      _buildPagination(dataSource),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
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

  // The Pagination
  Widget _buildPagination(SalaryDataSource source) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFF00A99D),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // widgets in pagination section
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // details about the pagination from the server
          Text(
            "Page ${_salaryController.currentSalaryPage.value} of ${_salaryController.totalSalaryPages.value} (${_salaryController.totalSalaryItems.value} members)",
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          // to transform between the pages
          SfDataPager(
            delegate: source,
            // total salary pages
            pageCount: _salaryController.totalSalaryPages.value.toDouble(),
            direction: Axis.horizontal,
            // to fetch data for the next page
            onPageNavigationStart: (int pageIndex) {
              _salaryController.fetchSalaries(page: pageIndex + 1);
            },
          ),
        ],
      ),
    );
  }

  //Header Section of The Screen
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome User let's start,", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: MyColors.primaryText)),
        const SizedBox(height: 8),
        Text("Dashboard brief information about the system.", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF545455))),
      ],
    );
  }

  //Filter Section of The Screen
  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          //Search TextField
          MyCustomTextField(controller: _salaryController.searchEditingController, hintText: "Search by name",
            onChanged: (value){
              _salaryController.searchByName(value);
              },
          ),
          const SizedBox(height: 10),
          //The Filtering By Buttons
          Row(
            children: [
              // Label before Buttons
              const Text("Show Data For: ", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 15),
              // First Button
              _filterButton("Teachers", "teacher"),
              const SizedBox(width: 10),
              //Second Buttons
              _filterButton("Admins", "admin"),
            ],
          ),
        ],
      ),
    );
  }


  // Filter Button
  Widget _filterButton(String title, String role) {
    return Obx(() {
      bool isSelected = _salaryController.selectedRole.value == role;
      return ElevatedButton(
        onPressed: () {
          _salaryController.changeRoleAndFetch(role);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? MyColors.backgroundColor : Theme.of(context).cardColor,
          foregroundColor: isSelected ? Colors.white : MyColors.backgroundColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: MyColors.backgroundColor),
        ),
        child: Text(title),
      );
    });
  }
}