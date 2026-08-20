import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_management/Controller/HomeController/SalaryController/SalaryController.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../Custom/MyCustomConfirmDialog.dart';
import '../../../../Model/HomeModel/SalaryModel.dart';

class SalaryDataSource extends DataGridSource {
  final List<SalaryModel> teachers;
  final Function(SalaryModel) onToggleStatus;
  BuildContext context;
  SalaryController _salaryController=Get.find<SalaryController>();

  // List of the schedule rows
  List<DataGridRow> _dataGridRows = [];

  SalaryDataSource({required this.teachers, required this.onToggleStatus,required this.context}) {
    _buildDataGridRows();
  }

  // declare rows of the schedule
  void _buildDataGridRows() {
    _dataGridRows = teachers.map<DataGridRow>((t) {
      return DataGridRow(cells: [
        DataGridCell<SalaryModel>(columnName: 'identity', value: t),
        DataGridCell<String>(columnName: 'phone', value: t.phone),
        DataGridCell<String>(columnName: 'salary', value: t.salary),
        DataGridCell<String>(columnName: 'status', value: t.status==1?"PAID":"UNPAID"),
        DataGridCell<SalaryModel>(columnName: 'actions', value: t),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    // extract the model of the first grid
    final SalaryModel t = row.getCells()[0].value;

    return DataGridRowAdapter(cells: [
      //identity
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            //the image
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF1C3486).withOpacity(0.1),
              child: const Icon(Icons.person, size: 20, color: Color(0xFF1C3486)),
            ),
            const SizedBox(width: 12),
            //name and email
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name
                  Text(
                    t.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // email
                  Text(
                    t.email,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // phone
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(t.phone, style: const TextStyle(fontSize: 13)),
      ),

      // salary
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          "${t.salary} \$",
          style: const TextStyle(color: Color(0xFF00A99D), fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),

      // status
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: t.status == 1 ? const Color(0xFFE6F4F1) : const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            t.status == 1 ? "PAID" : "NOT PAID",
            style: TextStyle(
              color: t.status == 1 ? const Color(0xFF00A99D) : Colors.grey[600],
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      // Actions
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _actionButton("Change", const Color(0xFF1C3486), () {
              showUpdateSalaryDialog(Get.context!, t, t.id);
            }),
            const SizedBox(width: 6),
            _actionButton(
              t.status == 1 ? "UNPAID" : "PAID",
              t.status == 1 ? Colors.redAccent : const Color(0xFF00A99D),
                  () async {
                    // To if confirm the action
                    bool confirmed = await MyCustomConfirmDialog().isConfermedDialog(context, "Are you sure?");
                    if(confirmed){
                      onToggleStatus(t);
                    }
                  },
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _actionButton(String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }


  // the dialog of update salary
  void showUpdateSalaryDialog(BuildContext context, SalaryModel teacher, int salaryId) {
    TextEditingController salaryEditController = TextEditingController(text: teacher.salary);

    Get.defaultDialog(
      title: "Change Salary",
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Change Salary for: ${teacher.name}"),
          SizedBox(height: 15),
          TextField(
            controller: salaryEditController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "New Salary",
              border: OutlineInputBorder(),
              prefixIcon: Icon(CupertinoIcons.money_dollar),
            ),
          ),
        ],
      ),
      // Save Changes Button
      confirm: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C3486),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () {
            if (salaryEditController.text.isNotEmpty) {
              _salaryController.updateSalary(salaryId, salaryEditController.text);
            } else {
              SnackbarHelper.showError(title: "Error", message: "Please enter a valid amount");
            }
          },
          child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
        ),
      ),
      // Cancel Button
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}