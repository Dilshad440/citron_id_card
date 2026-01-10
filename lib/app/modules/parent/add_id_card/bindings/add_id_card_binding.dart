import 'package:citron_id_card/app/config/network/dio_client.dart';
import 'package:citron_id_card/app/services/api_service.dart';
import 'package:get/get.dart';
import '../controllers/add_id_card_controller.dart';

class AddIdCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddIdCardController>(
      () => AddIdCardController(service: ApiService(client: DioClient())),
    );
  }
}
