import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:injectable/injectable.dart';
import 'package:surf_flutter_study_jam_2023/data/dio/dio_interceptors.dart';

@Singleton(as: Dio)
class ApiNativeDio extends DioForNative {
  ApiNativeDio() : super() {
    interceptors.addAll(DioInterceptors().interceptors);
  }
}
