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
        final text = studentData[v]?.toString() ?? "";
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
    DialogUtils.showLoading();

    int? createdCardId;

    try {
      final homeController = Get.find<HomeController>();
      final schoolUser = homeController.schoolUser.value;

      if (schoolUser == null) {
        throw Exception('School user not found');
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

      /// 1️⃣ Create ID card
      final response = await service.addIdCard(finalRequest);

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('Failed to create ID card');
      }

      createdCardId = response.data['id'];

      /// 2️⃣ Upload photo (if exists)
      if (selectedImage != null) {
        final photoBase64 = await _fileToBase64(selectedImage!);

        final uploadPhotoRes = await service.uploadPhoto(
          base64: photoBase64,
          stdId: createdCardId!,
        );

        if (uploadPhotoRes.statusCode != 200) {
          throw Exception('Failed to upload photo');
        }
      }

      /// ✅ All APIs succeeded
      AppSnackBar.show(
        error: "ID card added successfully",
        type: SnackBarType.success,
      );

      return true;
    } catch (e) {
      /// 🔴 Rollback if card was created
      if (createdCardId != null) {
        try {
          await service.deleteCard(createdCardId);
          debugPrint("ID Card rolled back due to failure");
        } catch (deleteError) {
          debugPrint("Failed to rollback ID Card: $deleteError");
        }
      }
      final message = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e;
      AppSnackBar.show(error: message, type: SnackBarType.error);

      return false;
    } finally {
      DialogUtils.hideLoading();
    }
  }

  Future<bool> onEdit() async {
    DialogUtils.showLoading();
    try {
      if (student?.id == null) {
        throw 'Invalid student ID';
      }

      final Map<String, dynamic> requestData = {
        for (final field in fields) field.title: field.controller.text.trim(),
      };

      final Map<String, dynamic> finalReq = {
        'data': requestData, // keep key consistent with backend
      };

      /// 1️⃣ Update ID card data
      final response = await service.editIdCard(finalReq, student!.id!);

      if (response.statusCode != 200) {
        throw 'Failed to update ID card';
      }

      /// 2️⃣ Upload photo if selected
      if (selectedImage != null) {
        final photoBase64 = await _fileToBase64(selectedImage!);

        final uploadPhotoRes = await service.uploadPhoto(
          base64: photoBase64,
          stdId: student!.id!,
        );

        if (uploadPhotoRes.statusCode != 200) {
          throw 'Failed to upload photo';
        }
      }

      /// ✅ All APIs succeeded
      AppSnackBar.show(
        error: "ID card updated successfully",
        type: SnackBarType.success,
      );

      return true;
    } catch (e) {
      final message = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e;
      AppSnackBar.show(error: message, type: SnackBarType.error);
      return false;
    } finally {
      DialogUtils.hideLoading();
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
