import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/utils/common_utils.dart';

class AddIdCardController extends GetxController {
  Rx<File?> selectedImage = Rx(null);

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> selectImage() async {
    await CommonUtils.showImagePickerBottomSheet(
      context: Get.context!,
      onImageSelected: (file) {
        selectedImage.value = File(file.path);
        Get.back();
      },
    );
  }
}
