import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:school_management/Custom/MyImageHelper.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/Custom/MyCustomConfirmDialog.dart';
import 'package:school_management/Model/HomeModel/UserModel.dart';

class DashboardDataSource extends DataGridSource {
  final List<UserModel> users;
  final Function(UserModel) onToggleStatus;
  final BuildContext context;

  DashboardDataSource({required this.users, required this.onToggleStatus, required this.context}) {
    _buildDataGridRows();
  }

  List<DataGridRow> _dataGridRows = [];

  void _buildDataGridRows() {
    _dataGridRows = users.map<DataGridRow>((t) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'identity', value: t),
        DataGridCell<String>(columnName: 'role', value: t.role),
        DataGridCell<String>(columnName: 'status', value: t.status == 1 ? "Approved" : "Pending"),
        DataGridCell<dynamic>(columnName: 'actions', value: t),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final t = row.getCells()[0].value;

    return DataGridRowAdapter(cells: [
      // identity
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            MyImageHelper.buildCircleAvatar(
              path: t?.profile_image,
              radius: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.full_name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: MyColors.primaryText)),
                  Text(t.email, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
      // role
      Container(
        alignment: Alignment.centerLeft,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: t.role == "STUDENT" ? const Color(0xFFDDE1FF) : t.role == "TEACHER" ? const Color(0xFFB0E4DD) : const Color(0xFFFEF0BD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("${t.role}",
                style: TextStyle(
                    color: t.role == "STUDENT" ? const Color(0xFF0732A3) : t.role == "TEACHER" ? const Color(0xFF007F6D) : const Color(0xFFD4A400),
                    fontWeight: FontWeight.bold,
                    fontSize: 10))),
      ),
      // status
      Container(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: t.status == 1 ? Colors.teal.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(t.status == 1 ? "ACTIVE" : "PENDING",
              style: TextStyle(
                  color: t.status == 0 ? Colors.grey : Colors.teal, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
      // Actions
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBtn(t.status == 1 ? "PENDING" : "ACTIVE", t.status == 1 ? Colors.red : Colors.teal, () async {
            bool confirmed = await MyCustomConfirmDialog().isConfermedDialog(context, "Are you sure?");
            if (confirmed) {
              onToggleStatus(t);
            }
          }),
        ],
      ),
    ]);
  }

  Widget _buildBtn(String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ),
    );
  }
}
