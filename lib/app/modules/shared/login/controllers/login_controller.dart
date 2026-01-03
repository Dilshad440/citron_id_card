import 'package:citron_id_card/app/config/local/shared_prefs.dart';
import 'package:citron_id_card/app/core/constants/app_constants.dart';
import 'package:citron_id_card/app/core/utils/dialog_utils.dart';
import 'package:citron_id_card/app/routes/app_routes.dart';
import 'package:citron_id_card/app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/login_response.dart';

class LoginController extends GetxController {
  final ApiService apiService;

  LoginController({required this.apiService});

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController(text: "1234567899");
  final passwordController = TextEditingController(text: "abc@123");

  final userTypes = ['Admin', 'Teacher', 'Student', 'Parent'];

  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> onLogin() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final response = await apiService.login(
        userName: usernameController.text,
        password: passwordController.text,
      );
      await SharedPrefs.instance.setTypedObject<LoginResponse>(
        AppConstants.user,
        response,
        (value) => value.toJson(),
      );
      AppSnackBar.show(
        error: "Logged in successfully",
        type: SnackBarType.success,
      );
      isLoading.value = false;

      if (response.user?.userType == 2) {
        Get.offAllNamed(AppRoutes.idCard);
      } else if (response.user?.userType == 3) {
        Get.offAllNamed(AppRoutes.enterAdmissionNumber);
      }
    } catch (e) {
      isLoading.value = false;

      AppSnackBar.show(error: e, type: SnackBarType.error);
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
