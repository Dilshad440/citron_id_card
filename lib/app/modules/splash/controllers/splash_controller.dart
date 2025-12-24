import 'package:citron_id_card/app/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToLogin();
  }

  void _navigateToLogin() {
    // Wait 2 seconds then navigate to login
    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(AppRoutes.login);
    });
  }
}

