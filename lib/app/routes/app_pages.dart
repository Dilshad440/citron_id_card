import '../modules/add_id_card/bindings/add_id_card_binding.dart';
import '../modules/add_id_card/views/add_id_card_view.dart';
import '../modules/id_card/bindings/id_card_binding.dart';
import '../modules/id_card/views/id_card_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
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
];
}
