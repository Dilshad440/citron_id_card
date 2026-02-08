import 'dart:io';
import 'package:citron_id_card/app/core/constants/asset_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_colors.dart';

class CommonUtils {
  static bool _isLoading = false;

  static Future<void> show() async {
    if (_isLoading) return;
    _isLoading = true;

    // Use Get.dialog for better compatibility with Get.back()
    await Get.dialog(
      PopScope(
        canPop: false, // Replaces WillPopScope in newer Flutter versions
        child: Center(
          child: SpinKitWaveSpinner(
            size: 80,
            color: AppColors.generateGradientColors().first,
            child: Image.asset(AssetConstant.logo),
          ),
        ),
      ),
      barrierDismissible: false,
      name: "loading-dialog", // Giving it a name helps GetX track it
    );
  }

  static void hide() {
    if (_isLoading) {
      _isLoading = false;

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  static Future<void> showImagePickerBottomSheet({
    required BuildContext context,
    required Function(File file) onImageSelected,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.bottomCenter,
          insetPadding: EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 15,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Please select image source",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Divider(),
                    const SizedBox(height: 8),

                    /// ---- CAMERA TILE ----
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            offset: Offset(0, 3),
                            color: Colors.black.withOpacity(0.15),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 28,
                        ),
                        title: const Text(
                          "Camera",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () async {
                          Get.back();
                          final xFile = await pickImage();
                          if (xFile == null) return;

                          onImageSelected.call(xFile);
                        },
                      ),
                    ),

                    /// ---- GALLERY TILE ----
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            offset: Offset(0, 3),
                            color: Colors.black.withOpacity(0.15),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 28,
                        ),
                        title: const Text(
                          "Gallery",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () async {
                          final xFile = await pickImage(
                            source: ImageSource.gallery,
                          );
                          if (xFile == null) return;
                          onImageSelected.call(xFile);
                          Get.back();
                        },
                      ),
                    ),

                    // const SizedBox(height: 15),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool> checkPermission(ImageSource source) async {
    // Use specific photo permissions for modern Android (API 33+)
    Permission permission = (source == ImageSource.camera)
        ? Permission.camera
        : (Platform.isIOS ? Permission.photos : Permission.photos);

    // Simplified logic: request immediately if not granted
    final status = await permission.request();

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return status.isGranted;
  }

  static Future<File?> pickImage({
    ImageSource source = ImageSource.camera,
  }) async {
    if (!await checkPermission(source)) return null;

    final image = await ImagePicker().pickImage(source: source);

    if (image == null) return null;

    final croppedFile = await cropImage(image.path);
    if (croppedFile == null) return null;

    // CommonUtils.show();
    // await BackgroundRemover.instance.initializeOrt();

    // // REMOVE BACKGROUND
    // final fileBytes = File(croppedFile.path).readAsBytesSync();
    // final result = await BackgroundRemover.instance.removeBgBytes(fileBytes);

    // // FIX: Convert Uint8List (bytes) to a physical File
    // final tempDir = await getTemporaryDirectory();
    // final fileName = "${DateTime.now().millisecondsSinceEpoch}_no_bg.png";
    // final file = File(p.join(tempDir.path, fileName));
    // CommonUtils.hide();
    return File(croppedFile.path);
    ;
  }

  static Future<XFile?> cropImage(String path) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: path,
      maxWidth: 390,
      maxHeight: 480,
      compressQuality: 65,
      compressFormat: ImageCompressFormat.png,
      aspectRatio: const CropAspectRatio(ratioX: 3.25, ratioY: 4),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Crop Image",
          toolbarColor: AppColors.generateGradientColors().last,
          toolbarWidgetColor: AppColors.generateGradientColors().first,
          initAspectRatio: CropAspectRatioPreset.original,
          activeControlsWidgetColor: AppColors.red,
          backgroundColor: AppColors.generateGradientColors().first.withOpacity(
            0.5,
          ),
          cropFrameColor: AppColors.generateGradientColors().last,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: "Crop Image", aspectRatioLockEnabled: true),
      ],
    );

    return cropped != null ? XFile(cropped.path) : null;
  }
}
