import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:surf_flutter_study_jam_2023/data/repository/database_repository.dart';
import 'package:surf_flutter_study_jam_2023/di.dart';
import 'package:surf_flutter_study_jam_2023/features/widgets/modal_windows.dart';

import 'page_widgets/list_files.dart';

/// Экран “Хранения билетов”.
class TicketStoragePage extends StatefulWidget {
  const TicketStoragePage({Key? key}) : super(key: key);

  @override
  State<TicketStoragePage> createState() => _TicketStoragePageState();
}

class _TicketStoragePageState extends State<TicketStoragePage> {
  List<String> _urls = [];

  @override
  void initState() {
    _loadUrlsFromDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('files'.tr()),),
      body: ListFiles(
        urls: _urls,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUrl,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addUrl() {
    ModalWindows().showAddFileBottomSheet(
      context,
      (url) => setState(() {
        _urls.add(url);
        var fileName = url.split('/').last.split('.').first;
        getIt<DatabaseRepository>().saveFileUrl(fileName, url);
      }),
    );
  }

  void _loadUrlsFromDb() {
    getIt<DatabaseRepository>().loadUrls().then((value) => setState(() => _urls = value));
  }
}
