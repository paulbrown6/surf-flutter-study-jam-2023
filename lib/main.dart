import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:surf_flutter_study_jam_2023/features/ticket_storage/ticket_storage_page.dart';
import 'di.dart';
import 'logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await configureDependencies(Environment.dev);
  setupLogger(level: Level.ALL);
  runApp(EasyLocalization(
      supportedLocales: const [Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      child: const MyApp()),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TicketStoragePage(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
