import 'package:citron_id_card/app/config/local/shared_prefs.dart';
import 'package:citron_id_card/app/core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import '../../modules/shared/login/model/login_response.dart';
import 'interceptors/auth_interceptor.dart';
import 'api_constants.dart';

class DioClient {
  static final DioClient _instance = DioClient.getInstance();

  factory DioClient() => _instance;

  late final Dio dio;

  DioClient.getInstance({String? baseUrl}) {
    final options = BaseOptions(
      baseUrl: baseUrl ?? ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    dio = Dio(options);
    dio.interceptors.addAll([
      LogInterceptor(
        error: true,
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
      AuthInterceptor(
        tokenProvider: () async {
          final user = await SharedPrefs.instance.getTypedObject<LoginResponse>(
            AppConstants.user,
            (value) => LoginResponse.fromJson(value),
          );
          // TODO: Provide auth token here
          return user?.token;
        },
      ),
    ]);
  }
}
