import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class FilesRepository {
  Future<List<int>> downloadFile(
    String url,
    Function(int received, int total)? onProgressFunction,
  );
}

@Injectable(as: FilesRepository)
class DioFilesRepository implements FilesRepository {
  final Dio _dio;

  DioFilesRepository(this._dio);

  @override
  Future<List<int>> downloadFile(
    String url,
    Function(int received, int total)? onProgressFunction,
  ) async {
    final response = await _dio.get<List<int>>(
      url,
      onReceiveProgress: onProgressFunction,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    return response.data!;
  }
}
