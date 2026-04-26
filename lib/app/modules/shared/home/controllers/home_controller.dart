import 'dart:convert';

import 'package:citron_id_card/app/config/local/shared_prefs.dart';
import 'package:citron_id_card/app/core/components/app_buttons.dart';
import 'package:citron_id_card/app/core/constants/app_constants.dart';
import 'package:citron_id_card/app/core/utils/common_utils.dart';
import 'package:citron_id_card/app/core/utils/dialog_utils.dart';
import 'package:citron_id_card/app/modules/school/id_card/model/final%20_field_model.dart';
import 'package:citron_id_card/app/modules/school/id_card/model/get_sessions.dart';
import 'package:citron_id_card/app/modules/school/id_card/model/selected_fields_model.dart';
import 'package:citron_id_card/app/modules/shared/login/controllers/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/api_service.dart';
import '../../login/model/login_response.dart';
import '../model/school_user_res.dart';

class HomeController extends GetxController {
  final ApiService service;
  final formKey = GlobalKey<FormState>();

  HomeController({required this.service});

  Rx<SchoolUserRes?> schoolUser = Rx<SchoolUserRes?>(null);
  RxBool isLoading = false.obs;
  RxBool isOverlayLoading = false.obs;
  RxBool isParent = false.obs;
  RxList<FieldModel> fieldModel = <FieldModel>[].obs;
  String? selectedBatch;
  String? selectedSession;
  List<String> classList = ["All"];
  List<String> sectionList = ["All"];
  RxList<Sessions> sessions = <Sessions>[].obs;

  @override
  void onInit() {
    selectedBatch = batch.first;
    getUserFromLocal();
    getSchoolUserRes();
    super.onInit();
  }

  Future<void> getSchoolUserRes() async {
    isLoading.value = true;

    try {
      final response = await service.getSchoolUsers();

      if (response.isEmpty) {
        await Get.dialog(
          AlertDialog(
            title: const Text("No School Found"),
            content: const Text(
              "No school is associated with your account. Please contact support or logout.",
            ),
            actions: [
              AppButton(
                text: "Logout",
                onPressed: () {
                  Get.back();
                  logout();
                },
              ),
            ],
          ),
          barrierDismissible: false,
        );
        return;
      }

      schoolUser.value = response.first;

      final schoolId = schoolUser.value?.schoolId;
      if (schoolId == null) {
        AppSnackBar.show(
          error: "Invalid school data",
          type: SnackBarType.error,
        );
        return;
      }

      final selectedFiledRes = await service.getSelectedFields(schoolId);
      final fields = selectedFiledRes.selectedFields ?? [];
      if (fields.isEmpty) {
        AppSnackBar.show(
          error: "No fields configured for this school",
          type: SnackBarType.error,
        );
        return;
      }

      // /// Filter only required fields
      // final List<SelectedFields> selectedFields = fields.where((e) {
      //   final fieldName = e.fieldName?.toLowerCase()??"";
      //   return fieldName == "adm. no" ||
      //       fieldName == "class" ||
      //       fieldName == "section";
      // }).toList();

      // if (selectedSession == null) {
      //   AppSnackBar.show(
      //     error: "Session not selected",
      //     type: SnackBarType.error,
      //   );
      //   return;
      // }
      final sessionsRes = await service.getSessions();
      sessions.value = sessionsRes.sessions ?? [];
      selectedSession = sessionsRes.defaultSession ?? "";
      await getClassAndSection(selectedSession!);

      fieldModel.clear(); // avoid duplicate fields

      for (final v in fields) {
        final isTextField =
            getFieldType(v.fieldType ?? "") == FieldType.textField;
        final hintText = isTextField
            ? "Enter ${v.fieldName?.toLowerCase()}"
            : "Select ${v.fieldName?.toLowerCase()}";

        fieldModel.add(
          FieldModel(
            title: v.fieldName ?? "",
            hint: hintText,
            enforcementType: v.enforceType ?? false,
            isRequired: v.isRequired ?? false,
            controller: TextEditingController(),
            validator: (value) {
              final isRequired = v.isRequired ?? false;

              final fieldName = (v.fieldName ?? "").toLowerCase();

              if (isRequired && (value == null || value.trim().isEmpty)) {
                return hintText;
              }

              /// Aadhaar validation
              if (fieldName == "aadhar no") {
                final val = value?.trim() ?? "";

                if (val.isEmpty) return null; // already handled above

                if (val.length != 12) {
                  return "Aadhaar number must be 12 digits";
                }

                if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                  return "Aadhaar must contain only digits";
                }
              }

              return null;
            },
            keyboardType: isTextField ? TextInputType.text : TextInputType.none,
            type: getFieldType(v.fieldType ?? ""),
          ),
        );
      }
    } catch (e, stack) {
      debugPrint("getSchoolUserRes error: $e");
      debugPrintStack(stackTrace: stack);

      AppSnackBar.show(
        error: "Something went wrong. Please try again.",
        type: SnackBarType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  FieldType getFieldType(String v) {
    switch (v.toLowerCase()) {
      case "String":
        return FieldType.textField;
      case "list":
        return FieldType.dropdown;
      case "date":
        return FieldType.datePicker;
      case "numeric":
        return FieldType.numeric;
      default:
        return FieldType.textField;
    }
  }

  Future<void> getUserFromLocal() async {
    final user = await SharedPrefs.instance.getTypedObject<LoginResponse>(
      AppConstants.user,
      (value) => LoginResponse.fromJson(value),
    );
    isParent.value = user?.user?.userType == 3;
  }

  void getFilterResponse() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    // Use a collection for-loop to build the map and filter empty values in one go
    final filterMap = {
      for (var element in fieldModel)
        if (element.controller.text.trim().isNotEmpty &&
            element.controller.text.trim().toLowerCase() != 'all')
          element.title
              .split(' ')
              .map((s) => s[0].toUpperCase() + s.substring(1).toLowerCase())
              .join(' '): element.controller.text
              .trim(),
    };
    // Build the request object
    final req = {
      "schoolid": schoolUser.value?.schoolId,
      "session": selectedSession,
      "batch": selectedBatch,
      "filterjson": jsonEncode(filterMap),
    };

    Get.toNamed(AppRoutes.idCard, arguments: req);
  }


  final batch = ["Batch1", "Batch2", "Batch3", "Batch4", "Batch5"];

  Future<void> getClassAndSection(String session) async {
    try {
      isOverlayLoading.value = true;

      final response = await service.getClassAndSection(
        session,
        schoolUser.value!.schoolId!,
      );

      // response[0] is the List of Classes
      // response[1] is the List of Sections
      if (response.length >= 2) {
        classList.addAll(List<String>.from(response[0]));
        sectionList.addAll(List<String>.from(response[1]));
      }

      isOverlayLoading.value = false;
      update(["class"]);
    } catch (e) {
      isOverlayLoading.value = false;
      AppSnackBar.show(error: e.toString(), type: SnackBarType.error);
    }
  }

  void logout() async {
    await SharedPrefs.instance.clear();
    Get.deleteAll(force: true);
    Get.offAllNamed(AppRoutes.login);
  }
}
