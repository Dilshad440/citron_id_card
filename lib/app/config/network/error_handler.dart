import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ErrorHandler {
  /// Returns a clean, user-friendly error message.
  ///
  /// IMPORTANT:
  /// This method NEVER returns DioException.toString(),
  /// Exception.toString(), stack traces, request URLs, or
  /// internal Dio/Web errors to the user.
  static String resolveMessage(dynamic error) {
    // ============================================================
    // 1. DIO EXCEPTION
    // ============================================================

    if (error is DioException) {
      return _resolveDioException(error);
    }

    // ============================================================
    // 2. SOCKET EXCEPTION
    // ============================================================

    if (error is SocketException) {
      return 'No internet connection. Please check your internet and try again.';
    }

    // ============================================================
    // 3. TIMEOUT EXCEPTION
    // ============================================================

    if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    }

    // ============================================================
    // 4. FORMAT EXCEPTION
    // ============================================================

    if (error is FormatException) {
      return 'Invalid response received. Please try again.';
    }

    // ============================================================
    // 5. FLUTTER ERROR
    // ============================================================

    if (error is FlutterError) {
      return 'Unexpected app error occurred. Please try again.';
    }

    // ============================================================
    // 6. STRING ERROR
    // ============================================================

    if (error is String) {
      final message = error.trim();

      if (message.isNotEmpty) {
        return message;
      }

      return 'Something went wrong. Please try again.';
    }

    // ============================================================
    // 7. GENERIC EXCEPTION
    // ============================================================

    if (error is Exception) {
      // NEVER do:
      //
      // return error.toString();
      //
      // because it can expose internal implementation details.

      return 'Something went wrong. Please try again.';
    }

    // ============================================================
    // 8. UNKNOWN ERROR
    // ============================================================

    return 'Something went wrong. Please try again.';
  }

  // ==============================================================
  // DIO ERROR HANDLER
  // ==============================================================

  static String _resolveDioException(DioException error) {
    // ------------------------------------------------------------
    // 1. CONNECTION / INTERNET ERRORS
    // ------------------------------------------------------------

    if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your internet and try again.';
    }

    // ------------------------------------------------------------
    // 2. CONNECTION TIMEOUT
    // ------------------------------------------------------------

    if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timed out. Please try again.';
    }

    // ------------------------------------------------------------
    // 3. SEND TIMEOUT
    // ------------------------------------------------------------

    if (error.type == DioExceptionType.sendTimeout) {
      return 'Request timed out. Please try again.';
    }

    // ------------------------------------------------------------
    // 4. RECEIVE TIMEOUT
    // ------------------------------------------------------------

    if (error.type == DioExceptionType.receiveTimeout) {
      return 'Server response timed out. Please try again.';
    }

    // ------------------------------------------------------------
    // 5. CANCELLED REQUEST
    // ------------------------------------------------------------

    if (error.type == DioExceptionType.cancel) {
      return 'Request was cancelled.';
    }

    // ------------------------------------------------------------
    // 6. HTTP RESPONSE
    // ------------------------------------------------------------

    final response = error.response;

    if (response != null) {
      final statusCode = response.statusCode;

      // ----------------------------------------------------------
      // 400
      // ----------------------------------------------------------

      if (statusCode == 400) {
        return _apiMessage(response) ??
            'Bad request. Please check the information and try again.';
      }

      // ----------------------------------------------------------
      // 401
      // ----------------------------------------------------------

      if (statusCode == 401) {
        return _apiMessage(response) ?? 'Session expired. Please login again.';
      }

      // ----------------------------------------------------------
      // 403
      // ----------------------------------------------------------

      if (statusCode == 403) {
        return _apiMessage(response) ??
            'You do not have permission to perform this action.';
      }

      // ----------------------------------------------------------
      // 404
      // ----------------------------------------------------------

      if (statusCode == 404) {
        return _apiMessage(response) ?? 'Requested resource was not found.';
      }

      // ----------------------------------------------------------
      // 408
      // ----------------------------------------------------------

      if (statusCode == 408) {
        return _apiMessage(response) ?? 'Request timed out. Please try again.';
      }

      // ----------------------------------------------------------
      // 409
      // ----------------------------------------------------------

      if (statusCode == 409) {
        return _apiMessage(response) ??
            'A conflict occurred. Please try again.';
      }

      // ----------------------------------------------------------
      // 422
      // ----------------------------------------------------------

      if (statusCode == 422) {
        return _apiMessage(response) ??
            'Invalid data. Please check the information and try again.';
      }

      // ----------------------------------------------------------
      // 429
      // ----------------------------------------------------------

      if (statusCode == 429) {
        return _apiMessage(response) ??
            'Too many requests. Please try again later.';
      }

      // ----------------------------------------------------------
      // 500
      // ----------------------------------------------------------

      if (statusCode == 500) {
        return _apiMessage(response) ??
            'Internal server error. Please try again later.';
      }

      // ----------------------------------------------------------
      // 502
      // ----------------------------------------------------------

      if (statusCode == 502) {
        return _apiMessage(response) ??
            'Server is temporarily unavailable. Please try again later.';
      }

      // ----------------------------------------------------------
      // 503
      // ----------------------------------------------------------

      if (statusCode == 503) {
        return _apiMessage(response) ??
            'Service is temporarily unavailable. Please try again later.';
      }

      // ----------------------------------------------------------
      // 504
      // ----------------------------------------------------------

      if (statusCode == 504) {
        return _apiMessage(response) ??
            'Server response timed out. Please try again later.';
      }

      // ----------------------------------------------------------
      // OTHER HTTP STATUS CODES
      // ----------------------------------------------------------

      final message = _apiMessage(response);

      if (message != null) {
        return message;
      }

      return 'Something went wrong. Please try again.';
    }

    // ------------------------------------------------------------
    // 7. DIO ERROR WITHOUT RESPONSE
    // ------------------------------------------------------------

    //
    // This is particularly important for Flutter Web.
    //
    // Example:
    //
    // DioException [connection error]:
    // The XMLHttpRequest onError callback was called...
    //
    // We NEVER return error.toString().
    //

    return 'Unable to connect to the server. Please check your internet connection and try again.';
  }

  // ==============================================================
  // API RESPONSE MESSAGE
  // ==============================================================

  static String? _apiMessage(Response response) {
    final data = response.data;

    if (data == null) {
      return null;
    }

    // ------------------------------------------------------------
    // API returns:
    //
    // {
    //   "message": "Student marks already submitted"
    // }
    // ------------------------------------------------------------

    if (data is Map) {
      final message = data['message'];

      if (message != null) {
        final value = message.toString().trim();

        if (value.isNotEmpty) {
          return value;
        }
      }

      // ----------------------------------------------------------
      // API returns:
      //
      // {
      //   "error": "Something went wrong"
      // }
      // ----------------------------------------------------------

      final error = data['error'];

      if (error != null) {
        final value = error.toString().trim();

        if (value.isNotEmpty) {
          return value;
        }
      }

      // ----------------------------------------------------------
      // Some APIs use:
      //
      // {
      //   "Message": "..."
      // }
      // ----------------------------------------------------------

      final capitalMessage = data['Message'];

      if (capitalMessage != null) {
        final value = capitalMessage.toString().trim();

        if (value.isNotEmpty) {
          return value;
        }
      }
    }

    // ------------------------------------------------------------
    // API returns a plain String
    // ------------------------------------------------------------

    if (data is String) {
      final value = data.trim();

      if (value.isNotEmpty) {
        return value;
      }
    }

    return null;
  }

  // ==============================================================
  // OPTIONAL: LOG FULL ERROR ONLY FOR DEBUGGING
  // ==============================================================

  static void logError(dynamic error, {StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('========== ERROR ==========');
      debugPrint(error.toString());

      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }

      debugPrint('===========================');
    }
  }
}
