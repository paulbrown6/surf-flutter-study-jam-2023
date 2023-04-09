import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

abstract class DatabaseRepository {
  Future<List<String>> loadUrls();

  Future<List<String>> loadFilePaths();

  Future<void> saveFilePath(String name, String path);

  Future<void> saveFileUrl(String name, String url);

  Future<void> deleteFilePath(String name);

  Future<void> deleteFileUrl(String name);
}

class HaveDatabaseRepository extends DatabaseRepository {
  late final Box boxFiles;
  late final Box boxUrls;

  HaveDatabaseRepository._create();

  static Future<HaveDatabaseRepository> create() async {
    var component = HaveDatabaseRepository._create();
    final dir = await getTemporaryDirectory();
    Hive.init(dir.path);
    component.boxFiles = await Hive.openBox('files');
    component.boxUrls = await Hive.openBox('urls');
    return component;
  }

  @override
  Future<void> deleteFilePath(String name) async {
    await boxFiles.delete(name);
  }

  @override
  Future<void> deleteFileUrl(String name) async {
    await boxUrls.delete(name);
  }

  @override
  Future<void> saveFilePath(String name, String path) async {
    await boxUrls.put(name, path);
  }

  @override
  Future<void> saveFileUrl(String name, String url) async {
    await boxUrls.put(name, url);
  }

  @override
  Future<List<String>> loadFilePaths() async {
    List<String> files = boxFiles.values.map((e) => e.toString()).toList();
    return files;
  }

  @override
  Future<List<String>> loadUrls() async {
    List<String> urls = boxUrls.values.map((e) => e.toString()).toList();
    return urls;
  }
}
