import 'package:citron_id_card/app/config/network/dio_client.dart';
import 'package:citron_id_card/app/services/api_service.dart';
import 'package:get/get.dart';
import '../../../parent/add_id_card/controllers/add_id_card_controller.dart';
import '../../../school/id_card/controllers/id_card_controller.dart';
import '../../home/controllers/home_controller.dart' show HomeController;
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  final bool loggedIn;

  LoginBinding({required this.loggedIn}); // ✅ fixed

  @override
  void dependencies() {
    // Register DioClient once
    Get.lazyPut<DioClient>(() => DioClient(), fenix: true);

    // Register ApiService once
    Get.lazyPut<ApiService>(
      () => ApiService(client: Get.find<DioClient>()),
      fenix: true,
    );

    // Login Controller
    Get.put(
      LoginController(apiService: Get.find()),
      permanent: true,
    );

    // Home Controller (only if logged in)
    if (loggedIn) {
      Get.put<HomeController>(HomeController(service: Get.find<ApiService>()));
      // Get.put(AddIdCardController(service: Get.find<ApiService>()));
    }
  }
}
