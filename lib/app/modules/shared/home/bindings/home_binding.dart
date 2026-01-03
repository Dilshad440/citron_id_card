import 'package:citron_id_card/app/config/network/dio_client.dart';
import 'package:citron_id_card/app/services/api_service.dart';
import 'package:get/get.dart';
import '../../../parent/add_id_card/controllers/add_id_card_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(service: ApiService(client: DioClient())),
    );
    Get.lazyPut(() => AddIdCardController());
  }
}
