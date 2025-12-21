import 'package:citron_id_card/app/modules/id_card/bindings/id_card_binding.dart';
import 'package:citron_id_card/app/modules/login/bindings/login_binding.dart';
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
      title: "SalonPro Vendor App",
      initialRoute: AppRoutes.login,
      initialBinding: LoginBinding(),
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      themeMode: ThemeMode.system,
    );
  }
}
