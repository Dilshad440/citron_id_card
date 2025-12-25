import 'package:citron_id_card/app/core/theme/app_theme.dart';
import 'package:citron_id_card/app/modules/add_id_card/bindings/add_id_card_binding.dart';
import 'package:citron_id_card/app/modules/login/bindings/login_binding.dart';
import 'package:citron_id_card/app/modules/splash/bindings/splash_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "ID Card Generator",
      initialRoute: AppRoutes.login,
      initialBinding: LoginBinding(),
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getAppTheme(),
      // themeMode: ThemeMode.system,
    );
  }
}
