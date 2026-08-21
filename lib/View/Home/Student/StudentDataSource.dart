import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/Custom/MyCustomConfirmDialog.dart';
import 'package:school_management/Custom/MyImageHelper.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:school_management/Controller/HomeController/StudentsManagementController/StudentsManagementController.dart';
import 'package:school_management/Model/HomeModel/StudentModel/StudentModel.dart';

class StudentDataSource extends DataGridSource {
  final List<StudentModel> students;
  final Function(StudentModel) onToggleStatus;
  final Function(StudentModel) studentDetails;
  final BuildContext context;

  StudentDataSource({required this.students, required this.onToggleStatus, required this.studentDetails, required this.context}) {
    _buildDataGridRows();
  }

  List<DataGridRow> _dataGridRows = [];

  void _buildDataGridRows() {
    _dataGridRows = students.map<DataGridRow>((t) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'identity', value: t),
        DataGridCell<String>(columnName: 'phone', value: t.phone),
        DataGridCell<dynamic>(columnName: 'id', value: t.id),
        DataGridCell<String>(columnName: 'role', value: "Students".tr),
        DataGridCell<String>(columnName: 'status', value: (t.status == 1 ? "Approved" : "Pending").tr),
        DataGridCell<dynamic>(columnName: 'actions', value: t),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final t = row.getCells()[0].value as StudentModel;

    return DataGridRowAdapter(cells: [
      // identity
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            MyImageHelper.buildCircleAvatar(
              path: t.profile_image,
              radius: 25,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.full_name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: MyColors.primaryText)),
                  Text(t.email,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.grey, fontSize: 11)),
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
      // Role
      Container(
        alignment: Alignment.centerLeft,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDDE1FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("STUDENT".tr, style: TextStyle(color: Color(0xFF0732A3), fontWeight: FontWeight.bold, fontSize: 10))),
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
          _buildBtn("Details".tr, const Color(0xFF1C3486), () {
            studentDetails(t);
            _buildDialog(t);
          }),
          const SizedBox(width: 5),
          _buildBtn((t.status == 1 ? "PENDING" : "ACTIVE").tr, t.status == 1 ? Colors.red : Colors.teal, () async {
            bool confirmed = await MyCustomConfirmDialog().isConfermedDialog(context, "Are you sure?".tr);
            if (confirmed) {
              onToggleStatus(t);
            }
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
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ),
    );
  }

  void _buildDialog(StudentModel t) {
    final StudentsManagementController controller = Get.find<StudentsManagementController>();

    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      dialogBackgroundColor: Theme.of(context).cardColor,
      body: Obx(() {
        if (controller.isLoadingDetails.value) {
          return const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()));
        }

        double totalAmount = 0;
        double totalPaid = 0;
        for (var item in controller.studentInvoiceItems) {
          totalAmount += item.amount;
          totalPaid += item.paidAmount;
        }
        double remaining = totalAmount - totalPaid;

        return SingleChildScrollView(
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
                      Text("Student Details View".tr,
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
                        Text("Financial Overview".tr,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: MyColors.primaryText)),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            _buildSummaryCard("TOTAL FEES".tr, "$totalAmount \$", const Color(0xFF003D4C), Icons.payments),
                            const SizedBox(width: 15),
                            _buildSummaryCard("TOTAL REMAINING".tr, "$remaining \$", Theme.of(context).scaffoldBackgroundColor,
                                Icons.account_balance_wallet,
                                isDark: false),
                          ],
                        ),
                        const SizedBox(height: 15),
                        if (controller.studentInvoiceItems.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text("No specific invoice items found.".tr, style: TextStyle(color: Colors.grey.shade500)),
                          )
                        else
                          Wrap(
                            spacing: 15,
                            runSpacing: 15,
                            children: controller.studentInvoiceItems.map((item) {
                              return SizedBox(
                                width: 280,
                                child: _buildFeesProgressCard(
                                    "${item.feeType.toUpperCase()} ${"Fees".tr}",
                                    item.paidAmount,
                                    item.remainingAmount,
                                    item.amount,
                                    item.feeType.toLowerCase().contains('bus') ? Icons.directions_bus : Icons.school),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildAcademicStandingSection(),
            ],
          ),
        );
      }),
    )..show();
  }

  Widget _buildProfileSection(StudentModel t) {
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
          Text("${"ID".tr}: #${t.student_id}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSmallTag((t.status == 1 ? "ACTIVE" : "PENDING").tr,
                  t.status == 1 ? Colors.teal.shade50 : Colors.grey.shade50, t.status == 1 ? Colors.teal : Colors.grey),
              const SizedBox(width: 5),
              _buildSmallTag("${"Stage".tr} ${t.student_number}", Colors.indigo.shade50, Colors.indigo),
            ],
          ),
          const Divider(height: 30),
          _buildInfoRow(Icons.email_outlined, t.email),
          _buildInfoRow(Icons.phone_outlined, t.phone),
          _buildInfoRow(Icons.location_on_outlined, t.location),
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
          Text("Academic Standing".tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyColors.primaryText)),
          const SizedBox(height: 20),
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(
                        value: 0.85, strokeWidth: 8, color: Colors.teal.shade700, backgroundColor: Colors.grey.shade200),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("3.85", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: MyColors.primaryText)),
                      const Text("GPA", style: TextStyle(fontSize: 7, color: Colors.grey)),
                    ],
                  )
                ],
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  children: [
                    _buildAcademicRow("Update".tr, "A", Colors.teal),
                    const SizedBox(height: 10),
                    _buildAcademicRow("Stage".tr, "#8", Colors.indigo),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1C3486)),
            child: Text("View All Marks".tr, style: const TextStyle(color: Colors.white, fontSize: 12)),
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

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon, {bool isDark = true}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isDark ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
          border: isDark ? null : Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(value,
                    style: TextStyle(color: isDark ? Colors.white : Colors.teal, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            Icon(icon, color: isDark ? Colors.white24 : Colors.teal.withOpacity(0.1), size: 35),
          ],
        ),
      ),
    );
  }

  Widget _buildFeesProgressCard(String title, double paid, double remaining, double total, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF1C3486)),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(title,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: MyColors.primaryText),
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${"Paid:".tr} $paid \$", style: const TextStyle(fontSize: 10, color: Colors.teal, fontWeight: FontWeight.bold)),
              Text("${"Remaining:".tr} $remaining \$", style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
              value: total > 0 ? paid / total : 0, backgroundColor: Colors.grey.shade100, color: Colors.teal, minHeight: 6),
          const SizedBox(height: 6),
          Align(
              alignment: Alignment.centerLeft,
              child: Text("${"Total:".tr} $total \$", style: const TextStyle(fontSize: 10, color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildSmallTag(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(5)),
      child: Text(text.tr, style: TextStyle(color: textCol, fontSize: 9, fontWeight: FontWeight.bold)),
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
                    Text("Send Notification".tr,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: MyColors.primaryText)),
                    const SizedBox(height: 5),
                    Text("Draft an official communication for this student.".tr,
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
            Text("TARGET STUDENT".tr, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
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
