/// ===============================================
/// main.dart
/// ===============================================

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:citron_id_card/app/config/app_config.dart';
import 'package:citron_id_card/app/config/local/shared_prefs.dart';
import 'package:citron_id_card/app/config/network/dio_client.dart';
import 'package:citron_id_card/app/core/constants/app_constants.dart';
import 'package:citron_id_card/app/core/theme/app_theme.dart';
import 'package:citron_id_card/app/core/utils/common_utils.dart';
import 'package:citron_id_card/app/modules/shared/login/bindings/login_binding.dart';
import 'package:citron_id_card/app/modules/shared/login/model/login_response.dart';
import 'package:citron_id_card/app/routes/app_pages.dart';
import 'package:citron_id_card/app/routes/app_routes.dart';
import 'package:citron_id_card/app/services/api_service.dart';
import 'package:citron_id_card/app/services/local/sqf_lite_service.dart';

import 'package:flutter/material.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ============================
  /// INIT BACKGROUND SERVICE
  /// ============================

  await initializeBackgroundService();

  /// ============================
  /// APP DEPENDENCIES
  /// ============================

  AppConfig.injectDependency();

  final user = await SharedPrefs.instance.getTypedObject(
    AppConstants.user,
    (value) => LoginResponse.fromJson(value),
  );

  runApp(MyApp(user: user));
}

/// ===============================================
/// INITIALIZE BACKGROUND SERVICE
/// ===============================================

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      autoStartOnBoot: true,
      isForegroundMode: true,
      notificationChannelId: 'citron_sync_service',
      initialNotificationTitle: 'Citron Sync',
      initialNotificationContent: 'Syncing data in background...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(),
  );

  // ❌ DO NOT call this when autoStart is true
  // await service.startService();
}

/// ===============================================
/// BACKGROUND START FUNCTION
/// ===============================================

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  Timer.periodic(const Duration(minutes: 1), (timer) async {
    await addIdCard();
  });
}

Future<void> addIdCard() async {
  try {
    final dbService = SqfLiteService();

    /// ========================
    /// FETCH UNSYNCED RECORDS
    /// ========================

    final records = await dbService.getFromDb();

    print("Pending Records Count: ${records.length}");
    int? schoolId;
    final List<Map<String, dynamic>> recordsList = records.map((e) {
      schoolId = e.schoolId ?? 0;
      return e.records;
    }).toList();
    print("Json Data:::${jsonEncode(recordsList)}");
    print("SchoolID:::$schoolId");
    final requestData = {"schoolId": schoolId, "records": recordsList};

    if (records.isEmpty || recordsList.isEmpty) {
      print("No Pending Records");

      return;
    }

    final apiService = ApiService(client: DioClient());

    try {
      print("Uploading Record");

      /// ========================
      /// ADD CARD API
      /// ========================

      final response = await apiService.addIdCard(requestData);
      if (response.statusCode == 200) {
        ///
      }
    } catch (e) {
      print("Error $e");
    }
  } catch (e) {
    print("Error${e}");
  }
}

/// ===============================================
/// APP
/// ===============================================

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
