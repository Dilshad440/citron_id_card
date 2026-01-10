import 'package:citron_id_card/app/routes/app_routes.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

typedef TokenProvider = Future<String?> Function();

class AuthInterceptor extends Interceptor {
  final TokenProvider tokenProvider;

  AuthInterceptor({required this.tokenProvider});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenProvider();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      Get.offAllNamed(AppRoutes.login);
    }
    super.onError(err, handler);
  }
}
