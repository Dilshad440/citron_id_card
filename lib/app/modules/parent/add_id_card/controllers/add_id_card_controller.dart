import 'dart:convert';
import 'dart:io';

import 'package:citron_id_card/app/core/utils/dialog_utils.dart';
import 'package:citron_id_card/app/modules/parent/add_id_card/model/id_card_field_model.dart';
import 'package:citron_id_card/app/modules/school/id_card/model/student_id_model.dart';
import 'package:citron_id_card/app/modules/shared/home/controllers/home_controller.dart';
import 'package:citron_id_card/app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/common_utils.dart';

class AddIdCardController extends GetxController {
  final ApiService service;

  AddIdCardController({required this.service});

  List<IdCardFieldModel> fields = [];
  StudentIdModel? student;

  File? selectedImage;
  String? studentPhoto;

  final builderId = "addIdCard";
  final fieldUpdate = 'filedUpdate';
  bool isLoading = false;
  late String selectedBatch;
  late String selectedSession;

  final formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController admissionController = TextEditingController();

  @override
  void onInit() {
    student = Get.arguments;
    studentPhoto = student?.photo;
    selectedBatch = batch.first;
    selectedSession = session.first;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getSelectedFields();
    });

    super.onInit();
  }

  void getSelectedFields() async {
    final schoolUser = Get.find<HomeController>().schoolUser.value;
    try {
      isLoading = true;
      DialogUtils.showLoading();
      update([fieldUpdate]);
      final studentData = student?.data?.toJson() ?? {};
      final result = await service.getSelectedFields(schoolUser!.schoolId!);
      for (var v in result) {
        final text = studentData[v].toString();
        fields.add(
          IdCardFieldModel(
            title: v,
            hint: "Enter ${v.toLowerCase()}",
            controller: TextEditingController(text: text),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter ${v.toLowerCase()}";
              }
              return null;
            },
            fieldKey: GlobalKey(),
          ),
        );
      }
      isLoading = false;
      update([fieldUpdate]);
      DialogUtils.hideLoading();
    } catch (e) {
      isLoading = false;
      update([fieldUpdate]);
      DialogUtils.hideLoading();
      AppSnackBar.show(error: e);
    }
  }

  Future<bool> onSubmit() async {
    try {
      DialogUtils.showLoading();

      final homeController = Get.find<HomeController>();
      final schoolUser = homeController.schoolUser.value;

      if (schoolUser == null) {
        Get.snackbar('Error', 'School user not found');
        return false;
      }

      final Map<String, dynamic> requestStaticData = {
        'schoolId': schoolUser.schoolId,
        'session': selectedSession,
        'batch': selectedBatch,
      };

      final Map<String, dynamic> requestData = {
        for (final field in fields) field.title: field.controller.text.trim(),
      };

      final Map<String, dynamic> finalRequest = {
        ...requestStaticData,
        'data': requestData,
      };

      final response = await service.addIdCard(finalRequest);

      final stdId = response.data['id'];
      final photoBase64 = await _fileToBase64(selectedImage!);
      final uploadPhotoRes = await service.uploadPhoto(
        base64: photoBase64,
        stdId: stdId,
      );
      if (uploadPhotoRes.statusCode != 200) {
        print("Failed to upload photo");
      }

      Future.microtask(() {
        AppSnackBar.show(
          error: "Id card added successfully",
          type: SnackBarType.success,
        );
      });
      DialogUtils.hideLoading();
      return response.statusCode == 200;
    } catch (e) {
      DialogUtils.hideLoading();
      AppSnackBar.show(error: e, type: SnackBarType.error);
      return false;
    }
  }

  Future<bool> onEdit() async {
    try {
      DialogUtils.showLoading();
      final Map<String, dynamic> requestData = {
        for (final field in fields) field.title: field.controller.text.trim(),
      };

      final Map<String, dynamic> finalReq = {'Data': requestData};
      final response = await service.editIdCard(finalReq, student!.id!);
      if (selectedImage != null) {
        final photoBase64 = await _fileToBase64(selectedImage!);
        final uploadPhotoRes = await service.uploadPhoto(
          base64: photoBase64,
          stdId: student!.id!,
        );
        if (uploadPhotoRes.statusCode != 200) {
          print("Failed to upload photo");
        }
      }
      Future.microtask(() {
        AppSnackBar.show(
          error: "Id card added successfully",
          type: SnackBarType.success,
        );
      });
      DialogUtils.hideLoading();
      return response.statusCode == 200;
    } catch (e) {
      DialogUtils.hideLoading();
      AppSnackBar.show(error: e, type: SnackBarType.error);
      return false;
    }
  }

  Future<String> _fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> selectImage() async {
    await CommonUtils.showImagePickerBottomSheet(
      context: Get.context!,
      onImageSelected: (file) {
        selectedImage = File(file.path);
        update([builderId]);
      },
    );
  }

  void removePickedImage() {
    studentPhoto = null;
    selectedImage = null;
    update([builderId]);
  }

  final session = ["2025-2026", "2026-2027", "2027-2028", "2028-2029"];

  final batch = ["Batch1", "Batch2", "Batch3", "Batch4", "Batch5"];
}
