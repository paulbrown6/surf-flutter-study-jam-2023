import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

setupLogger({Level level = Level.INFO, bool sentryReportException = false}) {
  Logger.root.level = level;
  Logger.root.onRecord.listen((record) async {
    debugPrint('${record.loggerName}: ${record.time}: ${record.message}');
    if (record.error != null) {
      debugPrint('${record.loggerName}: ${record.time}: ${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('${record.loggerName}: ${record.time}: ${record.stackTrace}');
    }
  });
}

Logger getLogger(Type type) => Logger(type.toString());
