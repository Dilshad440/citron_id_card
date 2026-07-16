import 'dart:io';

import 'package:citron_id_card/app/core/utils/dialog_utils.dart';
import 'package:citron_id_card/app/modules/school/id_card/model/offline_cards_model.dart';
import 'package:citron_id_card/app/modules/school/id_card/model/student_id_model.dart';
import 'package:citron_id_card/app/modules/shared/home/controllers/home_controller.dart';
import 'package:citron_id_card/app/services/api_service.dart';
import 'package:citron_id_card/app/services/local/sqf_lite_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
  late String? selectedBatch;
  String? selectedSession;
  Map<String, List<dynamic>> dropdownList = {};

  final formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController admissionController = TextEditingController();
  Rxn<GetSessions> sessions = Rxn<GetSessions>();
  int formResetVersion = 0;

  @override
  void onInit() {
    student = Get.arguments;
    studentPhoto = student?.photo;
    selectedBatch = batch.first;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getSelectedFields();
    });
    super.onInit();
  }

  Future<void> getSession() async {
    final sessionsRes = await service.getSessions();
    sessions.value = sessionsRes;
    selectedSession = sessionsRes.defaultSession ?? "";
  }

  Future<void> getSelectedFields() async {
    final schoolUser = Get.find<HomeController>().schoolUser.value;

    if (schoolUser?.schoolId == null) return;

    try {
      isLoading = true;
      DialogUtils.showLoading();
      update([fieldUpdate]);
      await getSession();
      final studentData = student?.data?.toJson() ?? {};
      final schoolId = schoolUser!.schoolId!;

      final result = await service.getSelectedFields(schoolId);

      fields.clear();
      dropdownList.clear();

      for (final field in result.selectedFields ?? []) {
        final fieldName = field.fieldName ?? "";
        final fieldNameLower = fieldName.toLowerCase();

        final fieldType = getFieldType(field.fieldType ?? "");

        if (fieldType == FieldType.list) {
          final dropdownValue = await service.getListValuesByFieldName(
            fieldName: fieldName,
            schoolId: schoolId,
          );

          dropdownList[fieldName] = List<dynamic>.from(
            dropdownValue['values'] ?? [],
          );
        }

        final isTextField = fieldType == FieldType.textField;

        final hintText = isTextField
            ? "Enter $fieldNameLower"
            : "Select $fieldNameLower";

        final text = studentData[fieldName]?.toString() ?? "";

        fields.add(
          FieldModel(
            title: fieldName,
            hint: hintText,
            enforcementType: field.enforceType ?? false,
            dropdownList: dropdownList,
            isRequired: field.isRequired ?? false,
            changedValue: (fieldType == FieldType.list && student != null)
                ? text
                : null,
            controller: TextEditingController(text: text),
            keyboardType: isTextField ? TextInputType.text : TextInputType.none,
            type: fieldType,
            validator: (value) {
              final val = value?.trim() ?? "";

              if ((field.isRequired ?? false) && val.isEmpty) {
                return hintText;
              }

              if (fieldNameLower == "aadhar no" && val.isNotEmpty) {
                if (val.length != 12) {
                  return "Aadhaar number must be 12 digits";
                }

                if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                  return "Aadhaar must contain only digits";
                }
              }

              return null;
            },
          ),
        );
      }
    } catch (e) {
      AppSnackBar.show(error: e);
    } finally {
      isLoading = false;
      update([fieldUpdate]);
      DialogUtils.hideLoading();
    }
  }

  FieldType getFieldType(String v) {
    switch (v.toLowerCase()) {
      case "String":
        return FieldType.textField;
      case "list":
        return FieldType.list;
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
        final photoBase64 = await CommonUtils.fileToBase64(selectedImage!);

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

  Future<bool> offlineSubmit() async {
    DialogUtils.showLoading();
    try {
      final homeController = Get.find<HomeController>();
      final schoolUser = homeController.schoolUser.value;

      if (schoolUser == null) {
        throw Exception('School user not found');
      }

      final Map<String, dynamic> requestData = {
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

      File? savedFileToAppDir = await copyFileToAppDir();

      final requestBody = OfflineCardsModel(
        records: requestData,
        schoolId: schoolUser.schoolId,
        selectedImage: savedFileToAppDir,
      );

      await SqfLiteService().insertIntoDb(requestBody);

      AppSnackBar.show(
        error: "ID card saved successfully",
        type: SnackBarType.success,
      );
      clearForm();
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

  void clearForm() {
    formKey.currentState?.reset();

    for (FieldModel field in fields) {
      field.controller.clear();
      field.changedValue = null;
    }

    admissionController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    selectedImage = null;
    studentPhoto = null;

    selectedBatch = batch.isNotEmpty ? batch.first : null;
    selectedSession = sessions.value?.defaultSession;
    formResetVersion++;

    update([fieldUpdate, builderId]);
  }

  Future<File?> copyFileToAppDir() async {
    try {
      if (selectedImage == null) return null;

      final sourceFile = File(selectedImage!.path);

      // Check source exists
      if (!await sourceFile.exists()) {
        print("Source image not found");
        return null;
      }

      final appDir = await getApplicationDocumentsDirectory();

      final imageDir = Directory('${appDir.path}/images');

      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      // Unique file name
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${basename(selectedImage!.path)}';

      final destinationPath = '${imageDir.path}/$fileName';

      final savedFile = await sourceFile.copy(destinationPath);

      return savedFile;
    } catch (e) {
      print("Copy Error: $e");
      return null;
    }
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
        final photoBase64 = await CommonUtils.fileToBase64(selectedImage!);
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
