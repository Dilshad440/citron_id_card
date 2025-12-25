import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/utils/common_utils.dart';
import '../model/id_card_field_model.dart';

class AddIdCardController extends GetxController {
  File? selectedImage;

  final builderId = "addIdCard";

  final formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  final TextEditingController admissionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> selectImage() async {
    await CommonUtils.showImagePickerBottomSheet(
      context: Get.context!,
      onImageSelected: (file) {
        selectedImage = File(file.path);
        update([builderId]);
        Get.back();
      },
    );
  }

  void removePickedImage() {
    selectedImage = null;
    update([builderId]);
  }

  String? requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  String? mobileValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Mobile number is required";
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return "Enter a valid 10 digit mobile number";
    }
    return null;
  }

  String? aadhaarValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Aadhaar number is required";
    }
    if (!RegExp(r'^\d{12}$').hasMatch(value)) {
      return "Enter a valid 12 digit Aadhaar number";
    }
    return null;
  }

  String? panValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "PAN number is required";
    }
    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(value)) {
      return "Enter a valid PAN number";
    }
    return null;
  }
}
