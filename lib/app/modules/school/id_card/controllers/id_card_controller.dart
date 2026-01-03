import 'package:citron_id_card/app/modules/shared/home/controllers/home_controller.dart';
import 'package:citron_id_card/app/services/api_service.dart';
import 'package:get/get.dart';

import '../model/student_id_model.dart';

class IdCardController extends GetxController {
  ApiService source;

  IdCardController({required this.source});

  List<Records>? schoolIds;
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
    schoolIds = response.records;
    isLoading.value = false;
    update(["idCard"]);
  }

  void expandCard(int index, bool expand) {
    schoolIds?[index].isExpanded = expand;
    update(['idCard']);
  }
}
