import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ClientInterceptors extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
    debugPrint("#### Request for the Api::=> ${options.uri} \n${options.data.toString()}");
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);
    debugPrint("#### Error for the Api::=> ${err.requestOptions.path} \n${jsonEncode(err.response?.data)}");
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    debugPrint(
      "## Response of Endpoint::=> ${response.requestOptions.uri}\n Response::=> ${jsonEncode(response.data)}",
    );
  }
}
