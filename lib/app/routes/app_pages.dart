import '../modules/parent/add_id_card/bindings/add_id_card_binding.dart';
import '../modules/parent/add_id_card/views/add_id_card_view.dart';
import '../modules/parent/add_id_card/views/enter_admission_number_view.dart';
import '../modules/school/id_card/bindings/id_card_binding.dart';
import '../modules/school/id_card/views/id_card_view.dart';
import '../modules/shared/home/bindings/home_binding.dart';
import '../modules/shared/home/views/home_view.dart';
import '../modules/shared/login/bindings/login_binding.dart';
import '../modules/shared/login/views/login_view.dart';
import '../modules/shared/splash/bindings/splash_binding.dart';
import '../modules/shared/splash/views/splash_view.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(loggedIn: false),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.idCard,
      page: () => const IdCardView(),
      binding: IdCardBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.addIdCard,
      page: () => const AddIdCardView(),
      binding: AddIdCardBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.enterAdmissionNumber,
      page: () => const EnterAdmissionNumberView(),
      binding: AddIdCardBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
