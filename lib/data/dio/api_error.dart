import 'package:dio/dio.dart';

class ApiError extends DioError {
  @override
  final String message;

  ApiError({required DioError dioError, required this.message})
      : super(
          type: dioError.type,
          error: dioError.error,
          response: dioError.response,
          requestOptions: dioError.requestOptions,
        );

  @override
  String toString() =>
      '$message, ${requestOptions.method}, ${requestOptions.path.toString()}, ${requestOptions.queryParameters}, ${requestOptions.data.toString()}';
}

class ConnectionError extends DioError {
  @override
  final String message;

  ConnectionError({required DioError dioError, required this.message})
      : super(
          type: dioError.type,
          error: dioError.error,
          response: dioError.response,
          requestOptions: dioError.requestOptions,
        );

  @override
  String toString() => '$message, ${requestOptions.method}, ${requestOptions.path.toString()}';
}
