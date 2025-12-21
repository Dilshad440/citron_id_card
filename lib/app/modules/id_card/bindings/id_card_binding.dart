import 'package:get/get.dart';
import '../controllers/id_card_controller.dart';

class IdCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IdCardController>(
      () => IdCardController(),
    );
  }
}
