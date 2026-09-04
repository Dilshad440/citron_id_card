import 'dart:convert';
import 'dart:io';
import 'package:citron_id_card/app/core/constants/asset_constant.dart';
import 'package:citron_id_card/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
    // if (!await checkPermission(source)) return null;

    final image = await ImagePicker().pickImage(source: source);

    if (image == null) return null;

    final compressQlty = await _showCompressionDialog();
    if (compressQlty == null) return null;

    final croppedFile = await cropImage(image.path, compressQlty);
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

  static Future<XFile?> cropImage(
    String path,
    CompressQlty? compressQlty,
  ) async {
    int compressQuality = _getCompressQlty(compressQlty);

    /// 65 us default
    final cropped = await ImageCropper().cropImage(
      sourcePath: path,
      maxWidth: 390,
      maxHeight: 480,
      compressQuality: compressQuality,
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

  static int _getCompressQlty(CompressQlty? compressQlty) {
    final compressQuality = compressQlty == CompressQlty.low
        ? 60
        : compressQlty == CompressQlty.medium
        ? 70
        : compressQlty == CompressQlty.medium
        ? 80
        : 65;

    /// 65 us default
    return compressQuality;
  }

  static String formatDateForUI(String apiDate) {
    try {
      final parsedDate = DateFormat("yyyy-MM-dd").parseStrict(apiDate);
      return DateFormat("dd-MM-yyyy").format(parsedDate);
    } catch (e) {
      return apiDate;
    }
  }

  static Future<String> fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  static Future<CompressQlty?> _showCompressionDialog() async {
    final colors = AppColors.generateGradientColors();

    return await Get.dialog<CompressQlty>(
      Dialog(
        alignment: Alignment.bottomCenter,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'Select Image Quality',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 4),

              Text(
                'Choose quality for your upload',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 14),

              _qualityCard(
                title: 'Low',
                subtitle: 'Smaller file size',
                quality: '60%',
                icon: Icons.compress_rounded,
                color: colors[2],
                onTap: () => Get.back(result: CompressQlty.low),
              ),

              const SizedBox(height: 8),

              _qualityCard(
                title: 'Medium',
                subtitle: 'Best balance',
                quality: '70%',
                icon: Icons.photo_rounded,
                color: colors[1],
                recommended: true,
                onTap: () => Get.back(result: CompressQlty.medium),
              ),

              const SizedBox(height: 8),

              _qualityCard(
                title: 'High',
                subtitle: 'Best image quality',
                quality: '80%',
                icon: Icons.hd_rounded,
                color: colors[2],
                onTap: () => Get.back(result: CompressQlty.high),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _qualityCard({
    required String title,
    required String subtitle,
    required String quality,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool recommended = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 22, color: color),
              ),

              const SizedBox(width: 12),

              // Title + subtitle
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        if (recommended) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Recommended',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 2),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Quality
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    quality,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const Text(
                    'quality',
                    style: TextStyle(fontSize: 9, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(width: 8),

              // Arrow
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum CompressQlty { low, medium, high }
