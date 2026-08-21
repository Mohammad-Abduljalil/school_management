import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:school_management/Custom/MyImageHelper.dart';
import 'package:school_management/Controller/HomeController/InvoiceController/InvoiceController.dart';
import 'package:school_management/Custom/MyColors.dart';
import 'package:school_management/Custom/MyCustomConfirmDialog.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import 'package:school_management/Model/HomeModel/InvoiceModel.dart';
import 'package:school_management/Model/HomeModel/FeeTypeModel.dart';
import 'package:school_management/Model/HomeModel/InvoiceItemModel.dart';

class InvoiceDataSource extends DataGridSource {
  final List<InvoiceModel> users;
  final Function(InvoiceModel) onToggleStatus;
  final BuildContext context;

  InvoiceDataSource({required this.users, required this.onToggleStatus, required this.context}) {
    _buildDataGridRows();
  }

  List<DataGridRow> _dataGridRows = [];

  void _buildDataGridRows() {
    _dataGridRows = users.map<DataGridRow>((t) {
      return DataGridRow(cells: [
        DataGridCell<dynamic>(columnName: 'identity', value: t),
        DataGridCell<String>(columnName: 'phone', value: t.phone),
        DataGridCell<dynamic>(columnName: 'id', value: t.id),
        DataGridCell<String>(columnName: 'invoice', value: '${t.total_paid}/${t.total_amount}'),
        DataGridCell<String>(columnName: 'status', value: t.status.tr),
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
              path: t?.personalImage,
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
      // phone
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: Text(t.phone, style: TextStyle(color: MyColors.primaryText))),
      // id
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(8),
          child: Text(t.id, style: TextStyle(color: MyColors.primaryText))),
      // invoice (paid/total)
      Container(
        alignment: Alignment.centerLeft,
        child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: t.status == "paid" ? Colors.green : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text("${t.total_paid} / ${t.total_amount} \$",
                style: TextStyle(
                    color: t.status == "paid" ? Colors.white : Colors.green, fontWeight: FontWeight.bold))),
      ),
      // status
      Container(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: t.status == "paid" ? Colors.teal.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(t.status.toUpperCase(),
              style: TextStyle(
                  color: t.status == "unpaid" ? Colors.grey : Colors.teal, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
      // Actions
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBtn("Details".tr, const Color(0xFF1C3486), () {
            _buildDialog(t);
          }),
          const SizedBox(width: 5),
          _buildBtn(
            (t.status == "paid" ? "Set Unpaid" : "Set Paid").tr,
            t.status == "paid" ? Colors.orange : Colors.teal,
            () async {
              bool confirmed = await MyCustomConfirmDialog().isConfermedDialog(context, "Are you sure?".tr);
              if (confirmed) {
                String newStatus = t.status == "paid" ? "unpaid" : "paid";
                Get.find<InvoiceController>().updateInvoiceOnServer(
                  int.parse(t.id),
                  status: newStatus,
                );
              }
            },
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            onPressed: () async {
              bool confirmed =
                  await MyCustomConfirmDialog().isConfermedDialog(context, "Are you sure?".tr);
              if (confirmed) {
                Get.find<InvoiceController>().deleteInvoice(int.parse(t.id));
              }
            },
          ),
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

  void _buildDialog(dynamic t) {
    final InvoiceController controller = Get.find<InvoiceController>();
    controller.fetchInvoiceItems(int.parse(t.id));
    controller.fetchFeeTypes();

    final Map<int, TextEditingController> itemControllers = {};

    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      dialogBackgroundColor: Theme.of(context).cardColor,
      body: Obx(() {
        if (controller.isLoadingItems.value) {
          return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
        }

        double totalAmount = double.tryParse(t.total_amount) ?? 0;
        double totalPaid = double.tryParse(t.total_paid) ?? 0;
        double remaining = totalAmount - totalPaid;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(color: const Color(0xFF1C3486), borderRadius: BorderRadius.circular(5)),
                      child: const Icon(Icons.person, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text("Details".tr,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: MyColors.primaryText)),
                  ],
                ),
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Fees".tr,
                              style:
                                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: MyColors.primaryText)),
                          ElevatedButton.icon(
                            onPressed: () => _showAddItemDialog(context, int.parse(t.id)),
                            icon: const Icon(Icons.add, size: 16),
                            label: Text("Add Item".tr, style: const TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1C3486), foregroundColor: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          _buildSummaryCard(
                              "TOTAL FEES".tr, "${t.total_amount} \$", const Color(0xFF004D61), Icons.payments,
                              onEdit: () => _buildEditTotalDialog(t)),
                          const SizedBox(width: 15),
                          _buildSummaryCard("TOTAL REMAINING".tr, "$remaining \$", Theme.of(context).cardColor,
                              Icons.account_balance_wallet,
                              isDark: false),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 15,
                        runSpacing: 15,
                        children: controller.currentInvoiceItems.map((item) {
                          return SizedBox(
                            width: 300,
                            child: _buildProgressCard(
                                "${item.feeType.toUpperCase()} ${"Fees".tr}",
                                item.paidAmount,
                                item.remainingAmount,
                                item.amount,
                                item.feeType.toLowerCase().contains('bus') ? Icons.directions_bus : Icons.school,
                                onEdit: () => _showEditItemDialog(context, item), onDelete: () async {
                              bool confirmed = await MyCustomConfirmDialog()
                                  .isConfermedDialog(context, "Are you sure?".tr);
                              if (confirmed) {
                                await controller.deleteInvoiceItem(item.id, item.invoiceId);
                              }
                            }),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (controller.currentInvoiceItems.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add Payment".tr,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: MyColors.primaryText)),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: controller.currentInvoiceItems.where((i) => i.remainingAmount > 0).map((item) {
                      if (!itemControllers.containsKey(item.id)) {
                        itemControllers[item.id] = TextEditingController();
                      }
                      return SizedBox(
                        width: 250,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                                child: _buildInputField("${item.feeType.toUpperCase()} ${"Amount".tr}", itemControllers[item.id]!)),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A99D)),
                              onPressed: () async {
                                double val = double.tryParse(itemControllers[item.id]!.text) ?? 0;
                                if (val > 0) {
                                  await controller.payInvoiceOnServer(
                                    invoiceId: int.parse(t.id),
                                    itemId: item.id,
                                    amount: val,
                                  );
                                  itemControllers[item.id]!.clear();
                                }
                              },
                              child: Text("Pay".tr, style: const TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
            else if (!controller.isLoadingItems.value)
               Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text("No specific fee items found for this invoice.".tr),
              ),
            const SizedBox(height: 20),
          ],
        );
      }),
    )..show();
  }

  void _showAddItemDialog(BuildContext context, int invoiceId) {
    final InvoiceController controller = Get.find<InvoiceController>();
    controller.selectedFeeTypeForAdd.value = null;
    final TextEditingController qtyController = TextEditingController(text: "1");
    final TextEditingController priceController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).cardColor,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add New Fee Item".tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyColors.primaryText)),
              const Divider(),
              const SizedBox(height: 20),
              Text("Fee Type".tr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 5),
              Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        color: Get.isDarkMode ? Colors.white10 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<FeeTypeModel>(
                        isExpanded: true,
                        dropdownColor: Theme.of(context).cardColor,
                        hint: Text("Select Type".tr, style: const TextStyle(color: Colors.grey)),
                        value: controller.selectedFeeTypeForAdd.value,
                        items: controller.feeTypes
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type.name, style: TextStyle(color: MyColors.primaryText)),
                                ))
                            .toList(),
                        onChanged: (val) {
                          controller.selectedFeeTypeForAdd.value = val;
                          if (val != null) {
                            priceController.text = val.defaultAmount.toString();
                          }
                        },
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildInputField("Quantity".tr, qtyController)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildInputField("Unit Price".tr, priceController)),
                ],
              ),
              const SizedBox(height: 30),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1C3486)),
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              if (controller.selectedFeeTypeForAdd.value != null) {
                                bool success = await controller.addInvoiceItem(
                                  invoiceId: invoiceId,
                                  feeTypeId: controller.selectedFeeTypeForAdd.value!.id,
                                  quantity: int.tryParse(qtyController.text) ?? 1,
                                  unitPrice: double.tryParse(priceController.text),
                                );
                                if (success) {
                                  Navigator.of(context).pop();
                                }
                              } else {
                                SnackbarHelper.showWarning(title: "Warning".tr, message: "Please select a fee type first".tr);
                              }
                            },
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text("Add Item".tr, style: const TextStyle(color: Colors.white)),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, InvoiceItemModel item) {
    final InvoiceController controller = Get.find<InvoiceController>();
    final TextEditingController qtyController = TextEditingController(text: "1");
    final TextEditingController priceController = TextEditingController(text: item.amount.toString());

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).cardColor,
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("${"Edit".tr} ${item.feeType.toUpperCase()} ${"Item".tr}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyColors.primaryText)),
              const Divider(),
              const SizedBox(height: 20),
              _buildInputField("Unit Price".tr, priceController),
              const SizedBox(height: 15),
              _buildInputField("Quantity".tr, qtyController),
              const SizedBox(height: 30),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1C3486)),
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              bool success = await controller.updateInvoiceItem(
                                itemId: item.id,
                                invoiceId: item.invoiceId,
                                quantity: int.tryParse(qtyController.text),
                                unitPrice: double.tryParse(priceController.text),
                              );
                              if (success) {
                                Navigator.of(context).pop();
                              }
                            },
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text("Update Item".tr, style: const TextStyle(color: Colors.white)),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(dynamic t) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Theme.of(context).dividerColor)),
      child: Column(
        children: [
          MyImageHelper.buildCircleAvatar(
            path: t?.personalImage,
            radius: 50,
          ),
          const SizedBox(height: 15),
          Text(t.full_name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyColors.primaryText)),
          Text("${"Student ID:".tr} #${t.id}", style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTag(t.status.toUpperCase().tr, t.status == "unpaid" ? Colors.grey.shade200 : Colors.teal.withOpacity(0.1),
                  t.status == "unpaid" ? Colors.black : Colors.teal),
              const SizedBox(width: 5),
              _buildTag("GRADE 12-A".tr, Colors.purple.shade50, Colors.purple),
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

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon,
      {bool isDark = true, VoidCallback? onEdit}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(value,
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.green, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                Icon(icon, color: isDark ? Colors.white24 : Colors.green.withOpacity(0.2), size: 40),
              ],
            ),
            if (onEdit != null)
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 14),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(String title, double paid, double remaining, double total, IconData icon,
      {VoidCallback? onEdit, VoidCallback? onDelete}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Theme.of(context).dividerColor)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF1C3486)),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: MyColors.primaryText),
                      overflow: TextOverflow.ellipsis)),
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit, size: 16, color: Colors.blue),
                  onPressed: onEdit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${"Paid:".tr} $paid \$", style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text("${"Remaining:".tr} $remaining \$", style: const TextStyle(fontSize: 11, color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
              value: total > 0 ? paid / total : 0, backgroundColor: Colors.grey.shade200, color: Colors.teal),
          const SizedBox(height: 8),
          Align(
              alignment: Alignment.centerLeft,
              child: Text("${"Total:".tr} $total \$",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: MyColors.primaryText))),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: TextStyle(color: MyColors.primaryText),
          decoration: InputDecoration(
            hintText: "0.00 \$",
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: textCol, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: TextStyle(fontSize: 12, color: MyColors.primaryText.withOpacity(0.8)),
                  overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  void _buildEditTotalDialog(dynamic t) {
    final TextEditingController totalAmountController = TextEditingController(text: t.total_amount);

    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.edit_note, color: Color(0xFF1C3486)),
                    const SizedBox(width: 10),
                    Text("Update Total Amount",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: MyColors.primaryText)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 15),
                Text("Current: ${t.total_amount} \$", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 10),
                TextField(
                  controller: totalAmountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: MyColors.primaryText),
                  decoration: InputDecoration(
                    labelText: "New Total Amount",
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.attach_money),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Cancel".tr),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A99D),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        double? newTotal = double.tryParse(totalAmountController.text);
                        if (newTotal != null) {
                          await Get.find<InvoiceController>().updateInvoiceOnServer(
                            int.parse(t.id),
                            amount: newTotal,
                            dueDate:
                                "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
                            status: "unpaid",
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text("Save Changes".tr, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
