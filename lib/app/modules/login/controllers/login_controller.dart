import 'package:citron_id_card/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final userTypes = ['Admin', 'Teacher', 'Student'];

  final selectedUserType = ''.obs;

  void onLogin() {
    if (!formKey.currentState!.validate()) return;

    if (selectedUserType.value.isEmpty) {
      Get.snackbar('Error', 'Please select user type');
      return;
    }

    Get.toNamed(AppRoutes.idCard);

    // TODO: API call
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
