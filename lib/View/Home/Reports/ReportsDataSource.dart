import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../Controller/HomeController/ReportsController/ReportsController.dart';
import '../../../Model/HomeModel/ReportModel.dart';

class ReportsDataSource extends DataGridSource {
  final List<ReportModel> reportsList;
  final BuildContext context;

  List<DataGridRow> _dataGridRows = [];

  ReportsDataSource({required this.reportsList, required this.context}) {
    _buildDataGridRows();
  }

  void _buildDataGridRows() {
    _dataGridRows = reportsList.map<DataGridRow>((r) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: r.id),
        DataGridCell<String>(columnName: 'type', value: r.type.tr),
        DataGridCell<String>(columnName: 'stage', value: (r.studyStageName ?? 'All Stages').tr),
        DataGridCell<String>(columnName: 'section', value: (r.sectionName ?? 'All Sections').tr),
        DataGridCell<String>(columnName: 'range', value: "${r.startDate.day}/${r.startDate.month} - ${r.endDate.day}/${r.endDate.month}"),
        DataGridCell<ReportModel>(columnName: 'actions', value: r),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final ReportModel r = row.getCells().last.value;

    return DataGridRowAdapter(cells: [
        _buildCell(r.id.toString()),
        _buildCell(r.type.tr),
        _buildCell((r.studyStageName ?? 'All Stages'.tr).tr),
        _buildCell((r.sectionName ?? 'All Sections'.tr).tr),
        _buildCell("${r.startDate.day}/${r.startDate.month}/${r.startDate.year}"),
      
      // Actions
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => Get.find<ReportsController>().downloadReport(r.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A99D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.download, size: 16),
              label: Text("Download".tr, style: const TextStyle(fontSize: 11)),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildCell(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
