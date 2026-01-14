import 'dart:convert';
import 'dart:io';

import 'package:citron_id_card/app/core/utils/dialog_utils.dart';
import 'package:citron_id_card/app/modules/shared/home/controllers/home_controller.dart';
import 'package:citron_id_card/app/services/api_service.dart';
import 'package:get/get.dart';

import '../../../../core/utils/common_utils.dart' show CommonUtils;
import '../model/student_id_model.dart';

class IdCardController extends GetxController {
  ApiService source;

  IdCardController({required this.source});

  List<StudentIdModel>? schoolIds;
  Map<String, dynamic> data = {};
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    data = Get.arguments;
    getIdCards();
    super.onInit();
  }

  void getIdCards() async {
    isLoading.value = true;
    update(["idCard"]);
    final response = await source.getSchoolId(data);
    schoolIds = response;
    isLoading.value = false;
    update(["idCard"]);
  }

  void expandCard(int index, bool expand) {
    schoolIds?[index].isExpanded = expand;
    update(['idCard']);
  }

  void deleteIdCard(int idCard) async {
    try {
      DialogUtils.showLoading();
      final response = await source.deleteCard(idCard);
      if(response.statusCode==200){
        AppSnackBar.show(error: "Id card deleted successfully");
        getIdCards();
      }
      DialogUtils.hideLoading();
    } catch (e) {
      DialogUtils.hideLoading();
      AppSnackBar.show(error: e, type: SnackBarType.error);
    }
  }

  void pickImage(int stdId, int index) {
    CommonUtils.showImagePickerBottomSheet(
      context: Get.context!,
      onImageSelected: (file) async {
        Get.back();
        try {
          isLoading.value = true;
          update(["idCard"]);
          final pickedFile = File(file.path);
          final base64 = await _fileToBase64(pickedFile);
          final response = await source.uploadPhoto(
            stdId: stdId,
            base64: base64,
          );
          if (response.statusCode == 200) {
            schoolIds?[index].selectedImg = pickedFile;
          }

          isLoading.value = false;
          update(["photo"]);
          update(["idCard"]);
        } catch (e) {
          isLoading.value = false;
          update(["idCard"]);
          AppSnackBar.show(error: e, type: SnackBarType.error);
        }
      },
    );
  }

  Future<String> _fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }
}
