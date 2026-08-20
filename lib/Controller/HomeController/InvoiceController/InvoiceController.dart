import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/core/AppConstants.dart';
import 'package:school_management/core/Services/SettingsService.dart';
import 'package:school_management/core/Utils/ErrorHandler.dart';
import 'package:school_management/core/Utils/SnackbarHelper.dart';
import '../../../Model/HomeModel/InvoiceModel.dart';
import '../../../Model/HomeModel/InvoiceItemModel.dart';
import '../../../Model/HomeModel/FeeTypeModel.dart';

class InvoiceController extends GetxController {
  var isLoading = true.obs;
  RxList<InvoiceModel> invoices = <InvoiceModel>[].obs;
  RxList<InvoiceModel> allInvoices = <InvoiceModel>[].obs;
  late TextEditingController searchEditingController;

  // States for Invoice Items
  RxList<InvoiceItemModel> currentInvoiceItems = <InvoiceItemModel>[].obs;
  RxBool isLoadingItems = false.obs;

  // States for Fee Types
  RxList<FeeTypeModel> feeTypes = <FeeTypeModel>[].obs;
  RxBool isLoadingFeeTypes = false.obs;
  Rxn<FeeTypeModel> selectedFeeTypeForAdd = Rxn<FeeTypeModel>();

  var currentInvoicesPage = 1.obs;
  var totalInvoicesPages = 1.obs;
  final SettingService settingService = Get.find();

  @override
  void onInit() {
    searchEditingController = TextEditingController();
    Future.wait([
    fetchInvoices(),
    ]);
    super.onInit();
  }

