/// ===============================================
/// main.dart
/// ===============================================

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:citron_id_card/app/config/app_config.dart';
import 'package:citron_id_card/app/config/local/shared_prefs.dart';
import 'package:citron_id_card/app/config/network/dio_client.dart';
import 'package:citron_id_card/app/core/constants/app_constants.dart';
import 'package:citron_id_card/app/core/theme/app_theme.dart';
import 'package:citron_id_card/app/core/utils/common_utils.dart';
import 'package:citron_id_card/app/modules/school/id_card/model/records_uploaded_res.dart';
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

import 'app/modules/school/id_card/model/offline_cards_model.dart';

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
    final apiService = ApiService(client: DioClient());

    final schoolId = await SharedPrefs.instance.getInt(AppConstants.schoolId);
    if(schoolId==null) return;
    /// Fetch pending records
    final records = await dbService.getFromDb(schoolId: schoolId);

    if (records.isEmpty) {
      print("No Pending Records");
      return;
    }

    print("Pending Records Count: ${records.length}");

    /// Local DB ID -> OfflineCardsModel
    final Map<int, OfflineCardsModel> recordsMap = {
      for (final record in records)
        if (record.id != null) record.id!: record,
    };

    final List<int> offlineIds =
    records.where((e) => e.id != null).map((e) => e.id!).toList();


    final List<Map<String, dynamic>> recordsList = records.map((record) {
      return {
        "OfflineId": record.id,
        ...record.records,
      };
    }).toList();

    final requestData = {
      "schoolId": schoolId,
      "records": recordsList,
    };

    print("Request: ${jsonEncode(requestData)}");

    /// Upload records
    final response = await apiService.addIdCard(requestData);

    if (response.statusCode != 200) {
      print("Record Upload Failed");
      return;
    }

    final uploadResponse = RecordsUploadRes.fromJson(response.data);

    /// Prepare photo upload request
    final List<Map<String, dynamic>> imageRequest = [];

    for (final created in uploadResponse.createdIds ?? []) {
      final localRecord = recordsMap[created.offlineId];

      if (localRecord == null) {
        print("Local record not found for OfflineId ${created.offlineId}");
        continue;
      }

      final image = localRecord.selectedImage;

      if (image == null) {
        print("No image found for OfflineId ${created.offlineId}");
        continue;
      }

      imageRequest.add({
        "idRecordId": created.id,
        "base64Photo": await CommonUtils.fileToBase64(image),
      });
    }

    print("Photo Upload Request: ${jsonEncode(imageRequest)}");

    if (imageRequest.isEmpty) {
      print("No images to upload.");
      await dbService.deleteMultipleFromDb(ids: offlineIds);
      return;
    }

    /// Upload photos
    final imageResponse = await apiService.uploadBulkPhoto(
      request: {
        "schoolId": schoolId,
        "photos": imageRequest,
      },
    );

    if (imageResponse.statusCode == 200) {
      print("Image Upload Success");

      await dbService.deleteMultipleFromDb(ids: offlineIds);

      print("Offline records deleted successfully.");
    } else {
      print("Image Upload Failed");
    }
  } catch (e, stackTrace) {
    print("addIdCard Error: $e");
    print(stackTrace);
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
