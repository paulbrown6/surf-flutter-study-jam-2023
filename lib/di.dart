import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:surf_flutter_study_jam_2023/data/repository/database_repository.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies(String environment) async {
  getIt.init(environment: environment);
  var database = await HaveDatabaseRepository.create();
  getIt.registerSingleton<DatabaseRepository>(database);
}
