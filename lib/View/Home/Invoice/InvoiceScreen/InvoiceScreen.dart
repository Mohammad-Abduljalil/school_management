import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../../../Controller/HomeController/InvoiceController/InvoiceController.dart';
import '../../../../Custom/MyCustomConfirmDialog.dart';
import '../../../../Custom/MyCustomTextFields.dart';
import '../../../../Custom/MyColors.dart';
import '../../../../core/Utils/SnackbarHelper.dart';
import '../InvoiceDataSource/InvoiceDataSource.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final InvoiceController _invoiceController = Get.put(InvoiceController());
  final double _rowsPerPage = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (_invoiceController.isLoading.value && _invoiceController.invoices.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_invoiceController.isLoading.value && _invoiceController.invoices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  const Text("No invoices found"),
                  TextButton(
                    onPressed: () => _invoiceController.fetchInvoices(),
                    child: const Text("Refresh"),
                  )
                ],
              ),
            );
          }

          final dataSource = InvoiceDataSource(
            users: _invoiceController.invoices,
            onToggleStatus: (invoice) {
              _invoiceController.togglePaymentStatus(invoice);
              },
            context: context,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 25),
                _buildFilterSection(),
                const SizedBox(height: 40),
                // the list
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
                              rowHeight: 55,
                              headerRowHeight: 50,
                              columnWidthMode: ColumnWidthMode.fill,
                              gridLinesVisibility: GridLinesVisibility.none,
                              headerGridLinesVisibility: GridLinesVisibility.none,
                              columns: [
                                GridColumn(columnName: 'identity', label: _buildLabel('Identity')),
                                GridColumn(columnName: 'phone', label: _buildLabel('Phone')),
                                GridColumn(columnName: 'id', label: _buildLabel('Id')),
                                GridColumn(columnName: 'invoice', label: _buildLabel('Invoice')),
                                GridColumn(columnName: 'status', label: _buildLabel('Status')),
                                GridColumn(columnName: 'actions', label: _buildLabel('Actions')),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //  Pagination
                      _buildPagination(dataSource),
                    ],
                  ),
                ),
                SizedBox(height: 80,),
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

  Widget _buildPagination(InvoiceDataSource source) {
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
            "Page ${_invoiceController.currentInvoicesPage.value} of ${_invoiceController.totalInvoicesPages.value}",
            style: const TextStyle(color: Colors.white, fontSize: 13),
          )),
          SfDataPager(
            delegate: source,
            pageCount: _invoiceController.totalInvoicesPages.value.toDouble(),
            direction: Axis.horizontal,
            onPageNavigationStart: (pageIndex){
              _invoiceController.fetchInvoices(page: pageIndex+1);
            },
          ),
        ],
      ),
    );
  }


  Widget _buildHeader(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome User let's start,",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: MyColors.primaryText),),
            const SizedBox(height: 8,),
            Text("Dashboard brief  information about the system.",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Theme.of(context).textTheme.bodySmall?.color ?? const Color(0xFF545455)),),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showFeeTypeManagementDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.backgroundColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.settings_suggest_outlined),
          label: const Text("Manage Fee Types", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void _showFeeTypeManagementDialog(BuildContext context) {
    _invoiceController.fetchFeeTypes();
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).cardColor,
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Manage Fee Types", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: MyColors.primaryText)),
                  IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 20),
              
              // Creation Form
              const Text("Create New Type", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(color: MyColors.primaryText),
                      decoration: InputDecoration(
                        hintText: "Type Name (e.g. Uniform)",
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: MyColors.primaryText),
                      decoration: InputDecoration(
                        hintText: "Price \$",
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(() => ElevatedButton(
                    onPressed: _invoiceController.isLoading.value 
                        ? null 
                        : () async {
                      if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
                        bool success = await _invoiceController.createFeeType(
                            nameController.text, 
                            double.parse(amountController.text)
                        );
                        if (success) {
                          nameController.clear();
                          amountController.clear();
                          Navigator.of(context).pop();
                        }
                      } else {
                        SnackbarHelper.showWarning(title: "Warning", message: "Please fill in all fields");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A99D), 
                        foregroundColor: Colors.white, 
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20)
                    ),
                    child: _invoiceController.isLoading.value 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Add"),
                  )),
                ],
              ),
              
              const SizedBox(height: 30),
              const Text("Existing Types", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),
              
              // List of Fee Types
              Expanded(
                child: Obx(() {
                  if (_invoiceController.isLoadingFeeTypes.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.separated(
                    itemCount: _invoiceController.feeTypes.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final type = _invoiceController.feeTypes[index];
                      return ListTile(
                        title: Text(type.name, style: TextStyle(fontWeight: FontWeight.w600, color: MyColors.primaryText)),
                        subtitle: Text("Default Amount: ${type.defaultAmount} \$", style: const TextStyle(color: Colors.grey)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                              onPressed: () => _showEditFeeTypeDialog(context, type),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => _confirmDeleteFeeType(context, type.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditFeeTypeDialog(BuildContext context, dynamic type) {
    final nameController = TextEditingController(text: type.name);
    final amountController = TextEditingController(text: type.defaultAmount.toString());

    Get.dialog(
      AlertDialog(
        title: const Text("Edit Fee Type"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Price \$")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              bool success = await _invoiceController.updateFeeType(type.id, nameController.text, double.parse(amountController.text));
              if (success) {
                Navigator.of(context).pop();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteFeeType(BuildContext context, int id) async {
    bool confirmed = await MyCustomConfirmDialog().isConfermedDialog(context, "Are you sure you want to delete this fee type?");
    if (confirmed) {
      await _invoiceController.deleteFeeType(id);
    }
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text("Show Data For: ", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 15),
            ],
          ),
          SizedBox(height: 10,),
          MyCustomTextField(controller: _invoiceController.searchEditingController, hintText: "Search by student name...",onChanged: (value){
            _invoiceController.searchByName(value);
          },),
        ],
      ),
    );
  }


}