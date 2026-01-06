import 'dart:convert';

import 'package:citron_id_card/app/config/local/shared_prefs.dart';
import 'package:citron_id_card/app/core/constants/app_constants.dart';
import 'package:citron_id_card/app/core/utils/dialog_utils.dart';
import 'package:citron_id_card/app/modules/school/id_card/model/final%20_field_model.dart';
import 'package:flutter/cupertino.dart';
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
  List<String> classList = [];
  List<String> sectionList = [];

  @override
  void onInit() {
    getUserFromLocal();
    getSchoolUserRes();
    super.onInit();
  }

  void getSchoolUserRes() async {
    try {
      isLoading.value = true;
      final response = await service.getSchoolUsers();
      schoolUser.value = response.first;
      final selectedFields = List<String>.from(
        jsonDecode(schoolUser.value?.selectedFields ?? ""),
      );
      selectedFields.remove("Student Name");
      for (var v in selectedFields) {
        final hintText = getFieldType(v) == FieldType.textField
            ? "Enter ${v.toLowerCase()}"
            : "Select ${v.toLowerCase()}";
        fieldModel.add(
          FieldModel(
            title: v,
            hint: hintText,
            controller: TextEditingController(),
            validator: (value) =>
                value == null || value.isEmpty ? hintText : null,
            keyboardType: TextInputType.text,
            type: getFieldType(v),
          ),
        );
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      AppSnackBar.show(error: e, type: SnackBarType.error);
    }
  }

  FieldType getFieldType(String v) {
    switch (v.toLowerCase()) {
      case "adm. no" || "student name":
        return FieldType.textField;
      case "class" || "section" || "session" || "batch":
        return FieldType.dropdown;
      default:
        return FieldType.textField;
    }
  }

  void getUserFromLocal() async {
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
        if (element.controller.text.trim().isNotEmpty)
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

  final session = ["2025-2026", "2026-2027", "2027-2028", "2028-2029"];

  final batch = ["Batch1", "Batch2", "Batch3", "Batch4", "Batch5"];

  void getClassAndSection(String session) async {
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
