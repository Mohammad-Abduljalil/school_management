import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/Custom/MyCustomConfirmDialog.dart';
import 'package:school_management/Custom/MyImageHelper.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:school_management/Controller/HomeController/TeachersManagementController/TeachersManagementController.dart';
import 'package:school_management/Model/HomeModel/TacherModel/TeacherModel.dart';

class TeacherDataSource extends DataGridSource {
  final List<TeacherModel> teachers;
  final Function(TeacherModel) onToggleStatus;
  final BuildContext context;

  TeacherDataSource({required this.teachers, required this.onToggleStatus, required this.context}) {
    _buildDataGridRows();
  }

  List<DataGridRow> _dataGridRows = [];

  void _buildDataGridRows() {
    _dataGridRows = teachers.map<DataGridRow>((t) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'identity', value: t),
        DataGridCell<String>(columnName: 'phone', value: t.phone),
        DataGridCell<dynamic>(columnName: 'id', value: t.id),
        DataGridCell<int>(columnName: 'salary', value: t.salary),
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
          child: Text("${t.id}", style: TextStyle(color: MyColors.primaryText))),
      // Salary
      Container(
        alignment: Alignment.centerLeft,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFB0E4DD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(t.salary.toString(),
                style: const TextStyle(color: Color(0xFF0732A3), fontWeight: FontWeight.bold, fontSize: 12))),
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
          child: Text(t.status == 1 ? "ACTIVE" : "PENDING",
              style: TextStyle(
                  color: t.status == 0 ? Colors.grey : Colors.teal, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
      // Actions
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBtn("Details", const Color(0xFF1C3486), () {
            Get.find<TeachersManagementController>().getTeacherDetails(t);
            _buildDialog(t);
          }),
          const SizedBox(width: 5),
          _buildBtn(t.status == 1 ? "PENDING" : "ACTIVE", t.status == 1 ? Colors.red : Colors.teal, () async {
            bool confirmed = await MyCustomConfirmDialog().isConfermedDialog(context, "Are you sure?");
            if (confirmed) {
              onToggleStatus(t);
            }
          }),
          const SizedBox(width: 5),
          _buildBtn("Notification", Colors.orangeAccent, () {
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
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ),
    );
  }

  void _buildDialog(TeacherModel t) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      dialogBackgroundColor: Theme.of(context).cardColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(color: const Color(0xFF1C3486), borderRadius: BorderRadius.circular(5)),
                      child: const Icon(Icons.person_search, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text("Teacher Details View",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: MyColors.primaryText)),
                  ],
                ),
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close, color: Colors.grey)),
              ],
            ),
            const Divider(),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: _buildProfileSection(t)),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Academic Standing",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: MyColors.primaryText)),
                      const SizedBox(height: 15),
                      _buildAcademicStandingSection(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    )..show();
  }

  Widget _buildProfileSection(TeacherModel t) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Theme.of(context).dividerColor)),
      child: Column(
        children: [
          MyImageHelper.buildCircleAvatar(
            path: t?.profile_image,
            radius: 50,
          ),
          const SizedBox(height: 10),
          Text(t.full_name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyColors.primaryText)),
          Text("Teacher ID: #${t.id}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSmallTag(t.status == 1 ? "ACTIVE" : "PENDING",
                  t.status == 1 ? Colors.teal.shade50 : Colors.grey.shade50, t.status == 1 ? Colors.teal : Colors.grey),
            ],
          ),
          const Divider(height: 30),
          _buildInfoRow(Icons.email_outlined, t.email),
          _buildInfoRow(Icons.phone_outlined, t.phone),
          _buildInfoRow(Icons.location_on_outlined, t.location ?? "Not Set"),
          _buildInfoRow(Icons.payments_outlined, "Salary: ${t.salary} \$"),
        ],
      ),
    );
  }

  Widget _buildAcademicStandingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Theme.of(context).dividerColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Work Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyColors.primaryText)),
          const SizedBox(height: 20),
          _buildAcademicRow("Experience", "5 Years", Colors.teal),
          const SizedBox(height: 10),
          _buildAcademicRow("Current Classes", "12", Colors.indigo),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1C3486)),
            child: const Text("View Schedule", style: TextStyle(color: Colors.white, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildAcademicRow(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildSmallTag(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(5)),
      child: Text(text, style: TextStyle(color: textCol, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: TextStyle(fontSize: 11, color: MyColors.primaryText.withOpacity(0.8)),
                  overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  void _buildNotificationDialog(dynamic t) {
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
                    Text("Send Notification",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: MyColors.primaryText)),
                    const SizedBox(height: 5),
                    Text("Draft an official communication for this teacher.",
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
            Text("TARGET TEACHER", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
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
            Text("SUBJECT", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: subjectController,
              style: TextStyle(color: MyColors.primaryText),
              decoration: InputDecoration(
                hintText: "write the main subject",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                filled: true,
                fillColor: Get.isDarkMode ? Colors.white10 : const Color(0xFFE8F0F5),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            Text("MESSAGE BODY", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: bodyController,
              maxLines: 4,
              style: TextStyle(color: MyColors.primaryText),
              decoration: InputDecoration(
                hintText: "what is the content about this message...",
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
                    child: const Text("Cancel", style: TextStyle(color: Color(0xFF1C3486), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      SnackbarHelper.showSuccess(title: "Success", message: "Notification sent to ${t.full_name}");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: const Color(0xFF1C3486),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Send Notification", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
