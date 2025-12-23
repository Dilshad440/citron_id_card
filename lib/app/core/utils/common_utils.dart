import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CommonUtils {
  static Future<void> showImagePickerBottomSheet({
    required BuildContext context,
    required Function(XFile file) onImageSelected,
  }) {
    final ImagePicker picker = ImagePicker();
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
    Permission permission;

    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      // Gallery
      if (Platform.isIOS) {
        permission = Permission.photos;
      } else {
        permission = Permission.storage; // Android (safe fallback)
      }
    }

    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  static Future<XFile?> pickImage({
    ImageSource source = ImageSource.camera,
  }) async {
    final isGranted = await checkPermission(source);

    if (!isGranted) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        return null; // permission denied
      }
    }

    final image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );

    if (image == null) {
      return null; // user cancelled camera
    }

    final croppedImage = await cropImage(image.path);

    if (croppedImage == null) {
      return null; // user cancelled crop
    }

    return croppedImage;
  }

  static Future<XFile?> cropImage(String path) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: path,
      compressQuality: 50,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Crop Image",
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: false,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
        IOSUiSettings(
          title: "Crop Image",
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
      ],
    );

    if (cropped != null) {
      return XFile(cropped.path);
    }
    return null;
  }
}
