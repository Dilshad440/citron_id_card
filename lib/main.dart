import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/config/app_config.dart';
import 'app/core/theme/app_theme.dart';
import 'app/modules/login/bindings/login_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
  AppConfig.injectDependency();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Citron IdCard',
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      initialBinding: LoginBinding(),
      theme: AppTheme.getAppTheme(),
      home: const _DefaultHome(),
    );
  }
}

class _DefaultHome extends StatelessWidget {
  const _DefaultHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello GetX')),
      body: const Center(child: Text('Starter')),
    );
  }
}
