import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../../Controller/HomeController/ReportsController/ReportsController.dart';
import '../../../Custom/MyCustomTextFields.dart';
import '../../../Custom/MyColors.dart';
import 'ReportsDataSource.dart';

class ReportsScreen extends StatefulWidget {
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ReportsController _controller = Get.put(ReportsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (_controller.isLoading.value && _controller.reports.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_controller.isLoading.value && _controller.reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.description_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text("No reports available yet".tr, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => _controller.fetchReports(),
                    child: Text("Refresh List".tr),
                  )
                ],
              ),
            );
          }

          final dataSource = ReportsDataSource(
            reportsList: _controller.reports,
            context: context,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildSearchArea(),
                const SizedBox(height: 30),
                
                // Reports Table
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 500,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          child: SfDataGridTheme(
                            data: SfDataGridThemeData(
                              headerColor: MyColors.backgroundColor,
                            ),
                            child: SfDataGrid(
                              source: dataSource,
                              rowHeight: 60,
                              headerRowHeight: 50,
                              columnWidthMode: ColumnWidthMode.fill,
                              gridLinesVisibility: GridLinesVisibility.none,
                              headerGridLinesVisibility: GridLinesVisibility.none,
                              columns: [
                                GridColumn(columnName: 'id', label: _buildLabel('ID'.tr)),
                                GridColumn(columnName: 'type', label: _buildLabel('Type'.tr)),
                                GridColumn(columnName: 'stage', label: _buildLabel('Stage'.tr)),
                                GridColumn(columnName: 'section', label: _buildLabel('Section'.tr)),
                                GridColumn(columnName: 'date', label: _buildLabel('Date'.tr)),
                                GridColumn(columnName: 'actions', label: _buildLabel('Actions'.tr)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _buildPagination(dataSource),
                    ],
                  ),
                ),
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
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "School Reports".tr,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: MyColors.primaryText),
        ),
        const SizedBox(height: 8),
        Text(
          "View and download academic and administrative reports.".tr,
          style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildSearchArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Search Reports".tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 15),
          TextField(
            onChanged: (val) => _controller.searchByType(val),
            style: TextStyle(color: MyColors.primaryText),
            decoration: InputDecoration(
              hintText: "Search by report type...".tr,
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(ReportsDataSource source) {
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
            "${"Page".tr} ${_controller.currentReportsPage.value} ${"of".tr} ${_controller.totalReportsPages.value}",
            style: const TextStyle(color: Colors.white, fontSize: 13),
          )),
          SfDataPager(
            delegate: source,
            pageCount: _controller.totalReportsPages.value.toDouble(),
            direction: Axis.horizontal,
            onPageNavigationStart: (pageIndex) {
              _controller.fetchReports(page: pageIndex + 1);
            },
          ),
        ],
      ),
    );
  }
}
