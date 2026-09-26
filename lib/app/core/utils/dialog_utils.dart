import 'dart:async';
import 'dart:io';

import 'package:citron_id_card/app/config/network/error_handler.dart';
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
    final message = ErrorHandler.resolveMessage(error);
    ErrorHandler.logError(error);

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
}
