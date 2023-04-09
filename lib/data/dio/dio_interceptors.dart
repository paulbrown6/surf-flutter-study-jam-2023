import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:surf_flutter_study_jam_2023/data/dio/api_error.dart';
import 'package:surf_flutter_study_jam_2023/logging.dart';

class DioInterceptors {
  final _logger = getLogger(DioInterceptors);
  List<Interceptor> interceptors = [];

  DioInterceptors() {
    interceptors.addAll([
      DioCacheInterceptor(
        options: CacheOptions(
          store: MemCacheStore(),
          policy: CachePolicy.request,
          hitCacheOnErrorExcept: [401, 403],
          maxStale: const Duration(days: 1),
          priority: CachePriority.normal,
          cipher: null,
          keyBuilder: CacheOptions.defaultCacheKeyBuilder,
          allowPostMethod: true,
        ),
      ),
      PrettyDioLogger(
          requestHeader: kDebugMode,
          requestBody: kDebugMode,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90),
      InterceptorsWrapper(
        onError: (dioError, errorHandler) {
          if (dioError.type == DioErrorType.connectionTimeout ||
              dioError.type == DioErrorType.sendTimeout ||
              dioError.type == DioErrorType.receiveTimeout ||
              dioError.error?.runtimeType == SocketException) {
            return errorHandler.next(ConnectionError(
                dioError: dioError, message: 'connection_error'.tr()));
          }
          final response = dioError.response;
          if (response != null) {
            final statusCode = response.statusCode;
            if (statusCode != null &&
                statusCode >= HttpStatus.badRequest &&
                statusCode <= HttpStatus.internalServerError) {
              if (response.data != null) {
                Map<String, dynamic>? map;
                if (response.data is String) {
                  try {
                    map = json.decode(response.data) as Map<String, dynamic>;
                  } catch (e, st) {
                    _logger.severe(
                      'An error occurred while parsing error response:',
                      e,
                      st,
                    );
                  }
                } else {
                  map = response.data as Map<String, dynamic>;
                }
                final message =
                    map?['reason'] ?? map?['message'] ?? 'unknown_error'.tr();
                return errorHandler
                    .next(ApiError(dioError: dioError, message: message));
              }
            }
          }
          return errorHandler.next(dioError);
        },
      ),
    ]);
  }
}
