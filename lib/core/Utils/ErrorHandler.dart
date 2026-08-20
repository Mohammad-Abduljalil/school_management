import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_management/core/Utils/SnackbarHelper.dart';

class ErrorHandler {
  static void handleHttpError(http.Response response) {
    String message = "Something went wrong";
    try {
      final body = jsonDecode(response.body);
      message = body['message'] ?? message;
    } catch (_) {}

    switch (response.statusCode) {
      case 400:
        SnackbarHelper.showError(title: "Bad Request", message: message);
        break;
      case 401:
        SnackbarHelper.showError(title: "Unauthorized", message: "Session expired. Please login again.");
        break;
      case 403:
        SnackbarHelper.showError(title: "Forbidden", message: "You don't have permission to perform this action.");
        break;
      case 404:
        SnackbarHelper.showError(title: "Not Found", message: "The requested resource was not found.");
        break;
      case 422:
        SnackbarHelper.showError(title: "Validation Error", message: message);
        break;
      case 500:
        SnackbarHelper.showError(title: "Server Error", message: "Internal server error. Please try again later.");
        break;
      default:
        SnackbarHelper.showError(title: "Error", message: "Server returned: ${response.statusCode}");
    }
  }

  static void handleException(dynamic e) {
    if (e.toString().contains("SocketException")) {
      SnackbarHelper.showError(title: "Connection Error", message: "Please check your internet connection.");
    } else if (e.toString().contains("TimeoutException")) {
      SnackbarHelper.showError(title: "Timeout", message: "The server is taking too long to respond.");
    } else {
      SnackbarHelper.showError(title: "Unexpected Error", message: e.toString());
    }
  }
}
