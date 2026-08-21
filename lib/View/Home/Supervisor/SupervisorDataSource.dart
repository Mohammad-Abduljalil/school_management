import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/Custom/MyCustomConfirmDialog.dart';
import 'package:school_management/Custom/MyImageHelper.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:school_management/Controller/HomeController/SupervisorsManagementController/SupervisorsManagementController.dart';
import 'package:school_management/Model/HomeModel/SupervisorModel/SupervisorModel.dart';

class SupervisorDataSource extends DataGridSource {
  final List<SupervisorModel> supervisor;
  final Function(SupervisorModel) onToggleStatus;
  final BuildContext context;

  SupervisorDataSource({required this.supervisor, required this.onToggleStatus, required this.context}) {
    _buildDataGridRows();
  }

  List<DataGridRow> _dataGridRows = [];

  void _buildDataGridRows() {
    _dataGridRows = supervisor.map<DataGridRow>((t) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'identity', value: t),
        DataGridCell<String>(columnName: 'phone', value: t.phone),
        DataGridCell<dynamic>(columnName: 'id', value: t.id),
        DataGridCell<String>(columnName: 'role', value: "Supervisor".tr),
        DataGridCell<String>(columnName: 'status', value: (t.status == 1 ? "Approved" : "Pending").tr),
        DataGridCell<dynamic>(columnName: 'actions', value: t),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final SupervisorModel t = row.getCells()[0].value;

    return DataGridRowAdapter(cells: [
      // identity
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            MyImageHelper.buildCircleAvatar(
              path: t?.profile_image,
              radius: 25,
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
      // Phone
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: Text(t.phone, style: TextStyle(color: MyColors.primaryText))),
      // id
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: Text(t.id.toString(), style: TextStyle(color: MyColors.primaryText))),
      // Role
      Container(
        alignment: Alignment.centerLeft,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF0BD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("Supervisor".tr,
                style: const TextStyle(color: Color(0xFFD4A400), fontWeight: FontWeight.bold, fontSize: 10))),
      ),
      // Status
      Container(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: t.status == 1 ? Colors.teal.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text((t.status == 1 ? "ACTIVE" : "PENDING").tr,
              style: TextStyle(
                  color: t.status == 0 ? Colors.grey : Colors.teal, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
      // Actions
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBtn((t.status == 1 ? "PENDING" : "ACTIVE").tr, t.status == 1 ? Colors.red : Colors.teal, () async {
            bool confirmed = await MyCustomConfirmDialog().isConfermedDialog(context, "Are you sure?".tr);
            if (confirmed) {
              onToggleStatus(t);
            }
          }),
          const SizedBox(width: 5),
          _buildBtn("Assign Salary".tr, const Color(0xFF00A99D), () {
            Get.find<SupervisorsManagementController>().assignSalaryManual(t);
          }),
          const SizedBox(width: 5),
          _buildBtn("Notification".tr, Colors.orangeAccent, () {
            _buildNotificationDialog(t);
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
        child: Text(title.tr, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ),
    );
  }

  void _buildNotificationDialog(SupervisorModel t) {
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController bodyController = TextEditingController();

    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      width: MediaQuery.of(context).size.width * 0.5,
      dialogBackgroundColor: Theme.of(context).cardColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Send Notification".tr,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: MyColors.primaryText)),
                    const SizedBox(height: 5),
                    Text("Draft an official communication for this supervisor.".tr,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text("TARGET SUPERVISOR".tr, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.white10 : const Color(0xFFE8F0F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: const Color(0xFF1C3486), borderRadius: BorderRadius.circular(5)),
                    child: const Icon(Icons.person, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Text(t.full_name, style: TextStyle(fontWeight: FontWeight.w600, color: MyColors.primaryText)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text("SUBJECT".tr, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: subjectController,
              style: TextStyle(color: MyColors.primaryText),
              decoration: InputDecoration(
                hintText: "write the main subject".tr,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                filled: true,
                fillColor: Get.isDarkMode ? Colors.white10 : const Color(0xFFE8F0F5),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            Text("MESSAGE BODY".tr, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: bodyController,
              maxLines: 4,
              style: TextStyle(color: MyColors.primaryText),
              decoration: InputDecoration(
                hintText: "what is the content about this message...".tr,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                filled: true,
                fillColor: Get.isDarkMode ? Colors.white10 : const Color(0xFFE8F0F5),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      side: const BorderSide(color: Color(0xFF1C3486)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Cancel".tr, style: const TextStyle(color: Color(0xFF1C3486), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      SnackbarHelper.showSuccess(title: "Success".tr, message: "${"Notification sent to".tr} ${t.full_name}");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: const Color(0xFF1C3486),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Send Notification".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).show();
  }
}
