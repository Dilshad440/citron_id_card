import 'dart:convert';
import 'dart:io';

import 'package:citron_id_card/app/core/utils/dialog_utils.dart';
import 'package:citron_id_card/app/modules/school/id_card/model/student_id_model.dart';
import 'package:citron_id_card/app/modules/shared/home/controllers/home_controller.dart';
import 'package:citron_id_card/app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/common_utils.dart';
import '../../../school/id_card/model/final _field_model.dart';
import '../../../school/id_card/model/get_sessions.dart';

class AddIdCardController extends GetxController {
  final ApiService service;

  AddIdCardController({required this.service});

  List<FieldModel> fields = [];
  StudentIdModel? student;

  File? selectedImage;
  String? studentPhoto;

  final builderId = "addIdCard";
  final fieldUpdate = 'filedUpdate';
  bool isLoading = false;
  late String selectedBatch;
  String? selectedSession;

  final formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController admissionController = TextEditingController();
  Rxn<GetSessions> sessions = Rxn<GetSessions>();

  @override
  void onInit() {
    student = Get.arguments;
    studentPhoto = student?.photo;
    selectedBatch = batch.first;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getSession();
      getSelectedFields();
    });

    super.onInit();
  }


  void getSession()async{
    final sessionsRes = await service.getSessions();
    sessions.value = sessionsRes;
    selectedSession = sessionsRes.defaultSession ?? "";
  }

  void getSelectedFields() async {
    final schoolUser = Get.find<HomeController>().schoolUser.value;
    try {
      isLoading = true;
      DialogUtils.showLoading();
      update([fieldUpdate]);
      final studentData = student?.data?.toJson() ?? {};
      final result = await service.getSelectedFields(schoolUser!.schoolId!);
      // for (var v in result.selectedFields??[]) {
      //   final text = studentData[v]?.toString() ?? "";
      //   fields.add(
      //     IdCardFieldModel(
      //       title: v,
      //       hint: "Enter ${v.toLowerCase()}",
      //       controller: TextEditingController(text: text),
      //       validator: (value) {
      //         if (value == null || value.isEmpty) {
      //           return "Please Enter ${v.toLowerCase()}";
      //         }
      //         return null;
      //       },
      //       fieldKey: GlobalKey(),
      //     ),
      //   );
      // }

      for (final v in result.selectedFields ?? []) {
        final isTextField =
            getFieldType(v.fieldType ?? "") == FieldType.textField;
        final hintText = isTextField
            ? "Enter ${v.fieldName?.toLowerCase()}"
            : "Select ${v.fieldName?.toLowerCase()}";
        final studentValue = v.fieldName;
        final text = studentData[studentValue]?.toString() ?? "";
        fields.add(
          FieldModel(
            title: v.fieldName ?? "",
            hint: hintText,
            enforcementType: v.enforceType ?? false,
            isRequired: v.isRequired ?? false,
            controller: TextEditingController(text: text),
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

  Future<bool> onSubmit() async {
    DialogUtils.showLoading();

    int? createdCardId;

    try {
      final homeController = Get.find<HomeController>();
      final schoolUser = homeController.schoolUser.value;

      if (schoolUser == null) {
        throw Exception('School user not found');
      }

      final Map<String, dynamic> requestData = {
        'schoolId': schoolUser.schoolId,
        'session': selectedSession,
        'batch': selectedBatch,
        "data": {
          for (final field in fields)
            field.title: _formatValue(
              field.title,
              field.controller.text.trim(),
            ),
        },
      };

      /// 1️⃣ Create ID card
      final response = await service.addIdCard(requestData);

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

  String _formatValue(String title, String value) {
    final key = title.trim().toLowerCase();

    if (key == "dob" || key.contains("date")) {
      try {
        final parsed = DateFormat("dd-MM-yyyy").parseStrict(value);
        return DateFormat("yyyy-MM-dd").format(parsed);
      } catch (e) {
        print("Date parse failed for $title: $value");
        return value;
      }
    }

    return value;
  }

  Future<bool> onEdit() async {
    DialogUtils.showLoading();
    try {
      if (student?.id == null) {
        throw 'Invalid student ID';
      }

      final Map<String, dynamic> requestData = {
        "data": {
          for (final field in fields)
            field.title: _formatValue(
              field.title,
              field.controller.text.trim(),
            ),
        },
      };

      final response = await service.editIdCard(requestData, student!.id!);

      if (response.statusCode != 200) {
        throw 'Failed to update ID card';
      }

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

      AppSnackBar.show(
        error: "ID card updated successfully",
        type: SnackBarType.success,
      );

      return true; // ✅ FIX
    } catch (e) {
      AppSnackBar.show(
        error: e.toString().replaceFirst('Exception: ', ''),
        type: SnackBarType.error,
      );
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

  final batch = ["Batch1", "Batch2", "Batch3"];
}
