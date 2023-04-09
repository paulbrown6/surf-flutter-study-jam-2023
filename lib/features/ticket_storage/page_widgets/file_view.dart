import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_flutter_study_jam_2023/data/blocs/file_bloc.dart';
import 'package:surf_flutter_study_jam_2023/data/repository/files_repository.dart';
import 'package:surf_flutter_study_jam_2023/data/utils/pair.dart';
import 'package:surf_flutter_study_jam_2023/di.dart';
import 'package:surf_flutter_study_jam_2023/features/pdf_view/pdf_view_page.dart';

class FileView extends StatefulWidget {
  final String url;

  const FileView({Key? key, required this.url}) : super(key: key);

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  late final String _fileName;
  late final StreamController<Pair<double, double>> _progressController;
  late final FileBloc _fileBloc;

  @override
  void initState() {
    _fileName = widget.url.split('/').last.split('.').first;
    _progressController = StreamController<Pair<double, double>>.broadcast();
    _fileBloc = FileBloc(filesRepository: getIt<FilesRepository>());
    super.initState();
  }

  @override
  void dispose() async {
    await _progressController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FileBloc>(
      create: (context) => _fileBloc,
      child: BlocListener<FileBloc, FileState>(
        listener: (context, state) {
          if (state is SuccessDownloadFile) {
            setState(() {});
          }
        },
        child: InkWell(
          onTap: _onTapFile(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.file_copy_outlined,
                    size: 16,
                  ),
                ),
                Expanded(
                  child: BlocBuilder<FileBloc, FileState>(
                    builder: (context, state) {
                      if (state is ProgressFileState) {
                        return StreamBuilder(
                          stream: _progressController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<Pair<double, double>> snapshot) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(_fileName)),
                                if (snapshot.data != null) ...[
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: LinearProgressIndicator(
                                        value:
                                            _convertToPercent(snapshot.data!) /
                                                100,
                                        backgroundColor: Colors.grey,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  Text(
                                      '${snapshot.data?.first.toStringAsFixed(2)} mb '
                                      '/ ${snapshot.data?.second.toStringAsFixed(2)} mb'),
                                ],
                              ],
                            );
                          },
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(_fileName)),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: LinearProgressIndicator(
                                value: 0,
                                backgroundColor: state is SuccessDownloadFile ? Colors.green : Colors.grey,
                              ),
                            ),
                          ),
                          Text(_nameFromState(state)),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<FileBloc, FileState>(
                    builder: (context, state) {
                      if (state is SuccessDownloadFile) {
                        return const SizedBox.square(
                          dimension: 24,
                          child: Center(
                            child: Icon(
                              Icons.verified_outlined,
                              size: 16,
                              color: Colors.green,
                            ),
                          ),
                        );
                      }
                      return SizedBox.square(
                        dimension: 24,
                        child: IconButton(
                          onPressed: () {
                            if (state is ProgressFileState) {
                              return;
                            }
                            BlocProvider.of<FileBloc>(context)
                                .add(FileDownloadEvent(
                              widget.url,
                              _changeDownloadProgress,
                            ));
                          },
                          icon: Icon(
                            Icons.cloud_download_outlined,
                            size: 16,
                            color: (state is ProgressFileState)
                                ? Colors.grey
                                : Colors.blue,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeDownloadProgress(int count, int total) {
    var progressDownloadCount = count / 1000000;
    var progressDownloadTotal = total / 1000000;
    _progressController.add(Pair(progressDownloadCount, progressDownloadTotal));
  }

  double _convertToPercent(Pair<double, double> pair) {
    return (pair.first * 100) / pair.second;
  }

  String _nameFromState(FileState state) {
    switch (state.runtimeType) {
      case SuccessDownloadFile:
        return 'success_download'.tr();
      case ErrorDownloadFile:
        return 'error_download'.tr();
      default:
        return 'wait_download'.tr();
    }
  }

  Function()? _onTapFile() {
    if (_fileBloc.state is SuccessDownloadFile) {
      var file = (_fileBloc.state as SuccessDownloadFile).file;
      return () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PdfViewPage(
                filePath: file.path,
                fileName: _fileName,
              ),
            ),
          );
    }
    return null;
  }
}
