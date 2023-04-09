import 'package:flutter/material.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/page_widgets/file_view.dart';

class ListFiles extends StatefulWidget {
  final List<String> urls;

  const ListFiles({Key? key, required this.urls}) : super(key: key);

  @override
  State<ListFiles> createState() => _ListFilesState();
}

class _ListFilesState extends State<ListFiles> {
  late List<String> _urls;

  @override
  void initState() {
    _urls = widget.urls;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ListFiles oldWidget) {
    _urls = widget.urls;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_urls.isEmpty) {
      return const Center(
        child: Text('empty_list'),
      );
    }
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _urls.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: FileView(url: _urls.elementAt(index))),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
