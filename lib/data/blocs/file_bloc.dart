import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:surf_flutter_study_jam_2023/data/repository/files_repository.dart';
import 'package:surf_flutter_study_jam_2023/logging.dart';

abstract class FileEvent {}

class FileDownloadEvent extends FileEvent {
  final String url;
  final Function(int received, int total)? onProgressFunction;

  FileDownloadEvent(this.url, this.onProgressFunction);
}

abstract class FileState {}

class ProgressFileState extends FileState{}

class SuccessDownloadFile extends FileState {
  final File file;

  SuccessDownloadFile(this.file);
}

class ErrorDownloadFile extends FileState {}

class FileInitial extends FileState {}

class FileBloc extends Bloc<FileEvent, FileState> {
  final _logger = getLogger(FileBloc);
  final FilesRepository _filesRepository;

  FileBloc({required FilesRepository filesRepository})
      : _filesRepository = filesRepository,
        super(FileInitial()) {
    on<FileDownloadEvent>(_downloadFile);
  }

  Future<void> _downloadFile(
    FileDownloadEvent event,
    Emitter<FileState> emit,
  ) async {
    emit(ProgressFileState());
    final fileName = event.url.split('/').last;
    try {
      final bytes = await _filesRepository.downloadFile(
        event.url,
        event.onProgressFunction,
      );
      _logger.fine('Downloaded file bytes size: ${bytes.length}');
      final result = await _handleFile(bytes, fileName);
      emit(SuccessDownloadFile(result));
    } catch (e, st) {
      _logger.severe('Error load file $fileName', e, st);
      emit(ErrorDownloadFile());
    }
  }

  Future<dynamic> _handleFile(
    List<int> bytes,
    String fileName,
  ) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    _logger.fine('Temporary order file created: $file');
    return file;
  }
}