  Future<void> fetchInvoices({int page = 1}) async {
    try {
      isLoading.value = true;
      currentInvoicesPage.value = page;
      String? token = settingService.sharedPreferences.getString("token");
      var getInvoicesUrl = Uri.parse("${AppConstants.linkGetInvoices}?page=$page");
      var response = await http.get(
        getInvoicesUrl,
        headers: AppConstants.headers(token!),
      );
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        dynamic rawData = responseData['data'];
        List fetchedList = [];
        if (rawData is Map && rawData.containsKey('data')) {
          fetchedList = rawData['data'];
        } else if (rawData is List) {
          fetchedList = rawData;
        } else if (responseData is List) {
          fetchedList = responseData;
        }
        List<InvoiceModel> mappedInvoices = fetchedList
            .map<InvoiceModel>((item) => InvoiceModel.fromJson(item))
            .toList();
        allInvoices.assignAll(mappedInvoices);
        invoices.assignAll(mappedInvoices);
        if (rawData is Map && rawData['last_page'] != null) {
          totalInvoicesPages.value = rawData['last_page'];
        } else if (responseData['meta'] != null) {
          totalInvoicesPages.value = responseData['meta']['last_page'] ?? 1;
        }
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch invoices: $e");
      ErrorHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  void searchByName(String query) {
    if (query.isEmpty) {
      invoices.assignAll(allInvoices);
    } else {
      invoices.assignAll(
          allInvoices.where((invoice) => invoice.full_name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  Future<bool> createInvoice({required int studentId, double? amount, required String dueDate}) async {
    try {
      isLoading.value = true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.post(
        Uri.parse(AppConstants.linkCreateInvoice),
        headers: AppConstants.headers(token!),
        body: jsonEncode({
          'student_id': studentId,
          if (amount != null) 'total_amount': amount,
          'due_date': dueDate,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        SnackbarHelper.showSuccess(title: "Success", message: "Invoice created successfully");
        await fetchInvoices();
        return true;
      } else {
        ErrorHandler.handleHttpError(response);
        return false;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to create invoice: $e");
      ErrorHandler.handleException(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateInvoiceOnServer(int id, {double? amount, String? dueDate, String? status}) async {
    try {
      isLoading.value = true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.put(
        Uri.parse("${AppConstants.linkUpdateInvoice}/$id"),
        headers: AppConstants.headers(token!),
        body: jsonEncode({
          if (amount != null) 'total_amount': amount,
          if (dueDate != null) 'due_date': dueDate,
          if (status != null) 'status': status,
        }),
      );

      if (response.statusCode == 200) {
        SnackbarHelper.showSuccess(title: "Success", message: "Data updated successfully");
        await fetchInvoices(page: currentInvoicesPage.value);
        return true;
      } else {
        ErrorHandler.handleHttpError(response);
        return false;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to update data: $e");
      ErrorHandler.handleException(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteInvoice(int id) async {
    try {
      isLoading.value = true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.delete(
        Uri.parse("${AppConstants.linkDeleteInvoice}/$id"),
        headers: AppConstants.headers(token!),
      );

      if (response.statusCode == 200) {
        allInvoices.removeWhere((inv) => inv.id == id.toString());
        invoices.removeWhere((inv) => inv.id == id.toString());
        invoices.refresh();
        SnackbarHelper.showSuccess(title: "Success", message: "Invoice deleted successfully");
        return true;
      } else {
        ErrorHandler.handleHttpError(response);
        return false;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to delete invoice: $e");
      ErrorHandler.handleException(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> payInvoiceOnServer({required int invoiceId, required int itemId, required double amount, String? paymentAt}) async {
    try {
      isLoading.value = true;
      String? token = settingService.sharedPreferences.getString("token");
      var url = Uri.parse(AppConstants.linkPayInvoice(invoiceId, itemId));
      var response = await http.post(
        url,
        headers: AppConstants.headers(token!),
        body: jsonEncode({
          'amount': amount,
          if (paymentAt != null) 'payment_at': paymentAt,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        SnackbarHelper.showSuccess(title: "Success", message: "Payment recorded successfully");
        await fetchInvoiceItems(invoiceId);
        await fetchInvoices(page: currentInvoicesPage.value);
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to pay invoice");
      ErrorHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchInvoiceItems(int invoiceId) async {
    try {
      isLoadingItems.value = true;
      currentInvoiceItems.clear();
      String? token = settingService.sharedPreferences.getString("token");
      var url = Uri.parse(AppConstants.linkGetInvoiceItems(invoiceId));
      var response = await http.get(url, headers: AppConstants.headers(token!));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        dynamic rawItems;
        if (responseData is Map) {
          rawItems = responseData['invoice_items'] ?? responseData['data'] ?? responseData['items'];
        } else if (responseData is List) {
          rawItems = responseData;
        }
        List fetchedList = (rawItems is List) ? rawItems : [];
        currentInvoiceItems.assignAll(fetchedList.map<InvoiceItemModel>((item) => InvoiceItemModel.fromJson(item)).toList());
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch invoice items");
      ErrorHandler.handleException(e);
    } finally {
      isLoadingItems.value = false;
    }
  }

  Future<void> fetchFeeTypes() async {
    try {
      isLoadingFeeTypes.value = true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.get(Uri.parse(AppConstants.linkGetFeeTypes), headers: AppConstants.headers(token!));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var rawData = responseData['data'];
        List fetchedList = [];
        if (rawData is Map && rawData.containsKey('data')) {
          fetchedList = rawData['data'];
        } else if (rawData is List) {
          fetchedList = rawData;
        }
        feeTypes.assignAll(fetchedList.map<FeeTypeModel>((e) => FeeTypeModel.fromJson(e)).toList());
      } else {
        ErrorHandler.handleHttpError(response);
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to fetch fee types");
      ErrorHandler.handleException(e);
    } finally {
      isLoadingFeeTypes.value = false;
    }
  }

  Future<bool> createFeeType(String name, double amount) async {
    try {
      isLoading.value = true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.post(
        Uri.parse(AppConstants.linkCreateFeeType),
        headers: AppConstants.headers(token!),
        body: jsonEncode({
          'name': name,
          'default_amount': amount,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        SnackbarHelper.showSuccess(title: "Success", message: "Fee type created successfully");
        await fetchFeeTypes();
        return true;
      } else {
        ErrorHandler.handleHttpError(response);
        return false;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to create fee type");
      ErrorHandler.handleException(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateFeeType(int id, String name, double amount) async {
    try {
      isLoading.value = true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.put(
        Uri.parse(AppConstants.linkUpdateFeeType(id)),
        headers: AppConstants.headers(token!),
        body: jsonEncode({
          'name': name,
          'default_amount': amount,
        }),
      );
      if (response.statusCode == 200) {
        SnackbarHelper.showSuccess(title: "Success", message: "Fee type updated successfully");
        await fetchFeeTypes();
        return true;
      } else {
        ErrorHandler.handleHttpError(response);
        return false;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to update fee type");
      ErrorHandler.handleException(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteFeeType(int id) async {
    try {
      isLoading.value = true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.delete(
        Uri.parse(AppConstants.linkDeleteFeeType(id)),
        headers: AppConstants.headers(token!),
      );
      if (response.statusCode == 200) {
        SnackbarHelper.showSuccess(title: "Success", message: "Fee type deleted successfully");
        await fetchFeeTypes();
        return true;
      } else {
        ErrorHandler.handleHttpError(response);
        return false;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to delete fee type");
      ErrorHandler.handleException(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addInvoiceItem({required int invoiceId, required int feeTypeId, int quantity = 1, double? unitPrice}) async {
    try {
      isLoading.value = true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.post(
        Uri.parse(AppConstants.linkAddInvoiceItem),
        headers: AppConstants.headers(token!),
        body: jsonEncode({
          'invoice_id': invoiceId,
          'fee_type_id': feeTypeId,
          'quantity': quantity,
          if (unitPrice != null) 'unit_price': unitPrice,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        SnackbarHelper.showSuccess(title: "Success", message: "Item added successfully");
        await fetchInvoiceItems(invoiceId);
        await fetchInvoices(page: currentInvoicesPage.value);
        return true;
      } else {
        ErrorHandler.handleHttpError(response);
        return false;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to add item");
      ErrorHandler.handleException(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateInvoiceItem({required int itemId, required int invoiceId, int? quantity, double? unitPrice, String? status}) async {
    try {
      isLoading.value = true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.put(
        Uri.parse(AppConstants.linkUpdateInvoiceItem(itemId)),
        headers: AppConstants.headers(token!),
        body: jsonEncode({
          if (quantity != null) 'quantity': quantity,
          if (unitPrice != null) 'unit_price': unitPrice,
          if (status != null) 'status': status,
        }),
      );
      if (response.statusCode == 200) {
        SnackbarHelper.showSuccess(title: "Success", message: "Item updated successfully");
        await fetchInvoiceItems(invoiceId);
        await fetchInvoices(page: currentInvoicesPage.value);
        return true;
      } else {
        ErrorHandler.handleHttpError(response);
        return false;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to update item");
      ErrorHandler.handleException(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteInvoiceItem(int itemId, int invoiceId) async {
    try {
      isLoading.value = true;
      String? token = settingService.sharedPreferences.getString("token");
      var response = await http.delete(
        Uri.parse(AppConstants.linkDeleteInvoiceItem(itemId)),
        headers: AppConstants.headers(token!),
      );
      if (response.statusCode == 200) {
        SnackbarHelper.showSuccess(title: "Success", message: "Item deleted successfully");
        await fetchInvoiceItems(invoiceId);
        await fetchInvoices(page: currentInvoicesPage.value);
        return true;
      } else {
        ErrorHandler.handleHttpError(response);
        return false;
      }
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to delete item");
      ErrorHandler.handleException(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> togglePaymentStatus(InvoiceModel invoice) async {
    try {
      String newStatus = invoice.status == "paid" ? "unpaid" : "paid";
      await updateInvoiceOnServer(int.parse(invoice.id), status: newStatus);
    } catch (e) {
      SnackbarHelper.showError(title: "Error", message: "Failed to toggle payment status");
    }
  }

  @override
  void onClose() {
    searchEditingController.dispose();
    super.onClose();
  }
}
