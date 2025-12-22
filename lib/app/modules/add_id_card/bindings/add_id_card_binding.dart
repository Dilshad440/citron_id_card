import 'package:get/get.dart';
import '../controllers/add_id_card_controller.dart';

class AddIdCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddIdCardController>(
      () => AddIdCardController(),
    );
  }
}
