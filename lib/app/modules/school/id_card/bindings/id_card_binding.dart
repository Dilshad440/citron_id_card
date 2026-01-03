import 'package:citron_id_card/app/config/network/dio_client.dart';
import 'package:citron_id_card/app/services/api_service.dart';
import 'package:get/get.dart';
import '../controllers/id_card_controller.dart';

class IdCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IdCardController>(
      () => IdCardController(source: ApiService(client: DioClient())),
    );
  }
}
