import 'dart:async';
import 'dart:io';

import 'package:citron_id_card/app/core/theme/app_text_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtils {
  static Future<void> showLoading({String? message}) async {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 12),
                Text(message),
              ],
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen == true) {
      Navigator.pop(Get.context!);
    }
  }
}

enum SnackBarType { success, error }

class AppSnackBar {
  static void show({
    required dynamic error,
    SnackBarType type = SnackBarType.success,
    SnackPosition position = SnackPosition.BOTTOM,
    int durationSeconds = 3,
  }) {
    final isSuccess = type == SnackBarType.success;
    final title = isSuccess ? "Success" : "Error";
    final message = _resolveMessage(error);

    Get.snackbar(
      "",
      "",
      titleText: Text(title, style: AppTextStyle.title.large),
      messageText: Text(message, style: AppTextStyle.title.medium),
      snackPosition: position,
      duration: Duration(seconds: durationSeconds),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      backgroundColor: isSuccess ? Colors.green.shade600 : Colors.red.shade600,
      colorText: Colors.white,
      icon: Icon(
        isSuccess ? Icons.check_circle_outline : Icons.error_outline,
        color: Colors.white,
        size: 28,
      ),
      shouldIconPulse: false,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeIn,
    );
  }

  /// Centralized message resolver
  static String _resolveMessage(dynamic e) {
    // 1️⃣ Dio (API / Network)
    if (e is DioException) {
      // Timeout
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return 'Connection timed out. Please try again.';
      }

      // No internet
      if (e.type == DioExceptionType.connectionError) {
        return 'No internet connection.';
      }

      // Server response
      final data = e.response?.data;
      if (data is Map) {
        if (data['message'] != null) {
          return data['message'].toString();
        }
        if (data['error'] != null) {
          return data['error'].toString();
        }
      }

      return 'Something went wrong. Please try again.';
    }

    // 2️⃣ Socket (No Internet)
    if (e is SocketException) {
      return 'No internet connection.';
    }

    // 3️⃣ Timeout
    if (e is TimeoutException) {
      return 'Request timed out. Please try again.';
    }

    // 4️⃣ Format / Parsing
    if (e is FormatException) {
      return 'Invalid response format.';
    }

    // 5️⃣ Flutter framework errors
    if (e is FlutterError) {
      return 'Unexpected app error occurred.';
    }

    // 6️⃣ Custom string message
    if (e is String && e.isNotEmpty) {
      return e;
    }

    // 7️⃣ Fallback
    return 'Something went wrong.';
  }
}
