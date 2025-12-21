import 'package:dio/dio.dart';

import 'client_interceptor.dart';

class RestClient {
  late Dio dio;
  final String? baseUrl;
  static RestClient? _instance;

  RestClient._({this.baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl!,
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    dio.interceptors.add(ClientInterceptors());
  }

  static RestClient getInstance({String? baseUrl}) {
    if (_instance != null) {
      return _instance!;
    }

    _instance = RestClient._(baseUrl: baseUrl);
    return _instance!;
  }
}
