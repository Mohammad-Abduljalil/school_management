import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:school_management/Controller/HomeController/DashboardController/DashboardController.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'DashboardDataSource.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
  class  _DashboardScreenState extends State<DashboardScreen>{

  final _dashboardController=Get.put(Dashboardcontroller());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(),
            const SizedBox(height: 30),
            _buildSummaryCards(),
            const SizedBox(height: 30),
            _buildChartsSection(),
            const SizedBox(height: 30),
            _buildBottomSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome User let's start,".tr,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: MyColors.backgroundColor),
        ),
        Text(
          "Dashboard brief information about the system.".tr,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Obx(() => Row(
      children: [
        _buildTopStatCard("Students".tr, "${_dashboardController.numOfStudents.value}", Icons.people, const Color(0xFFC7D2FE), const Color(0xFF1C3486)),
        const SizedBox(width: 20),
        _buildTopStatCard("Teachers".tr, "${_dashboardController.numOfTeachers.value}", Icons.school, const Color(0xFFA7F3D0), const Color(0xFF00A99D)),
        const SizedBox(width: 20),
        _buildTopStatCard("Supervisor".tr, "${_dashboardController.numOfSupervisor.value}", Icons.security, const Color(0xFFFEF3C7), const Color(0xFFFFD54F)),
        const SizedBox(width: 20),
        _buildTopStatCard("Classes".tr, "${_dashboardController.numOfClasses.value}", Icons.class_, const Color(0xFFFECACA), const Color(0xFFEF4444)),
      ],
    ));
  }

  Widget _buildTopStatCard(String title, String value, IconData icon, Color bg, Color iconBg) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? bg.withOpacity(0.1) : bg, 
          borderRadius: BorderRadius.circular(15)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyColors.primaryText)),
                ],
              ),
            ),
            _dashboardController.isLoading.value
              ? const CircularProgressIndicator()
              : Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: MyColors.primaryText)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection() {
    return Row(
      children: [
        Expanded(child: _buildChartContainer("Students type".tr, _buildBarChart())),
        const SizedBox(width: 20),
        Expanded(child: _buildChartContainer("Students Registers".tr, _buildLineChart())),
      ],
    );
  }

  Widget _buildChartContainer(String title, Widget chart) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(child: chart),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table (takes more space)
        Expanded(
          flex: 2,
          child: Obx((){

            if (_dashboardController.isLoading.value && _dashboardController.users.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!_dashboardController.isLoading.value && _dashboardController.users.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                    Text("No users found".tr),
                    TextButton(
                      onPressed: () => _dashboardController.fetchUsers(),
                      child: Text("Refresh".tr),
                    )
                  ],
                ),
              );
            }

            final dataSource = DashboardDataSource(
              users: _dashboardController.users,
              onToggleStatus: (user) {
                _dashboardController.toggleAcceptStatus(user);
              },
              context: context,
            );
              return Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  // Table header taken from your previous SfDataGrid design
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
                                  GridColumn(columnName: 'identity',width: 280,label: _buildLabel('Identity'.tr)),
                                  GridColumn(columnName: 'role', width: 170, label: _buildLabel('Role'.tr)),
                                  GridColumn(columnName: 'status', width: 160, label: _buildLabel('Status'.tr)),
                                  GridColumn(columnName: 'actions', width: 300, label: _buildLabel('Actions'.tr)),
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
                  // You can place SfDataGrid here as we did in previous responses
                ],
              ),
            );},
          ),
        ),
        const SizedBox(width: 20),
        // Sidebar chart statistics list
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Fees Statistics".tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 25),
                _buildFinanceRow("pay".tr, "300 Student", Colors.green, 0.7),
                const SizedBox(height: 20),
                _buildFinanceRow("not pay".tr, "100 Student", Colors.redAccent, 0.3),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Get.isDarkMode ? Colors.white10 : const Color(0xFFF0F5F9), borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "73% of total tuition fees for the current semester have been collected. An estimated amount remains.".tr,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 12, height: 1.5),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text("Go to finance".tr),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinanceRow(String label, String value, Color color, double percent) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Row(children: [Icon(Icons.payment, color: color, size: 18), const SizedBox(width: 10), Expanded(child: Text(label))])),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(value: percent, color: color, backgroundColor: color.withOpacity(0.1), minHeight: 8),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPagination(DashboardDataSource source) {
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
            "${"Page".tr} ${_dashboardController.currentUsersPage.value} ${"of".tr} ${_dashboardController.totalUsersPages.value}",
            style: const TextStyle(color: Colors.white, fontSize: 13),
          )),
          SfDataPager(
            delegate: source,
            pageCount: _dashboardController.totalUsersPages.value.toDouble(),
            direction: Axis.horizontal,
            onPageNavigationStart: (pageIndex){
              _dashboardController.fetchUsers(page: pageIndex+1);
            },
          ),
        ],
      ),
    );
  }


  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        barGroups: List.generate(10, (i) => BarChartGroupData(x: i, barRods: [BarChartRodData(toY: (i + 3) * 2, color: const Color(0xFF818CF8), width: 12)])),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true, drawVerticalLine: false),
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: const [FlSpot(0, 3), FlSpot(2, 5), FlSpot(4, 3), FlSpot(6, 4), FlSpot(8, 2), FlSpot(10, 6)],
            color: const Color(0xFF818CF8),
            belowBarData: BarAreaData(show: true, color: const Color(0xFF818CF8).withOpacity(0.2)),
          )
        ],
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true, drawVerticalLine: false),
      ),
    );
  }


}