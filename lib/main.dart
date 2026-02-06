import 'package:citron_id_card/app/config/local/shared_prefs.dart';
import 'package:citron_id_card/app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/config/app_config.dart';
import 'app/core/theme/app_theme.dart';
import 'app/modules/shared/login/bindings/login_binding.dart';
import 'app/modules/shared/login/model/login_response.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.injectDependency();

  await SharedPrefs.instance
      .getTypedObject(
        AppConstants.user,
        (value) => LoginResponse.fromJson(value),
      )
      .then((value) {
        runApp(MyApp(user: value));
      });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.user});

  final LoginResponse? user;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Citron IdCard',
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.getInitialRoute(user),
      initialBinding: LoginBinding(loggedIn: user?.token != null),
      theme: AppTheme.getAppTheme(),
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
